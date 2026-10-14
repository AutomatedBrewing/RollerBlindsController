#include "ramdisk.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define RAMDISK_ERASED_BYTE UINT8_C(0xFF)
#define FAULT_DISABLED (-1)

static uint8_t storage[RAMDISK_SIZE];
static const struct nvm_backend_config *configuration;

static bool fail_init;
static int32_t reads_until_failure = FAULT_DISABLED;
static int32_t writes_until_failure = FAULT_DISABLED;
static int32_t erases_until_failure = FAULT_DISABLED;

static bool should_fail(int32_t *countdown)
{
    if (*countdown == FAULT_DISABLED)
    {
        return false;
    }

    if (*countdown == 0)
    {
        *countdown = FAULT_DISABLED;
        return true;
    }

    --(*countdown);
    return false;
}

static bool is_range_valid(uint32_t address, uint16_t size)
{
    if (configuration == NULL)
    {
        return false;
    }

    if (address > configuration->size)
    {
        return false;
    }

    return (uint32_t)size <= (configuration->size - address);
}

static int ramdisk_init(const struct nvm_backend_config *config)
{
    if (fail_init)
    {
        fail_init = false;
        return -1;
    }

    if ((config == NULL) || (config->size == 0U) || (config->size > sizeof(storage)) || (config->erase_size == 0U) ||
        (config->program_size == 0U))
    {
        return -1;
    }

    configuration = config;
    return 0;
}

static int ramdisk_read(uint32_t address, void *data, uint16_t size)
{
    if (should_fail(&reads_until_failure))
    {
        return -1;
    }

    if ((data == NULL) || (size == 0U) || !is_range_valid(address, size))
    {
        return -1;
    }

    memcpy(data, &storage[address], size);
    return 0;
}

static int ramdisk_write(uint32_t address, const void *data, uint16_t size)
{
    const uint8_t *source = data;
    uint16_t index;

    if (should_fail(&writes_until_failure))
    {
        return -1;
    }

    if ((data == NULL) || (size == 0U) || !is_range_valid(address, size))
    {
        return -1;
    }

    if (((address % configuration->program_size) != 0U) || ((size % configuration->program_size) != 0U))
    {
        return -1;
    }

    /* Validate the entire write before changing any byte. */
    for (index = 0U; index < size; ++index)
    {
        if ((storage[address + index] & source[index]) != source[index])
        {
            return -1;
        }
    }

    for (index = 0U; index < size; ++index)
    {
        storage[address + index] &= source[index];
    }

    return 0;
}

static int ramdisk_erase(uint32_t address)
{
    if (should_fail(&erases_until_failure))
    {
        return -1;
    }

    if (configuration == NULL)
    {
        return -1;
    }

    if ((address % configuration->erase_size) != 0U)
    {
        return -1;
    }

    if ((address > configuration->size) || (configuration->erase_size > configuration->size - address))
    {
        return -1;
    }

    memset(&storage[address], RAMDISK_ERASED_BYTE, configuration->erase_size);
    return 0;
}

const struct nvm_backend ramdisk_backend = {
    .init = ramdisk_init, .read = ramdisk_read, .write = ramdisk_write, .erase = ramdisk_erase};

void ramdisk_reset(void)
{
    memset(storage, RAMDISK_ERASED_BYTE, sizeof(storage));
    configuration = NULL;
    fail_init = false;
    reads_until_failure = FAULT_DISABLED;
    writes_until_failure = FAULT_DISABLED;
    erases_until_failure = FAULT_DISABLED;
}

void ramdisk_fail_init(bool enable)
{
    fail_init = enable;
}

void ramdisk_fail_read_after(uint32_t successful_calls)
{
    reads_until_failure = (int32_t)successful_calls;
}

void ramdisk_fail_write_after(uint32_t successful_calls)
{
    writes_until_failure = (int32_t)successful_calls;
}

void ramdisk_fail_erase_after(uint32_t successful_calls)
{
    erases_until_failure = (int32_t)successful_calls;
}

bool ramdisk_corrupt_byte(uint32_t address, uint8_t value)
{
    if (address >= sizeof(storage))
    {
        return false;
    }

    storage[address] = value;
    return true;
}

bool ramdisk_get_byte(uint32_t address, uint8_t *value)
{
    if ((address >= sizeof(storage)) || (value == NULL))
    {
        return false;
    }

    *value = storage[address];
    return true;
}
