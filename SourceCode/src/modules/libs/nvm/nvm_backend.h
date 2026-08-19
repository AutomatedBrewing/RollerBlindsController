#ifndef NVM_BACKEND_H
#define NVM_BACKEND_H

#include <stdint.h>

struct nvm_backend {
    /*
     * Total size of the storage area.
     */
    uint32_t size;

    /*
     * Erase unit.
     *
     * For flash this is usually a page/sector.
     * For EEPROM it can be 1.
     */
    uint16_t erase_size;

    /*
     * Read bytes from NVM.
     */
    int (*read)(
        uint32_t address,
        void *data,
        uint16_t size);

    /*
     * Program/write bytes to NVM.
     *
     * The implementation must obey the physical
     * memory's programming restrictions.
     */
    int (*write)(
        uint32_t address,
        const void *data,
        uint16_t size);

    /*
     * Erase one erase unit.
     *
     * address is aligned to erase_size.
     */
    int (*erase)(
        uint32_t address);
};

#endif