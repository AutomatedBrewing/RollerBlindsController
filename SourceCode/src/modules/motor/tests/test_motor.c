/*
 * test_blink.c
 *
 *  Created on: 3 Oct 2022
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <cmocka.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>

#include "hsm_motor.h"
#include "hsm_motor_internal.h"
#include "motor_test_vectors.h"

#include "motor_up_event.h"
#include "motor_down_event.h"
#include "motor_stop_event.h"

#include "em_timer.h"
#include "gpio.h"


#include "configuration_mock.h"
#include "gpio_pins_mock.h"

#include "utils.h"
#include <string.h>
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
struct gpio_isr
{
    void (*callback)(void *context);
    void *context;
};

struct motor_entry
{
    void *pin_info;
    void *pin_handle;
};

struct test_harness
{
    const struct subscriber *test_subscriber;
    struct motor_entry motor_up;
    struct motor_entry motor_down;
    const struct motor_configuration *config;
    const struct device_configuration *motors_list;
    uint32_t motors_count;
};
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/*----------------------------------TIMER MOCKS TO BE EXPORTED -----------------*/
bool __wrap_em_timer_create(struct em_timer *timer, timer_callback_t callback, bool repeating, void *context)
{
    (void)(timer);
    (void)(repeating);
    function_called();
    return mock_type(bool);
}

void expect_em_timer_create(bool expected_result)
{
    expect_function_call(__wrap_em_timer_create);
    will_return(__wrap_em_timer_create, expected_result);
}

void __wrap_em_timer_set_event_id(struct em_timer *me, struct event *event)
{
    (void)(me);
    function_called();
}

void expect_em_timer_set_event_id(void)
{
    expect_function_call(__wrap_em_timer_set_event_id);
}

void __wrap_em_timer_set_period(struct em_timer *me, uint32_t period_ms)
{
    (void)(me);
    function_called();
    check_expected(period_ms);
}

void expect_em_timer_set_period(uint32_t expected_period_ms)
{
    expect_function_call(__wrap_em_timer_set_period);
    expect_value(__wrap_em_timer_set_period, period_ms, expected_period_ms);
}

void __wrap_em_timer_start(struct em_timer *me)
{
    function_called();
}

void expect_em_timer_start(void)
{
    expect_function_call(__wrap_em_timer_start);
}

void __wrap_em_timer_stop(struct em_timer *me)
{
    function_called();
}

void expect_em_timer_stop(void)
{
    expect_function_call(__wrap_em_timer_stop);
}

/*----------------------------------GPIO MOCKS TO BE EXPORTED -----------------*/
enum gpio_pin_status __wrap_gpio_pin_init(const void *pin_info, void **pin_handle)
{
    function_called();
    check_expected(pin_info);
    *pin_handle = mock_type(void *);
    return mock_type(enum gpio_pin_status);
}

void expect_gpio_pin_init(void *expected_pin_info, void *expected_pin_handle, enum gpio_pin_status expected_result)
{
    expect_function_call(__wrap_gpio_pin_init);
    expect_uint_value(__wrap_gpio_pin_init, pin_info, (uintmax_t)expected_pin_info);
    will_return(__wrap_gpio_pin_init, expected_pin_handle);
    will_return(__wrap_gpio_pin_init, expected_result);
}

void __wrap_gpio_output_configure(void *pin_handle, enum board_pin_mode mode)
{
    (void)(mode);
    function_called();
    check_expected(pin_handle);
    //check_expected(mode);
}

void expect_gpio_output_configure(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_output_configure);
    expect_uint_value(__wrap_gpio_output_configure, pin_handle, (uintmax_t)expected_pin_handle);
    //expect_uint_value(__wrap_gpio_output_configure, mode, expected_mode);
}

void __wrap_gpio_output_set(void *pin_handle)
{
    function_called();
    check_expected(pin_handle);
}

void expect_gpio_output_set(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_output_set);
    expect_uint_value(__wrap_gpio_output_set, pin_handle, (uintmax_t)expected_pin_handle);
}

void __wrap_gpio_output_clear(void *pin_handle)
{
    function_called();
    check_expected(pin_handle);
}

void expect_gpio_output_clear(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_output_clear);
    expect_uint_value(__wrap_gpio_output_clear, pin_handle, (uintmax_t)expected_pin_handle);
}


/*----------------------------------GPIO MOCKS TO BE EXPORTED -----------------*/

static void send_safety_timer_event(void *context)
{
    union timer_message message = {0};
    em_set_message_event(&message.event.super, SAFETY_TIMER_EVENT_ID);
    message.event.context = context;
    em_publish_message(&message);
}

static void send_motor_up_event(void)
{
    union motor_up_message message = {0};
    em_set_message_event(&message.event.super, MOTOR_UP_EVENT_ID);
    em_publish_message(&message);
}

static void send_motor_down_event(void)
{
    union motor_down_message message = {0};
    em_set_message_event(&message.event.super, MOTOR_DOWN_EVENT_ID);
    em_publish_message(&message);
}

static void send_motor_stop_event(void)
{
    union motor_stop_message message = {0};
    em_set_message_event(&message.event.super, MOTOR_STOP_EVENT_ID);
    em_publish_message(&message);
}


void __wrap_em_publish_message(void *message)
{
    struct event *event_id = message;

    /* Forward event. */
    motor_subscriber.handle_event(message);
}



