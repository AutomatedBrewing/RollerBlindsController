/*
 * nvm.c - Minimal non-volatile object storage over a flash backend.
 *
 * Purpose
 * -------
 * Provides a small key/object-based API for persisting fixed-size values in
 * internal flash. The application defines the supported object IDs and sizes
 * in nvm.h and supplies a backend implementing read, write, and erase.
 * Backend operations must return 0 on success and a non-zero value on error.
 * Backend addresses are offsets relative to the NVM storage area.
 *
 * Features
 * --------
 * - Keeps the latest valid value of each configured object in a RAM cache.
 * - Recovers the cache at initialization by scanning committed flash records.
 * - Uses monotonically increasing sequence numbers to select the newest value
 *   when an object has been written more than once.
 * - Protects records with CRC-16 and a commit marker programmed last. The CRC
 *   and commit marker occupy separate flash programming units so an interrupted
 *   write is not accepted as a committed record.
 * - Appends new records without erasing flash for every update.
 * - Compacts storage when there is not enough space for a new record: the page
 *   is erased and the currently valid cached values are written back.
 * - Supports explicit formatting through nvm_format().
 *
 * On-flash record
 * ---------------
 * Each record contains an 8-byte header (magic, object ID, payload size, and
 * sequence number), a payload padded to the flash programming-unit boundary,
 * and two 8-byte footer units: CRC-16 followed by the commit marker. Multi-byte
 * fields are serialized in little-endian byte order. CRC-16 covers the header
 * and the actual payload bytes, excluding payload padding.
 *
 * Constraints and limitations
 * ---------------------------
 * - This implementation manages exactly one erase unit. The configured NVM
 *   storage size must equal the backend erase size and be a multiple of the
 *   8-byte programming unit.
 * - Each object must have a configured size from 1 through 64 bytes, and object
 *   IDs must be unique and less than NVM_ID_COUNT.
 * - The backend must support the configured programming granularity and must
 *   enforce any hardware-specific address, alignment, and range requirements.
 * - A failed or interrupted record causes the remaining page to be treated as
 *   unavailable; a later write may compact the page.
 * - Compaction erases the only storage page before restoring cached values.
 *   Power loss during compaction can therefore result in loss of stored values.
 * - The module has a shared RAM cache and is not thread-safe or reentrant. Calls
 *   must be serialized by the application if used from multiple contexts.
 *
 * Initialization scans flash and populates the cache but does not erase or
 * program flash. nvm_read() reads from the cache; it does not access the backend.
 */

#include "nvm.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Persistent record format and flash programming constraints. */
#define NVM_MAGIC_VALUE                 UINT16_C(0x4E56)
#define NVM_COMMIT_VALUE                UINT32_C(0xC04D17ED)
#define NVM_ERASED_BYTE                 UINT8_C(0xFF)
#define NVM_PROGRAM_UNIT_SIZE           UINT32_C(8)
#define NVM_HEADER_SIZE                 UINT32_C(8)
#define NVM_CRC_SIZE                    UINT32_C(2)
#define NVM_COMMIT_MARKER_SIZE          UINT32_C(4)
#define NVM_FOOTER_UNIT_SIZE            NVM_PROGRAM_UNIT_SIZE
#define NVM_FOOTER_SIZE                 (NVM_FOOTER_UNIT_SIZE * UINT32_C(2))
#define NVM_CRC_RESERVED_SIZE           (NVM_FOOTER_UNIT_SIZE - NVM_CRC_SIZE)
#define NVM_COMMIT_RESERVED_SIZE        (NVM_FOOTER_UNIT_SIZE - NVM_COMMIT_MARKER_SIZE)
#define NVM_MAX_OBJECT_SIZE             UINT32_C(64)
#define NVM_HEADER_MAGIC_OFFSET         UINT32_C(0)
#define NVM_HEADER_ID_OFFSET            UINT32_C(2)
#define NVM_HEADER_OBJECT_SIZE_OFFSET   UINT32_C(3)
#define NVM_HEADER_SEQUENCE_OFFSET      UINT32_C(4)
#define NVM_FOOTER_CRC_OFFSET           UINT32_C(0)
#define NVM_FOOTER_COMMIT_OFFSET        NVM_FOOTER_UNIT_SIZE
#define NVM_COMMIT_UNIT_VALUE_OFFSET    UINT32_C(0)
#define NVM_SEQUENCE_INITIAL            UINT32_C(0)
#define NVM_SEQUENCE_STEP               UINT32_C(1)
#define NVM_STORAGE_START               UINT32_C(0)
#define NVM_BITS_PER_BYTE               UINT32_C(8)
#define NVM_U16_HIGH_BYTE_SHIFT         NVM_BITS_PER_BYTE
#define NVM_U32_BYTE2_SHIFT             (NVM_BITS_PER_BYTE * UINT32_C(2))
#define NVM_U32_BYTE3_SHIFT             (NVM_BITS_PER_BYTE * UINT32_C(3))
#define NVM_CRC_INPUT_SIZE              (NVM_HEADER_SIZE + NVM_MAX_OBJECT_SIZE)

