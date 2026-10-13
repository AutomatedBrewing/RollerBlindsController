#ifndef RAMDISK_H
#define RAMDISK_H

#include <stdbool.h>
#include <stdint.h>

#include "nvm_backend.h"

#define RAMDISK_SIZE 256U

extern const struct nvm_backend ramdisk_backend;

/* Reset storage to the erased flash state (0xFF) and clear fault injection. */
void ramdisk_reset(void);

/*
 * Fail one backend operation after the specified number of successful
 * operations of that type. Zero means fail the next operation.
 */
void ramdisk_fail_init(bool enable);
void ramdisk_fail_read_after(uint32_t successful_calls);
void ramdisk_fail_write_after(uint32_t successful_calls);
void ramdisk_fail_erase_after(uint32_t successful_calls);

/* Test-only raw access; intentionally bypasses flash programming rules. */
bool ramdisk_corrupt_byte(uint32_t address, uint8_t value);
bool ramdisk_get_byte(uint32_t address, uint8_t *value);

#endif /* RAMDISK_H */