static int test_setup(void **state)
{
    memset(&motor, 0, sizeof(motor));
    return 0;
}

static void init_motor_entry(struct motor_entry * motor, void *pin_info, void *pin_handle)
{
    motor->pin_handle = pin_handle;
    motor->pin_info = pin_info;
}

static void setup_test_harness(struct test_harness *harness, const struct device_configuration *motor_list, uint32_t list_size)
{
    uintptr_t initial_pin_info = 0x69;
    uintptr_t initial_pin_handle = 0x100;

    init_motor_entry(&harness->motor_up, (void *)initial_pin_info++, (void *)initial_pin_handle++);
    init_motor_entry(&harness->motor_down, (void *)initial_pin_info++, (void *)initial_pin_handle++);

    harness->motors_list = motor_list;
    harness->config = motor_list->config;
    harness->motors_count = list_size;
}

static void expect_init_all_motors(struct test_harness *test)
{
    expect_get_list_of_devices_by_type(DEVICE_TYPE_MOTOR, test->motors_list, test->motors_count);

    expect_find_gpio_pin_context(test->config->motor_up_pin_id, &test->motor_up.pin_info);
    expect_gpio_pin_init(&test->motor_up.pin_info, test->motor_up.pin_handle, GPIO_OK);
    expect_gpio_output_configure(test->motor_up.pin_handle);
    expect_gpio_output_clear(test->motor_up.pin_handle);
    

    expect_find_gpio_pin_context(test->config->motor_down_pin_id, &test->motor_down.pin_info);
    expect_gpio_pin_init(&test->motor_down.pin_info, test->motor_down.pin_handle, GPIO_OK);
    expect_gpio_output_configure(test->motor_down.pin_handle);
    expect_gpio_output_clear(test->motor_down.pin_handle);

    expect_em_timer_create(true);
    expect_em_timer_set_event_id();
    expect_em_timer_set_period(test->config->timeout);
}
/* Private function bodies ---------------------------------------------------*/

static void given_empty_device_list_when_initializing_then_hsm_idles(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_MOTOR, NULL, 0);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    /* Nothing should happen. */
}

static void given_one_motor_in_device_list_when_initializing_then_init_it(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);
}

static void given_motor_idle_when_motor_up_event_then_motor_up_activates(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE */
    expect_em_timer_start();
    expect_gpio_output_set(test.motor_up.pin_handle);

    /* ACT */
    send_motor_up_event();
}

static void given_motor_idle_when_motor_down_event_then_motor_down_activates(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE */
    expect_em_timer_start();
    expect_gpio_output_set(test.motor_down.pin_handle);

    /* ACT */
    send_motor_down_event();
}

static void given_motor_up_running_when_motor_stop_event_then_motor_up_stops(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE */
    expect_em_timer_start();
    expect_gpio_output_set(test.motor_up.pin_handle);

    /* ACT */
    send_motor_up_event();

    /* ARRANGE */
    expect_em_timer_stop();
    expect_gpio_output_clear(test.motor_up.pin_handle);

    /* ACT */
    send_motor_stop_event();
}

static void given_motor_down_running_when_motor_stop_event_then_motor_down_stops(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE */
    expect_em_timer_start();
    expect_gpio_output_set(test.motor_down.pin_handle);

    /* ACT */
    send_motor_down_event();

    /* ARRANGE */
    expect_em_timer_stop();
    expect_gpio_output_clear(test.motor_down.pin_handle);

    /* ACT */
    send_motor_stop_event();
}

static void given_motor_up_running_when_timeout_then_motor_up_stops(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE */
    expect_em_timer_start();
    expect_gpio_output_set(test.motor_up.pin_handle);

    /* ACT */
    send_motor_up_event();

    /* ARRANGE */
    expect_em_timer_stop();
    expect_gpio_output_clear(test.motor_up.pin_handle);

    /* ACT */
    send_safety_timer_event(&motor);
}

static void given_motor_down_running_when_timeout_then_motor_down_stops(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &motor_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_motor_list, ARRAY_SIZE(one_motor_list));

    expect_init_all_motors(&test);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE */
    expect_em_timer_start();
    expect_gpio_output_set(test.motor_down.pin_handle);

    /* ACT */
    send_motor_down_event();

    /* ARRANGE */
    expect_em_timer_stop();
    expect_gpio_output_clear(test.motor_down.pin_handle);

    /* ACT */
    send_safety_timer_event(&motor);
}


int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup(given_empty_device_list_when_initializing_then_hsm_idles, test_setup),
        cmocka_unit_test_setup(given_one_motor_in_device_list_when_initializing_then_init_it, test_setup),

        /* Idle -> running */
        cmocka_unit_test_setup(given_motor_idle_when_motor_up_event_then_motor_up_activates, test_setup),
        cmocka_unit_test_setup(given_motor_idle_when_motor_down_event_then_motor_down_activates, test_setup),

        /* Running -> Idle due to event */
        cmocka_unit_test_setup(given_motor_up_running_when_motor_stop_event_then_motor_up_stops, test_setup),
        cmocka_unit_test_setup(given_motor_down_running_when_motor_stop_event_then_motor_down_stops, test_setup),

        /* Running -> Idle due to timeout. */
        cmocka_unit_test_setup(given_motor_up_running_when_timeout_then_motor_up_stops, test_setup),
        cmocka_unit_test_setup(given_motor_down_running_when_timeout_then_motor_down_stops, test_setup),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