#define NVM_ALIGN_UP(value, alignment) \
    (((value) + ((alignment) - UINT32_C(1))) & ~((alignment) - UINT32_C(1)))

/* Only persistent module state belongs here; temporary data stays local. */
struct nvm_context
{
    const struct nvm_config *config;
    uint32_t write_offset;
    uint32_t sequence;
    uint32_t object_sequences[NVM_ID_COUNT];
    uint8_t values[NVM_ID_COUNT][NVM_MAX_OBJECT_SIZE];
    bool valid[NVM_ID_COUNT];
    bool initialized;
};

/* Scratch buffer reused by append_record() and scan_records(), never retained. */
union nvm_record_buffer
{
    uint8_t payload[NVM_MAX_OBJECT_SIZE];
    uint8_t crc_input[NVM_CRC_INPUT_SIZE];
};

static struct nvm_context nvm;

extern uint16_t nvm_crc16(const void *data, size_t size);

/* Decode a little-endian 16-bit value from a serialized record. */
static uint16_t get_u16(const uint8_t *data)
{
    return (uint16_t)((uint16_t)data[0] |
                      ((uint16_t)data[1] << NVM_U16_HIGH_BYTE_SHIFT));
}

/* Decode a little-endian 32-bit value from a serialized record. */
static uint32_t get_u32(const uint8_t *data)
{
    return (uint32_t)data[0] |
           ((uint32_t)data[1] << NVM_U16_HIGH_BYTE_SHIFT) |
           ((uint32_t)data[2] << NVM_U32_BYTE2_SHIFT) |
           ((uint32_t)data[3] << NVM_U32_BYTE3_SHIFT);
}

/* Encode a 16-bit value in little-endian byte order. */
static void put_u16(uint8_t *data, uint16_t value)
{
    data[0] = (uint8_t)value;
    data[1] = (uint8_t)(value >> NVM_U16_HIGH_BYTE_SHIFT);
}

/* Encode a 32-bit value in little-endian byte order. */
static void put_u32(uint8_t *data, uint32_t value)
{
    data[0] = (uint8_t)value;
    data[1] = (uint8_t)(value >> NVM_U16_HIGH_BYTE_SHIFT);
    data[2] = (uint8_t)(value >> NVM_U32_BYTE2_SHIFT);
    data[3] = (uint8_t)(value >> NVM_U32_BYTE3_SHIFT);
}

/* Round a size up to a multiple of the flash programming unit. */
static uint32_t align_size(uint32_t size)
{
    return NVM_ALIGN_UP(size, NVM_PROGRAM_UNIT_SIZE);
}

/* Calculate the complete on-flash size of a record. */
static uint32_t record_size(uint16_t object_size)
{
    return NVM_HEADER_SIZE + align_size(object_size) + NVM_FOOTER_SIZE;
}

