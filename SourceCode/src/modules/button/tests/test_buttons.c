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

#include "button_released_event.h"
#include "button_pressed_event.h"

#include "em_timer.h"
#include "gpio.h"

#include "button_test_vectors.h"

#include "gpio_pins_mock.h"
#include "configuration_mock.h"

#include "utils.h"
#include <string.h>
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
struct gpio_isr
{
    void (*callback)(void* context);
    void * context;
};

struct button_entry
{
    void * pin_info;
    void * pin_handle;
    const struct button_configuration * config;
    struct gpio_isr isr;
};

struct test_harness
{
    const struct subscriber *test_subscriber;
    struct button_entry gpios[NO_OF_SUPPORTED_BUTTONS];
    uint8_t buttons_count;
    const struct device_configuration * buttons_list;
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

void __wrap_gpio_input_configure(void *pin_handle, struct input_pin_config *input_config, bool int_enabled)
{
    function_called();
    check_expected(pin_handle);

    /* Used to invoke gpio callback. */
    struct gpio_isr * gpio_interface = mock_type(struct gpio_isr * );
    gpio_interface->callback = input_config->callback;
    gpio_interface->context = input_config->callback_data;

    check_expected(int_enabled);
}

void expect_gpio_input_configure(void *expected_pin_handle, bool expected_int_enabled, struct gpio_isr * gpio_interface)
{
    expect_function_call(__wrap_gpio_input_configure);
    expect_uint_value(__wrap_gpio_input_configure, pin_handle, (uintmax_t)expected_pin_handle);
    //    expect_value(__wrap_gpio_input_configure, input_config, expected_input_config);
    expect_uint_value(__wrap_gpio_input_configure, int_enabled, expected_int_enabled);
    will_return(__wrap_gpio_input_configure, gpio_interface);
}

void __wrap_gpio_input_interrupt_enable(void *pin_handle)
{
    function_called();
    check_expected(pin_handle);
}

void expect_gpio_input_interrupt_enable(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_input_interrupt_enable);
    expect_uint_value(__wrap_gpio_input_interrupt_enable, pin_handle, (uintmax_t)expected_pin_handle);
}

void __wrap_gpio_input_interrupt_disable(void *pin_handle)
{
    function_called();
    check_expected(pin_handle);
}

void expect_gpio_input_interrupt_disable(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_input_interrupt_disable);
    expect_uint_value(__wrap_gpio_input_interrupt_disable, pin_handle, (uintmax_t)expected_pin_handle);
}

bool __wrap_gpio_input_is_active(void *pin_handle)
{
    function_called();
    check_expected(pin_handle);
    return mock_type(bool);
}

void expect_gpio_input_is_active(void *expected_pin_handle, bool expected_result)
{
    expect_function_call(__wrap_gpio_input_is_active);
    expect_uint_value(__wrap_gpio_input_is_active, pin_handle, (uintmax_t)expected_pin_handle);
    will_return(__wrap_gpio_input_is_active, expected_result);
}
/*----------------------------------GPIO MOCKS TO BE EXPORTED -----------------*/

static void send_timer_debounce_event(void * context)
{
    union timer_message message = {0};
    em_set_message_event(&message.event.super, TIMER_DEBOUNCE_EVENT_EVENT_ID);
    message.event.context = context;
    em_publish_message(&message);
}

void validate_button_released_event(union button_released_message *message)
{
    function_called();
    enum board_input_pin_id expected_button = mock_type(enum board_input_pin_id);
    assert_true(expected_button == message->event.button);
}

void expect_button_released_event(enum board_input_pin_id expected_button)
{
    expect_function_call(validate_button_released_event);
    will_return(validate_button_released_event, expected_button);
}

void validate_button_pressed_event(union button_pressed_message *message)
{
    function_called();
    enum board_input_pin_id expected_button = mock_type(enum board_input_pin_id );
    enum button_press_duration expected_duration = mock_type(enum button_press_duration);
    assert_true(message->event.button == expected_button);
    assert_true(message->event.duration == expected_duration);
}

void expect_button_pressed_event(enum board_input_pin_id expected_button, enum button_press_duration expected_duration)
{
    expect_function_call(validate_button_pressed_event);
    will_return(validate_button_pressed_event, expected_button);
    will_return(validate_button_pressed_event, expected_duration);
}


void __wrap_em_publish_message(void *message)
{
    struct event *event_id = message;
    
    if (event_id->id == BUTTON_RELEASED_EVENT_ID)
    {
        validate_button_released_event((union button_released_message *)event_id);
    } else if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        validate_button_pressed_event((union button_pressed_message *)event_id);
    }
        
    /* Forward event. */
    button_subscriber.handle_event(message);
}

