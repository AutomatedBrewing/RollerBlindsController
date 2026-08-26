#ifndef NVM_H
#define NVM_H

#include <stdbool.h>
#include <stdint.h>

#include "nvm_backend.h"

enum nvm_id
{
    NVM_ID_TRAVEL_TIME,

    NVM_ID_COUNT
};

enum nvm_result
{
    NVM_OK = 0,
    NVM_NOT_FOUND,
    NVM_INVALID_ID,
    NVM_INVALID_ARGUMENT,
    NVM_IO_ERROR,
    NVM_NO_SPACE,
    NVM_CORRUPTED,
};

struct nvm_object
{
    enum nvm_id id;
    uint16_t size;
};

struct nvm_config
{
    const struct nvm_backend *backend;

    const struct nvm_object *objects;
    uint8_t object_count;
};

/**
 * Initialize NVM.
 *
 * Does not modify the storage.
 */
enum nvm_result nvm_init(const struct nvm_config *config);

/**
 * Read the latest value of an object.
 *
 * The destination buffer must have at least the size
 * specified for the object.
 */
enum nvm_result nvm_read(enum nvm_id id, void *data);

/**
 * Write a new value.
 */
enum nvm_result nvm_write(enum nvm_id id, const void *data);

/**
 * Check whether an object has ever been written.
 */
bool nvm_is_valid(enum nvm_id id);

/**
 * Erase the entire NVM storage.
 *
 * After this operation all objects are considered invalid.
 */
enum nvm_result nvm_format(void);

#endif