/* Find an object's descriptor in a configuration without changing module state. */
static const struct nvm_object *find_object(const struct nvm_config *config,
                                            enum nvm_id id)
{
    uint8_t index;

    if ((config == NULL) || (config->objects == NULL) ||
        ((unsigned)id >= NVM_ID_COUNT))
    {
        return NULL;
    }

    for (index = 0U; index < config->object_count; ++index)
    {
        if (config->objects[index].id == id)
        {
            return &config->objects[index];
        }
    }

    return NULL;
}

/* Normalize the backend's zero-on-success read result to a boolean. */
static bool read_bytes(uint32_t address, void *data, uint16_t size)
{
    return nvm.config->backend->read(address, data, size) == 0;
}

/* Normalize the backend's zero-on-success write result to a boolean. */
static bool write_bytes(uint32_t address, const void *data, uint16_t size)
{
    return nvm.config->backend->write(address, data, size) == 0;
}

/* Return true only if every byte of the header is still erased. */
static bool is_header_erased(const uint8_t *header)
{
    uint32_t index;

    for (index = 0U; index < NVM_HEADER_SIZE; ++index)
    {
        if (header[index] != NVM_ERASED_BYTE)
        {
            return false;
        }
    }

    return true;
}

/* Check the configuration and object descriptors before touching flash. */
static enum nvm_result validate_config(const struct nvm_config *config)
{
    const struct nvm_backend *backend;
    uint8_t index;
    uint8_t previous_index;

    if ((config == NULL) || (config->backend == NULL) || (config->objects == NULL) ||
        (config->object_count == 0U) || (config->object_count > NVM_ID_COUNT))
    {
        return NVM_INVALID_ARGUMENT;
    }

    backend = config->backend;
    if ((backend->read == NULL) || (backend->write == NULL) || (backend->erase == NULL) ||
        (backend->size == 0U) || (backend->size != backend->erase_size) ||
        ((backend->size % NVM_PROGRAM_UNIT_SIZE) != 0U))
    {
        return NVM_INVALID_ARGUMENT;
    }

    for (index = 0U; index < config->object_count; ++index)
    {
        const struct nvm_object *object = &config->objects[index];

        if (((unsigned)object->id >= NVM_ID_COUNT) || (object->size == 0U) ||
            (object->size > NVM_MAX_OBJECT_SIZE) || (object->size > UINT8_MAX))
        {
            return NVM_INVALID_ARGUMENT;
        }

        for (previous_index = 0U; previous_index < index; ++previous_index)
        {
            if (config->objects[previous_index].id == object->id)
            {
                return NVM_INVALID_ARGUMENT;
            }
        }
    }

    return NVM_OK;
}

/* Serialize the fixed-size header, including object ID, size, and sequence. */
static void build_header(uint8_t *header, enum nvm_id id,
                         uint16_t object_size, uint32_t sequence)
{
    memset(header, NVM_ERASED_BYTE, NVM_HEADER_SIZE);
    put_u16(&header[NVM_HEADER_MAGIC_OFFSET], NVM_MAGIC_VALUE);
    header[NVM_HEADER_ID_OFFSET] = (uint8_t)id;
    header[NVM_HEADER_OBJECT_SIZE_OFFSET] = (uint8_t)object_size;
    put_u32(&header[NVM_HEADER_SEQUENCE_OFFSET], sequence);
}

/* Prepare CRC input and calculate CRC over the header plus actual payload bytes. */
static uint16_t calculate_record_crc(union nvm_record_buffer *buffer,
                                     const uint8_t *header,
                                     const void *data,
                                     uint16_t object_size)
{
    memcpy(buffer->crc_input, header, NVM_HEADER_SIZE);
    memcpy(&buffer->crc_input[NVM_HEADER_SIZE], data, object_size);

    return nvm_crc16(buffer->crc_input, NVM_HEADER_SIZE + object_size);
}

