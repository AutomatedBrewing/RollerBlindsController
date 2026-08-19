#include <stdbool.h>
#include <stdint.h>

#include "nvm.h"
#include "nvm_backend.h"

/**
 * Initialize NVM.
 *
 * Does not modify the storage.
 */
enum nvm_result nvm_init(const struct nvm_config *config)
{
    (void)(config);
    return NVM_OK;
}

/**
 * Read the latest value of an object.
 *
 * The destination buffer must have at least the size
 * specified for the object.
 */
enum nvm_result nvm_read(enum nvm_id id, void *data)
{
    (void)(id);
    (void)(data);
    return NVM_OK;
}

/**
 * Write a new value.
 */
enum nvm_result nvm_write(enum nvm_id id, const void *data)
{
    (void)(id);
    (void)(data);
    return NVM_OK;
}

/**
 * Check whether an object has ever been written.
 */
bool nvm_is_valid(enum nvm_id id)
{
    (void)(id);
    return true;
}

/**
 * Erase the entire NVM storage.
 *
 * After this operation all objects are considered invalid.
 */
enum nvm_result nvm_format(void)
{
    return NVM_OK;
}
