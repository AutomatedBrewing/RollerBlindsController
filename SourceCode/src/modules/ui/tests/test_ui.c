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

#include "hsm_ui.h"
#include "hsm_ui_internal.h"
#include "ui_test_vectors.h"

#include "ui_notify_event.h"

#include "em_timer.h"
#include "gpio.h"

#include "configuration_mock.h"
#include "gpio_pins_mock.h"

#include "utils.h"
#include <string.h>
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/

struct test_harness
{
    const struct subscriber *test_subscriber;
    struct buzzer buzzer;
    const struct buzzer_configuration *config;
    const struct device_configuration *ui_list;
    uint32_t buzzers_count;
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
enum gpio_pin_status __wrap_gpio_pin_init(const void *gpio_info, void **gpio_handle)
{
    function_called();
    check_expected(gpio_info);
    *gpio_handle = mock_type(void *);
    return mock_type(enum gpio_pin_status);
}

void expect_gpio_pin_init(void *expected_gpio_info, void *expected_gpio_handle, enum gpio_pin_status expected_result)
{
    expect_function_call(__wrap_gpio_pin_init);
    expect_uint_value(__wrap_gpio_pin_init, gpio_info, (uintmax_t)expected_gpio_info);
    will_return(__wrap_gpio_pin_init, expected_gpio_handle);
    will_return(__wrap_gpio_pin_init, expected_result);
}

void __wrap_gpio_output_configure(void *gpio_handle, enum board_pin_mode mode)
{
    (void)(mode);
    function_called();
    check_expected(gpio_handle);
    // check_expected(mode);
}

void expect_gpio_output_configure(void *expected_gpio_handle)
{
    expect_function_call(__wrap_gpio_output_configure);
    expect_uint_value(__wrap_gpio_output_configure, gpio_handle, (uintmax_t)expected_gpio_handle);
    // expect_uint_value(__wrap_gpio_output_configure, mode, expected_mode);
}

void __wrap_gpio_output_set(void *gpio_handle)
{
    function_called();
    check_expected(gpio_handle);
}

void expect_gpio_output_set(void *expected_gpio_handle)
{
    expect_function_call(__wrap_gpio_output_set);
    expect_uint_value(__wrap_gpio_output_set, gpio_handle, (uintmax_t)expected_gpio_handle);
}

void __wrap_gpio_output_clear(void *gpio_handle)
{
    function_called();
    check_expected(gpio_handle);
}

void expect_gpio_output_clear(void *expected_gpio_handle)
{
    expect_function_call(__wrap_gpio_output_clear);
    expect_uint_value(__wrap_gpio_output_clear, gpio_handle, (uintmax_t)expected_gpio_handle);
}

/*----------------------------------GPIO MOCKS TO BE EXPORTED -----------------*/

static void send_ui_timer_event(void *context)
{
    union timer_message message = {0};
    em_set_message_event(&message.event.super, UI_TIMER_EVENT_ID);
    message.event.context = context;
    em_publish_message(&message);
}

static void send_ui_notify_event(void)
{
    union ui_notify_message message = {0};
    em_set_message_event(&message.event.super, UI_NOTIFY_EVENT_ID);
    em_publish_message(&message);
}

void __wrap_em_publish_message(void *message)
{
    struct event *event_id = message;

    /* Forward event. */
    ui_subscriber.handle_event(message);
}

static int test_setup(void **state)
{
    memset(&ui, 0, sizeof(ui));
    return 0;
}

static void init_buzzer_entry(struct buzzer *buzzer, void *gpio_info, void *gpio_handle)
{
    buzzer->gpio_handle = gpio_handle;
    buzzer->gpio_info = gpio_info;
    buzzer->finished_repetitions = 0;
}

static void setup_test_harness(struct test_harness *harness, const struct device_configuration *buzzers_list,
                               uint32_t list_size)
{
    uintptr_t initial_gpio_info = 0x69;
    uintptr_t initial_gpio_handle = 0x100;

    init_buzzer_entry(&harness->buzzer, (void *)initial_gpio_info++, (void *)initial_gpio_handle++);

    harness->ui_list = buzzers_list;
    harness->config = buzzers_list->config;
    harness->buzzers_count = list_size;
}

static void expect_init_all_buzzers(struct test_harness *test)
{
    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUZZER, test->ui_list, test->buzzers_count);

    expect_find_gpio_pin_context(test->config->pin_id, &test->buzzer.gpio_info);
    expect_gpio_pin_init(&test->buzzer.gpio_info, test->buzzer.gpio_handle, GPIO_OK);
    expect_gpio_output_configure(test->buzzer.gpio_handle);
    expect_gpio_output_clear(test->buzzer.gpio_handle);

    expect_em_timer_create(true);
    expect_em_timer_set_event_id();
}
/* Private function bodies ---------------------------------------------------*/

static void given_empty_device_list_when_initializing_then_hsm_idles(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &ui_subscriber;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUZZER, NULL, 0);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    /* Nothing should happen. */
}

static void given_one_buzzer_in_device_list_when_initializing_then_init_it(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &ui_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_buzzer_list, ARRAY_SIZE(one_buzzer_list));

    expect_init_all_buzzers(&test);

    /* ACT */
    test_subscriber->init(0);
}

static void expect_activation(uint32_t expected_active_period, void *expected_gpio_handle)
{
    expect_em_timer_set_period(expected_active_period);
    expect_em_timer_start();
    expect_gpio_output_set(expected_gpio_handle);
}

static void expect_deactivation(uint32_t expected_inactive_period, void *expected_gpio_handle)
{
    expect_gpio_output_clear(expected_gpio_handle);
    expect_em_timer_set_period(expected_inactive_period);
    expect_em_timer_start();
}

static void given_idled_ui_when_received_notify_event_then_perform_notification_sequece(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &ui_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_buzzer_list, ARRAY_SIZE(one_buzzer_list));

    expect_init_all_buzzers(&test);

    /* ACT */
    test_subscriber->init(0);

    /*----------------------- Expected buzzer activation on notification event*/
    /* ARRANGE */
    expect_activation(test.config->timings.on_time, test.buzzer.gpio_handle);

    /* ACT */
    send_ui_notify_event();

    /*----------------------- Expected buzzer deactivation on timer event*/
    /* ARRANGE */
    expect_deactivation(test.config->timings.off_time, test.buzzer.gpio_handle);

    /* ACT */
    send_ui_timer_event(&ui);

    /*----------------------- Sequence finished, go to idle. */
    /* ACT */
    send_ui_timer_event(&ui);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup(given_empty_device_list_when_initializing_then_hsm_idles, test_setup),
        cmocka_unit_test_setup(given_one_buzzer_in_device_list_when_initializing_then_init_it, test_setup),
        cmocka_unit_test_setup(given_idled_ui_when_received_notify_event_then_perform_notification_sequece, test_setup),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
