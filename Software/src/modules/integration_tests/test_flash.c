//#include "blink.h"
#include "unity.h"
#include "unity_fixture.h"
#include "flash.h"

extern uint8_t __nvm_start__;
extern uint8_t __nvm_size__;

TEST_GROUP(test_flash);

TEST_SETUP(test_flash)
{
}

TEST_TEAR_DOWN(test_flash)
{
}

TEST(test_flash, test_blink_init)
{
    //TEST_ASSERT_EQUAL(1, 1);
    uint32_t base_address = (uint32_t)(uintptr_t)&__nvm_start__;
    uint32_t flash_size = (uint32_t)(uintptr_t)&__nvm_size__;
    bool result = flash_erase(base_address, flash_size);

    uint8_t data[] = {1,2,3,4,5,6,7,8};
    result = flash_program(base_address, data, sizeof(data));

    uint8_t read_buffer[sizeof(data)] = {0};
    result = flash_read(base_address, read_buffer, sizeof(data));
    
    TEST_ASSERT_EQUAL(result, false);
}

TEST_GROUP_RUNNER(test_flash)
{
    RUN_TEST_CASE(test_flash, test_blink_init);
}
