#include <cmocka.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>

#include "nvm.h"
#include "ramdisk.h"

static const struct nvm_backend_config backend_config =
{
    .base_address = 0U,
    .size = RAMDISK_SIZE,
    .erase_size = RAMDISK_SIZE,
    .program_size = 8U
};

static const struct nvm_object objects[] =
{
    {
        .id = NVM_ID_TRAVEL_TIME,
        .size = sizeof(uint32_t)
    }
};

static const struct nvm_config nvm_config =
{
    .backend_api = &ramdisk_backend,
    .backend_config = &backend_config,
    .objects = objects,
    .object_count = (uint8_t)(sizeof(objects) / sizeof(objects[0]))
};

static int test_setup(void **state)
{
    (void)state;

    ramdisk_reset();

    return 0;
}

static void test_GivenEmptyRamDisk_WhenNvmInit_ThenReturnsOk(void **state)
{
    enum nvm_result result;

    (void)state;

    /* ARRANGE */
    /* test_setup() reset the RAM disk to the erased state. */

    /* ACT */
    result = nvm_init(&nvm_config);

    /* ASSERT */
    assert_int_equal(result, NVM_OK);
    assert_false(nvm_is_valid(NVM_ID_TRAVEL_TIME));
}

int main(void)
{
    const struct CMUnitTest tests[] =
    {
        cmocka_unit_test_setup(
            test_GivenEmptyRamDisk_WhenNvmInit_ThenReturnsOk,
            test_setup)
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}