/* Program the CRC double-word; the remaining bytes stay erased. */
static bool write_crc_unit(uint32_t address, uint16_t crc)
{
    uint8_t footer_unit[NVM_FOOTER_UNIT_SIZE];

    memset(footer_unit, NVM_ERASED_BYTE, sizeof(footer_unit));
    put_u16(&footer_unit[NVM_FOOTER_CRC_OFFSET], crc);

    return write_bytes(address, footer_unit, (uint16_t)sizeof(footer_unit));
}

/* Program the commit double-word only after the header, payload, and CRC succeed. */
static bool write_commit_unit(uint32_t address)
{
    uint8_t footer_unit[NVM_FOOTER_UNIT_SIZE];

    memset(footer_unit, NVM_ERASED_BYTE, sizeof(footer_unit));
    put_u32(&footer_unit[NVM_COMMIT_UNIT_VALUE_OFFSET], NVM_COMMIT_VALUE);

    return write_bytes(address, footer_unit, (uint16_t)sizeof(footer_unit));
}

/* Mark the remainder of the page unavailable after a possibly partial write. */
static void abandon_remaining_storage(void)
{
    nvm.write_offset = nvm.config->backend->size;
}

/* Append one record; commit is programmed last to reject interrupted writes. */
static enum nvm_result append_record(enum nvm_id id, const void *data,
                                     uint32_t sequence)
{
    const struct nvm_object *object = find_object(nvm.config, id);
    const uint32_t storage_size = nvm.config->backend->size;
    const uint16_t object_size = (object != NULL) ? object->size : 0U;
    const uint32_t padded_size = align_size(object_size);
    const uint32_t total_size = record_size(object_size);
    uint8_t header[NVM_HEADER_SIZE];
    union nvm_record_buffer buffer;
    uint16_t crc;
    uint32_t address;

    if (object == NULL)
    {
        return NVM_INVALID_ID;
    }

    if ((total_size > storage_size) || (nvm.write_offset > storage_size - total_size))
    {
        return NVM_NO_SPACE;
    }

    address = nvm.write_offset;
    build_header(header, id, object_size, sequence);
    crc = calculate_record_crc(&buffer, header, data, object_size);

    /* The CRC input buffer is no longer needed, so reuse it as padded payload. */
    memset(buffer.payload, NVM_ERASED_BYTE, padded_size);
    memcpy(buffer.payload, data, object_size);

    if (!write_bytes(address, header, (uint16_t)NVM_HEADER_SIZE) ||
        !write_bytes(address + NVM_HEADER_SIZE, buffer.payload, (uint16_t)padded_size) ||
        !write_crc_unit(address + NVM_HEADER_SIZE + padded_size, crc) ||
        !write_commit_unit(address + NVM_HEADER_SIZE + padded_size + NVM_FOOTER_UNIT_SIZE))
    {
        abandon_remaining_storage();
        return NVM_IO_ERROR;
    }

    nvm.write_offset += total_size;
    return NVM_OK;
}

/* Decode and validate a header before using its ID or size to access arrays. */
static bool parse_header(const uint8_t *header, enum nvm_id *id,
                         uint16_t *object_size, uint32_t *sequence)
{
    const struct nvm_object *object;

    *id = (enum nvm_id)header[NVM_HEADER_ID_OFFSET];
    *object_size = header[NVM_HEADER_OBJECT_SIZE_OFFSET];
    *sequence = get_u32(&header[NVM_HEADER_SEQUENCE_OFFSET]);
    object = find_object(nvm.config, *id);

    return (get_u16(&header[NVM_HEADER_MAGIC_OFFSET]) == NVM_MAGIC_VALUE) &&
           (object != NULL) && (*object_size == object->size) && (*object_size != 0U) &&
           (*object_size <= NVM_MAX_OBJECT_SIZE);
}

