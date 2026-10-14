#ifndef NVM_BACKEND_H
#define NVM_BACKEND_H

#include <stdint.h>

struct nvm_backend_config
{
    /*
     * Base address of the storage area.
     * For memory-mapped flash, this is an absolute address.
     */
    uint32_t base_address;

    /*
     * Total size of the storage area.
     */
    uint32_t size;

    /*
     * Erase unit.
     */
    uint16_t erase_size;

    /*
     * Minimum programming unit.
     */
    uint8_t program_size;
};

struct nvm_backend
{
    /*
     * Read bytes from NVM.
     */
    int (*init)(const struct nvm_backend_config *config);

    /*
     * Read bytes from NVM.
     */
    int (*read)(uint32_t address, void *data, uint16_t size);

    /*
     * Program/write bytes to NVM.
     *
     * The implementation must obey the physical
     * memory's programming restrictions.
     */
    int (*write)(uint32_t address, const void *data, uint16_t size);

    /*
     * Erase one erase unit.
     *
     * address is aligned to erase_size.
     */
    int (*erase)(uint32_t address);
};

#endif