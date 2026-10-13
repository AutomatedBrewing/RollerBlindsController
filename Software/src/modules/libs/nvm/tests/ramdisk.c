#include "ramdisk.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define RAMDISK_ERASED_BYTE  UINT8_C(0xFF)

static uint8_t storage[RAMDISK_SIZE];
static const struct nvm_backend_config *configuration;

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
    if (config == NULL)
    {
        return -1;
    }

    if ((config->size == 0U) ||
        (config->size > sizeof(storage)) ||
        (config->erase_size == 0U) ||
        (config->program_size == 0U))
    {
        return -1;
    }

    configuration = config;

    return 0;
}

static int ramdisk_read(uint32_t address, void *data, uint16_t size)
{
    if ((data == NULL) || (size == 0U) ||
        !is_range_valid(address, size))
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

    if ((data == NULL) || (size == 0U) ||
        !is_range_valid(address, size))
    {
        return -1;
    }

    if (((address % configuration->program_size) != 0U) ||
        ((size % configuration->program_size) != 0U))
    {
        return -1;
    }

    /*
     * Check the entire operation before modifying storage.
     * Flash programming may only change bits from 1 to 0.
     */
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
    if (configuration == NULL)
    {
        return -1;
    }

    if ((address % configuration->erase_size) != 0U)
    {
        return -1;
    }

    if ((address > configuration->size) ||
        (configuration->erase_size > configuration->size - address))
    {
        return -1;
    }

    memset(&storage[address],
           RAMDISK_ERASED_BYTE,
           configuration->erase_size);

    return 0;
}

const struct nvm_backend ramdisk_backend =
{
    .init = ramdisk_init,
    .read = ramdisk_read,
    .write = ramdisk_write,
    .erase = ramdisk_erase
};

void ramdisk_reset(void)
{
    memset(storage, RAMDISK_ERASED_BYTE, sizeof(storage));
    configuration = NULL;
}