/* Verify the stored commit marker and CRC against a header and payload. */
static bool validate_record(const uint8_t *crc_input, const uint8_t *footer,
                            uint16_t object_size)
{
    const uint16_t calculated_crc =
        nvm_crc16(crc_input, NVM_HEADER_SIZE + object_size);

    return (get_u32(&footer[NVM_FOOTER_COMMIT_OFFSET]) == NVM_COMMIT_VALUE) &&
           (get_u16(&footer[NVM_FOOTER_CRC_OFFSET]) == calculated_crc);
}

/* Cache a valid record only when its sequence is newer than the cached value. */
static void recover_record(enum nvm_id id, const uint8_t *payload,
                           uint16_t object_size, uint32_t record_sequence)
{
    if ((!nvm.valid[id]) ||
        ((int32_t)(record_sequence - nvm.object_sequences[id]) > 0))
    {
        memcpy(nvm.values[id], payload, object_size);
        nvm.object_sequences[id] = record_sequence;
        nvm.valid[id] = true;
    }

    if ((int32_t)(record_sequence - nvm.sequence) > 0)
    {
        nvm.sequence = record_sequence;
    }
}

/* Stop scanning at a damaged/incomplete record to avoid programming over it. */
static void stop_scan_at_corruption(void)
{
    nvm.write_offset = nvm.config->backend->size;
}

/* Read and validate one record, then update the cache and advance the scan offset. */
static enum nvm_result scan_one_record(uint8_t *header,
                                       union nvm_record_buffer *buffer,
                                       uint8_t *footer,
                                       bool *record_found)
{
    const uint32_t address = nvm.write_offset;
    enum nvm_id id;
    uint16_t object_size;
    uint32_t record_sequence;
    uint32_t padded_size;
    uint32_t total_size;

    *record_found = false;
    if (!read_bytes(address, header, (uint16_t)NVM_HEADER_SIZE))
    {
        return NVM_IO_ERROR;
    }

    if (is_header_erased(header))
    {
        return NVM_OK;
    }

    if (!parse_header(header, &id, &object_size, &record_sequence))
    {
        stop_scan_at_corruption();
        return NVM_OK;
    }

    padded_size = align_size(object_size);
    total_size = record_size(object_size);
    if ((total_size > nvm.config->backend->size) ||
        (address > nvm.config->backend->size - total_size))
    {
        stop_scan_at_corruption();
        return NVM_OK;
    }

    /* Build the CRC input in-place: header followed by the actual payload bytes. */
    memcpy(buffer->crc_input, header, NVM_HEADER_SIZE);
    if (!read_bytes(address + NVM_HEADER_SIZE,
                    &buffer->crc_input[NVM_HEADER_SIZE], object_size) ||
        !read_bytes(address + NVM_HEADER_SIZE + padded_size, footer,
                    (uint16_t)NVM_FOOTER_SIZE))
    {
        return NVM_IO_ERROR;
    }

    if (!validate_record(buffer->crc_input, footer, object_size))
    {
        stop_scan_at_corruption();
        return NVM_OK;
    }

    recover_record(id, &buffer->crc_input[NVM_HEADER_SIZE], object_size, record_sequence);
    nvm.write_offset += total_size;
    *record_found = true;
    return NVM_OK;
}

/* Scan records in flash and recover the newest committed value for each object. */
static enum nvm_result scan_records(void)
{
    uint8_t header[NVM_HEADER_SIZE];
    uint8_t footer[NVM_FOOTER_SIZE];
    union nvm_record_buffer buffer;
    bool record_found;
    enum nvm_result result;
    const uint32_t storage_size = nvm.config->backend->size;

    nvm.write_offset = NVM_STORAGE_START;
    while ((nvm.write_offset <= storage_size) &&
           ((storage_size - nvm.write_offset) >= NVM_HEADER_SIZE))
    {
        result = scan_one_record(header, &buffer, footer, &record_found);
        if (result != NVM_OK)
        {
            return result;
        }

        if (!record_found)
        {
            return NVM_OK;
        }
    }

    return NVM_OK;
}

/* Erase the page and reconstruct it from the current valid RAM cache. */
static enum nvm_result compact_storage(void)
{
    uint8_t index;
    enum nvm_id id;
    enum nvm_result result;