void expect_button_state_change(void * expected_pin_handle, uint32_t debounce_time)
{
    expect_gpio_input_interrupt_disable(expected_pin_handle);
    expect_em_timer_set_period(debounce_time);
    expect_em_timer_start();
}


void expect_enter_released_state(const enum board_input_pin_id pin_id, void * expected_pin_handle, struct gpio_isr *gpio)
{
    expect_gpio_input_is_active(expected_pin_handle, false);
    expect_gpio_input_configure(expected_pin_handle, true, gpio);
    expect_button_released_event(pin_id);
}

void expect_enter_pressed_state(const enum board_input_pin_id pin_id, void * expected_pin_handle, uint32_t long_press_time, struct gpio_isr *gpio )
{
    expect_gpio_input_is_active(expected_pin_handle, true);
    expect_gpio_input_configure(expected_pin_handle, true, gpio);
    expect_button_pressed_event(pin_id, SHORT_PRESS);
    expect_em_timer_set_period(long_press_time);
    expect_em_timer_start();
}



static void setup_test_harness(struct test_harness * harness, const struct device_configuration * buttons_list, uint8_t list_size)
{
    uint32_t initial_pin_info = 0x69;
    uint32_t initial_pin_handle = 0x100;

    for(uint8_t id = 0; id < list_size; id++)
    {
        harness->gpios[id].pin_info = (void*)initial_pin_info++;
        harness->gpios[id].pin_handle = (void*)initial_pin_handle++;
        harness->gpios[id].config = buttons_list[id].config;
    }

    harness->buttons_list = buttons_list;
    harness->buttons_count = list_size;
}

static void expect_init_all_buttons(struct test_harness *test)
{
    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, test->buttons_list, test->buttons_count);

    for(uint8_t button = 0; button < test->buttons_count; button++)
    {
        expect_find_gpio_pin_context(test->gpios[button].config->pin_id, &test->gpios[button].pin_info);
    }

    for(uint8_t button = 0; button < test->buttons_count; button++)
    {
        expect_gpio_pin_init(&test->gpios[button].pin_info, &test->gpios[button].pin_handle, GPIO_OK);
        expect_gpio_input_configure(&test->gpios[button].pin_handle, false, &test->gpios[button].isr);

        /* Assumption: pin inactive -> traversing to Released state. */
        expect_enter_released_state(test->gpios[button].config->pin_id, &test->gpios[button].pin_handle, &test->gpios[button].isr);

        /* timer */
        expect_em_timer_create(true);
        expect_em_timer_set_event_id();
        expect_em_timer_set_period(test->gpios[button].config->timings.debounce_time);  
    }

}



static int test_setup(void **state)
{
    memset(buttons, 0, sizeof(buttons));
    return 0;
}



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
    struct test_harness test = {0};

    setup_test_harness(&test, one_button_list, ARRAY_SIZE(one_button_list));

    expect_init_all_buttons(&test);

    /* ACT */
    test_subscriber->init(0);
}

static void given_four_buttons_in_device_list_when_initializing_then_init_it(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &button_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, four_button_list, ARRAY_SIZE(four_button_list));

    expect_init_all_buttons(&test);

    /* ACT */
    test_subscriber->init(0);
}

static void when_button_pressed_shortly_then_send_short_press_event(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &button_subscriber;
    struct test_harness test = {0};

    setup_test_harness(&test, one_button_list, ARRAY_SIZE(one_button_list));

    expect_init_all_buttons(&test);
    struct button_entry * button = &test.gpios[0];

    /* ACT */
    test_subscriber->init(0);

    /* Simulate change of gpio state.*/
    expect_button_state_change(&button->pin_handle, button->config->timings.debounce_time);
    button->isr.callback(button->isr.context);

    /* Debounce timer expired. */
    expect_enter_pressed_state(button->config->pin_id, &button->pin_handle, button->config->timings.long_press_time, &button->isr);
    send_timer_debounce_event(button->isr.context);

    /* User releases button. -> traversing to released state. */
    expect_button_state_change(&button->pin_handle, button->config->timings.debounce_time);
    button->isr.callback(button->isr.context);

    /* Debounce timer expired. */
    expect_enter_released_state(button->config->pin_id, &button->pin_handle, &button->isr);
    send_timer_debounce_event(button->isr.context);

    /* ASSERT */
    /* Nothing should happen. */
}



int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup(given_empty_device_list_when_initializing_then_hsm_idles, test_setup),
        cmocka_unit_test_setup(given_one_button_in_device_list_when_initializing_then_init_it, test_setup),
        cmocka_unit_test_setup(given_four_buttons_in_device_list_when_initializing_then_init_it, test_setup),
        cmocka_unit_test_setup(when_button_pressed_shortly_then_send_short_press_event, test_setup),
        
        
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
