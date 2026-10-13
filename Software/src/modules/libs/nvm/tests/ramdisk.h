#ifndef RAMDISK_H
#define RAMDISK_H

#include "nvm_backend.h"

#define RAMDISK_SIZE 256U

extern const struct nvm_backend ramdisk_backend;

/*
 * Reset RAM disk to the erased flash state (all bytes set to 0xFF).
 */
void ramdisk_reset(void);

#endif /* RAMDISK_H */