    if (nvm.config->backend->erase(NVM_STORAGE_START) != 0)
    {
        return NVM_IO_ERROR;
    }

    nvm.write_offset = NVM_STORAGE_START;
    for (index = 0U; index < nvm.config->object_count; ++index)
    {
        id = nvm.config->objects[index].id;
        if (!nvm.valid[id])
        {
            continue;
        }

        result = append_record(id, nvm.values[id], nvm.object_sequences[id]);
        if (result != NVM_OK)
        {
            abandon_remaining_storage();
            return result;
        }
    }

    return NVM_OK;
}

/* Reset all cached values and sequence metadata after a successful erase. */
static void clear_cache(void)
{
    memset(nvm.values, 0, sizeof(nvm.values));
    memset(nvm.valid, 0, sizeof(nvm.valid));
    memset(nvm.object_sequences, 0, sizeof(nvm.object_sequences));
    nvm.write_offset = NVM_STORAGE_START;
    nvm.sequence = NVM_SEQUENCE_INITIAL;
}

/* Initialize the module and recover valid records without modifying flash. */
enum nvm_result nvm_init(const struct nvm_config *config)
{
    enum nvm_result result;

    nvm.initialized = false;
    nvm.config = NULL;

    result = validate_config(config);
    if (result != NVM_OK)
    {
        return result;
    }

    nvm.config = config;
    clear_cache();

    result = scan_records();
    if (result != NVM_OK)
    {
        nvm.config = NULL;
        return result;
    }

    nvm.initialized = true;
    return NVM_OK;
}

/* Read a cached object; flash is not accessed by this function. */
enum nvm_result nvm_read(enum nvm_id id, void *data)
{
    const struct nvm_object *object;

    if (!nvm.initialized)
    {
        return NVM_INVALID_ARGUMENT;
    }

    object = find_object(nvm.config, id);
    if (object == NULL)
    {
        return NVM_INVALID_ID;
    }

    if (data == NULL)
    {
        return NVM_INVALID_ARGUMENT;
    }

    if (!nvm.valid[id])
    {
        return NVM_NOT_FOUND;
    }

    memcpy(data, nvm.values[id], object->size);
    return NVM_OK;
}

/* Append a new value, compacting the page first when there is insufficient room. */
enum nvm_result nvm_write(enum nvm_id id, const void *data)
{
    const struct nvm_object *object;
    const uint32_t next_sequence = nvm.sequence + NVM_SEQUENCE_STEP;
    enum nvm_result result;

    if (!nvm.initialized)
    {
        return NVM_INVALID_ARGUMENT;
    }

    object = find_object(nvm.config, id);
    if (object == NULL)
    {
        return NVM_INVALID_ID;
    }

    if (data == NULL)
    {
        return NVM_INVALID_ARGUMENT;
    }

    result = append_record(id, data, next_sequence);
    if (result == NVM_NO_SPACE)
    {
        result = compact_storage();
        if (result == NVM_OK)
        {
            result = append_record(id, data, next_sequence);
        }
    }

    if (result != NVM_OK)
    {
        return result;
    }

    memcpy(nvm.values[id], data, object->size);
    nvm.valid[id] = true;
    nvm.object_sequences[id] = next_sequence;
    nvm.sequence = next_sequence;

    return NVM_OK;
}

/* Return whether an object is configured and has a valid cached value. */
bool nvm_is_valid(enum nvm_id id)
{
    return nvm.initialized && (find_object(nvm.config, id) != NULL) && nvm.valid[id];
}

/* Erase the storage page and clear the in-RAM cache. */
enum nvm_result nvm_format(void)
{
    if (!nvm.initialized || (nvm.config == NULL))
    {
        return NVM_INVALID_ARGUMENT;
    }

    if (nvm.config->backend->erase(NVM_STORAGE_START) != 0)
    {
        return NVM_IO_ERROR;
    }

    clear_cache();
    return NVM_OK;
}
