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

#include "gpio_pins_mock.h"
#include "configuration_mock.h"

#include "utils.h"
#include <string.h>
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
struct gpio_context
{
    void (*callback)(void* context);
    void * context;
};
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
        .event_pressed = BUTTON_PRESSED_EVENT_ID,
        .event_released = BUTTON_RELEASED_EVENT_ID,
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
    struct gpio_context * gpio_interface = mock_type(struct gpio_context * );
    gpio_interface->callback = input_config->callback;
    gpio_interface->context = input_config->callback_data;

    check_expected(int_enabled);
}

void expect_gpio_input_configure(void *expected_pin_handle, bool expected_int_enabled, struct gpio_context * gpio_interface)
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
    struct gpio_context gpio = {0};
    const struct subscriber *test_subscriber = &button_subscriber;
    void * expected_pin_info = (void*)0xDEADBEEF;
    void * expected_pin_handle = (void*) 0x23;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, single_button_list, ARRAY_SIZE(single_button_list));
    expect_find_gpio_pin_context(dummy_button.pin_id, &expected_pin_info);
    expect_gpio_pin_init(&expected_pin_info, &expected_pin_handle, GPIO_OK);
    expect_gpio_input_configure(&expected_pin_handle, false, &gpio);

    /* Assumption: pin inactive -> traversing to Released state. */
    expect_gpio_input_is_active(&expected_pin_handle, false);
    expect_gpio_input_configure(&expected_pin_handle, true, &gpio);
    expect_button_released_event(dummy_button.pin_id);

    /* timer */
    expect_em_timer_create(true);
    expect_em_timer_set_event_id();
    expect_em_timer_set_period(dummy_button.timings.debounce_time);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    /* Nothing should happen. */
}

static void when_button_pressed_shortly_then_send_short_press_event(void **state)
{
    /* ARRANGE */
    struct gpio_context gpio = {0};
    const struct subscriber *test_subscriber = &button_subscriber;
    void * expected_pin_info = (void*)0xDEADBEEF;
    void * expected_pin_handle = (void*) 0x23;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, single_button_list, ARRAY_SIZE(single_button_list));
    expect_find_gpio_pin_context(dummy_button.pin_id, &expected_pin_info);
    expect_gpio_pin_init(&expected_pin_info, &expected_pin_handle, GPIO_OK);
    expect_gpio_input_configure(&expected_pin_handle, false, &gpio);

    /* Assumption: pin inactive -> traversing to Released state. */
    expect_gpio_input_is_active(&expected_pin_handle, false);
    expect_gpio_input_configure(&expected_pin_handle, true, &gpio);
    expect_button_released_event(dummy_button.pin_id);

    /* timer */
    expect_em_timer_create(true);
    expect_em_timer_set_event_id();
    expect_em_timer_set_period(dummy_button.timings.debounce_time);

    /* ACT */
    test_subscriber->init(0);

    /* Simulate change of gpio state.*/
    expect_gpio_input_interrupt_disable(&expected_pin_handle);
    expect_em_timer_set_period(dummy_button.timings.debounce_time);
    expect_em_timer_start();
    gpio.callback(gpio.context);

    /* Debounce timer expired. */
    expect_gpio_input_is_active(&expected_pin_handle, true);
    expect_gpio_input_configure(&expected_pin_handle, true, &gpio);
    expect_button_pressed_event(dummy_button.pin_id, SHORT_PRESS);
    expect_em_timer_set_period(dummy_button.timings.long_press_time);
    expect_em_timer_start();
    send_timer_debounce_event(gpio.context);

    /* User releases button. -> traversing to released state. */
    expect_gpio_input_interrupt_disable(&expected_pin_handle);
    expect_em_timer_set_period(dummy_button.timings.debounce_time);
    expect_em_timer_start();
    gpio.callback(gpio.context);

    /* Debounce timer expired. */
    expect_gpio_input_is_active(&expected_pin_handle, false);
    expect_gpio_input_configure(&expected_pin_handle, true, &gpio);
    expect_button_released_event(dummy_button.pin_id);
    send_timer_debounce_event(gpio.context);

    /* ASSERT */
    /* Nothing should happen. */
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup(given_empty_device_list_when_initializing_then_hsm_idles, test_setup),
        cmocka_unit_test_setup(given_one_button_in_device_list_when_initializing_then_init_it, test_setup),
        cmocka_unit_test_setup(when_button_pressed_shortly_then_send_short_press_event, test_setup),
        
        
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
