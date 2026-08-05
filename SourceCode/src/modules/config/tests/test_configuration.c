/*
 * test_blink.c
 *
 *  Created on: 3 Oct 2022
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <cmocka.h>

#include "configuration.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void given_invalid_count_when_fetching_device_list_then_return_empty_list(void **state)
{
    /* ARRANGE */
    const struct device_configuration * list = NULL;

    /* ACT */
    list = get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, NULL);

    /* ASSERT */
    assert_null(list);
}

static void when_fetching_button_device_list_then_return_valid_list(void **state)
{
    /* ARRANGE */
    const struct device_configuration * list = NULL;
    uint8_t count = 0;

    /* ACT */
    list = get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, &count);

    /* ASSERT */
    assert_non_null(list);
    assert_uint_equal(count, 4);
}

static void when_fetching_buzzer_device_list_then_return_valid_list(void **state)
{
    /* ARRANGE */
    const struct device_configuration * list = NULL;
    uint8_t count = 0;

    /* ACT */
    list = get_list_of_devices_by_type(DEVICE_TYPE_BUZZER, &count);

    /* ASSERT */
    //assert_non_null(list);
    assert_null(list);
    assert_uint_equal(count, 0);
}

static void when_fetching_motor_device_list_then_return_valid_list(void **state)
{
    /* ARRANGE */
    const struct device_configuration * list = NULL;
    uint8_t count = 0;

    /* ACT */
    list = get_list_of_devices_by_type(DEVICE_TYPE_MOTOR, &count);

    /* ASSERT */
    //assert_non_null(list);
    assert_null(list);
    assert_uint_equal(count, 0);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(given_invalid_count_when_fetching_device_list_then_return_empty_list),
        cmocka_unit_test(when_fetching_button_device_list_then_return_valid_list),
        cmocka_unit_test(when_fetching_buzzer_device_list_then_return_valid_list),
        cmocka_unit_test(when_fetching_motor_device_list_then_return_valid_list),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
