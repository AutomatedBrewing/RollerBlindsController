
#include "nvm_backend.h"
#include "flash.h"

#include <stddef.h>
#include <stdint.h>

/*
 * TODO: USTALIĆ po zmianie linker scriptu.
 * Nie używać w firmware przed rezerwacją strony.
 */
#define NVM_FLASH_BASE_ADDRESS  0x08003800UL

#define NVM_FLASH_SIZE          2048U
#define NVM_FLASH_ERASE_SIZE    2048U

static int nvm_flash_read(uint32_t address, void *data, uint16_t size)
{
    if ((data == NULL) || (size == 0U) ||
        (address > NVM_FLASH_SIZE) ||
        (size > NVM_FLASH_SIZE - address))
    {
        return -1;
    }

    return flash_read(NVM_FLASH_BASE_ADDRESS + address,
                      (uint8_t *)data, size) ? -1 : 0;
}

static int nvm_flash_write(uint32_t address,
                           const void *data,
                           uint16_t size)
{
    if ((data == NULL) || (size == 0U) ||
        ((address & 7U) != 0U) || ((size & 7U) != 0U) ||
        (address > NVM_FLASH_SIZE) ||
        (size > NVM_FLASH_SIZE - address))
    {
        return -1;
    }

    return flash_program(NVM_FLASH_BASE_ADDRESS + address,
                         (const uint8_t *)data, size) ? -1 : 0;
}

static int nvm_flash_erase(uint32_t address)
{
    if ((address % NVM_FLASH_ERASE_SIZE) != 0U ||
        (address > NVM_FLASH_SIZE) ||
        (NVM_FLASH_ERASE_SIZE > NVM_FLASH_SIZE - address))
    {
        return -1;
    }

    return flash_erase(NVM_FLASH_BASE_ADDRESS + address,
                       NVM_FLASH_ERASE_SIZE) ? -1 : 0;
}

const struct nvm_backend nvm_flash_backend = {
    .size = NVM_FLASH_SIZE,
    .erase_size = NVM_FLASH_ERASE_SIZE,
    .read = nvm_flash_read,
    .write = nvm_flash_write,
    .erase = nvm_flash_erase,
};