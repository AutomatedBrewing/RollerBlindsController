#include "blink.h"
#include "unity.h"
#include "unity_fixture.h"

TEST_GROUP(test_blink);

TEST_SETUP(test_blink)
{
}

TEST_TEAR_DOWN(test_blink)
{
}

TEST(test_blink, test_blink_init)
{
    TEST_ASSERT_EQUAL(1, 1);
}

TEST_GROUP_RUNNER(test_blink)
{
    RUN_TEST_CASE(test_blink, test_blink_init);
}
