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

#include "hsm_button.h"
#include "hsm_button_internal.h"

#include "em_timer_mock.h"
#include "gpio_mock.h"
#include "gpio_pins_mock.h"
#include "configuration_mock.h"

#include "utils.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static const struct button_configuration dummy_button =
{
    .pin_id = 0x69,
    .timings = 
    {
        .debounce_time = 10,
        .long_press_time = 20,
        .very_long_press_time = 30,
    },
    .events = 
    {
        .event_pressed = (void*) 0x100,
        .event_released = (void*) 0x200,
    },
};

static const struct device_configuration single_button_list[] =
{
    {
        .id = DEVICE_BUTTON_LOCAL_UP,
        .type = DEVICE_TYPE_BUTTON,
        .config = &dummy_button,
    },
};
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void given_empty_device_list_when_initializing_then_hsm_idles(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &button_subscriber;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, NULL, 0);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    /* Nothing should happen. */
}

static void given_one_button_in_device_list_when_initializing_then_init_it(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &button_subscriber;
    void * expected_pin_info = (void*)0xDEADBEEF;
    void * expected_pin_handle = (void*) 0x23;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, single_button_list, ARRAY_SIZE(single_button_list));
    expect_find_gpio_pin_context(dummy_button.pin_id, &expected_pin_info);
    expect_gpio_pin_init(&expected_pin_info, &expected_pin_handle, GPIO_OK);
    expect_gpio_input_configure(&expected_pin_handle, false);

    /* Assumption: pin inactive -> traversing to Released state. */
    expect_gpio_input_is_active(&expected_pin_handle, false);
    expect_gpio_input_configure(&expected_pin_handle, true);

    /* timer */
    //expect_em_timer_create()

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    /* Nothing should happen. */
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(given_empty_device_list_when_initializing_then_hsm_idles),
        cmocka_unit_test(given_one_button_in_device_list_when_initializing_then_init_it),
        
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
