#ifndef NVM_FLASH_BACKEND_H
#define NVM_FLASH_BACKEND_H

#include "nvm_backend.h"

int nvm_flash_init(const struct nvm_backend_config *config);
int nvm_flash_read(uint32_t address, void *data, uint16_t size);
int nvm_flash_write(uint32_t address, const void *data, uint16_t size);
int nvm_flash_erase(uint32_t address);

#endif