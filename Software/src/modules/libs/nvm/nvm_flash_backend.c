
#include "flash.h"
#include "nvm_backend.h"

#include <stddef.h>
#include <stdint.h>

const struct nvm_backend_config *configuration = NULL;

int nvm_flash_init(const struct nvm_backend_config *config)
{
    configuration = config;
    return 0;
}

int nvm_flash_read(uint32_t address, void *data, uint16_t size)
{
    if ((data == NULL) || (size == 0U) || (address > configuration->size) || (size > configuration->size - address))
    {
        return -1;
    }

    return flash_read(configuration->base_address + address, (uint8_t *)data, size) ? -1 : 0;
}

int nvm_flash_write(uint32_t address, const void *data, uint16_t size)
{
    if ((data == NULL) || (size == 0U) || ((address & 7U) != 0U) || ((size & 7U) != 0U) ||
        (address > configuration->size) || (size > configuration->size - address))
    {
        return -1;
    }

    return flash_program(configuration->base_address + address, (const uint8_t *)data, size) ? -1 : 0;
}

int nvm_flash_erase(uint32_t address)
{
    if ((address % configuration->erase_size) != 0U || (address > configuration->size) ||
        (configuration->erase_size > configuration->size - address))
    {
        return -1;
    }

    return flash_erase(configuration->base_address + address, configuration->erase_size) ? -1 : 0;
}
