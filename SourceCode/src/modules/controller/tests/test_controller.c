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

#include "hsm_controller.h"
#include "hsm_controller_internal.h"
#include "controller_test_vectors.h"

/* Received events*/
#include "button_pressed_event.h"
#include "button_released_event.h"

/* Produced events*/
#include "ui_notify_event.h"
#include "motor_up_event.h"
#include "motor_down_event.h"
#include "motor_stop_event.h"

#include "em_timer.h"
#include "gpio.h"
#include "gpio_pins.h"

#include "configuration_mock.h"

#include "utils.h"
#include <string.h>
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/

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

/*----------------------------------NVM MOCKS TO BE EXPORTED -----------------*/
enum nvm_result __wrap_nvm_init(const struct nvm_config *config)
{
    function_called();
    return mock_type(enum nvm_result);
}

static void expect_nvm_init(enum nvm_result returned_code)
{
    expect_function_call(__wrap_nvm_init);
    will_return(__wrap_nvm_init, returned_code);
}

enum nvm_result __wrap_nvm_read(enum nvm_id id, void *data)
{
    function_called();
    struct travel_time *returned_travel_time =
        mock_type(struct travel_time *);

    *((struct travel_time *)data) = *returned_travel_time;
    return mock_type(enum nvm_result);
}

static void expect_nvm_read(enum nvm_result returned_code, struct travel_time * returned_travel_time)
{
    expect_function_call(__wrap_nvm_read);
    will_return(__wrap_nvm_read, returned_travel_time);
    will_return(__wrap_nvm_read, returned_code);
}
/*----------------------------------GPIO MOCKS TO BE EXPORTED -----------------*/

static void send_controller_timer_event(void *context)
{
    union timer_message message = {0};
    em_set_message_event(&message.event.super, CONTROLLER_TIMER_EVENT_ID);
    message.event.context = context;
    em_publish_message(&message);
}

static void validate_ui_notify_event(void)
{
    function_called();
}

static void expect_ui_notify_event(void)
{
    expect_function_call(validate_ui_notify_event);
}

static void validate_motor_up_event(void)
{
    function_called();
}

static void expect_motor_up_event(void)
{
    expect_function_call(validate_motor_up_event);
}

static void validate_motor_down_event(void)
{
    function_called();
}

static void expect_motor_down_event(void)
{
    expect_function_call(validate_motor_down_event);
}

static void validate_motor_stop_event(void)
{
    function_called();
}

static void expect_motor_stop_event(void)
{
    expect_function_call(validate_motor_stop_event);
}


static void send_button_pressed_event( enum board_input_pin_id button, enum button_press_duration duration)
{
    union button_pressed_message message = {0};
    em_set_message_event(&message.event.super, BUTTON_PRESSED_EVENT_ID);
    message.event.button = button;
    message.event.duration = duration;
    em_publish_message(&message);
}

static void send_button_released_event(enum board_input_pin_id button)
{
    union button_released_message message = {0};
    em_set_message_event(&message.event.super, BUTTON_RELEASED_EVENT_ID);
    message.event.button = button;
    em_publish_message(&message);
}


void __wrap_em_publish_message(void *message)
{
    struct event *event_id = message;


    if (event_id->id == UI_NOTIFY_EVENT_ID)
    {
        validate_ui_notify_event();
    }
    else if (event_id->id == MOTOR_UP_EVENT_ID)
    {
        validate_motor_up_event();
    }
    else if (event_id->id == MOTOR_DOWN_EVENT_ID)
    {
        validate_motor_down_event();
    }
    else if (event_id->id == MOTOR_STOP_EVENT_ID)
    {
        validate_motor_stop_event();
    }

    /* Forward event. */
    controller_subscriber.handle_event(message);
}

static int test_setup(void **state)
{
    memset(&controller, 0, sizeof(controller));
    return 0;
}



static void expect_init(struct travel_time * mocked_travel_time)
{
    expect_nvm_init(NVM_OK);
    expect_nvm_read(NVM_OK, mocked_travel_time);

    expect_em_timer_create(true);
    expect_em_timer_set_event_id();    
}

static void expect_motor_movement(enum direction expected_direction)
{
    if(expected_direction == UP)
    {
        expect_motor_up_event();
    } else if (expected_direction == DOWN)
    {
        expect_motor_down_event();
    }
}

static void expect_enter_auto_mode(enum direction expected_direction, uint32_t expected_movement_time)
{
    expect_motor_movement(expected_direction);
    expect_em_timer_set_period(expected_movement_time);
    expect_em_timer_start();
}

static void expect_enter_manual_mode(enum direction expected_direction)
{
    expect_motor_movement(expected_direction);
}

/* Private function bodies ---------------------------------------------------*/

static void given_empty_device_list_when_initializing_then_hsm_idles(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, NULL, 0);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    /* Nothing should happen. */
}

static void given_valid_nvm_in_device_list_when_initializing_then_init_it(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);
}




static void given_controller_idle_when_short_press_then_auto_mode(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);

    /* ARRANGE*/
    expect_enter_auto_mode(UP, mocked_time.time);

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);

    /* ARRANGE */
    expect_motor_stop_event();

    /* ACT */
    send_controller_timer_event(&controller);
}

static void given_controller_in_auto_mode_when_short_press_then_stop_movement_and_go_to_idle(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);

    /* ARRANGE*/
    expect_enter_auto_mode(UP, mocked_time.time);

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);

    /* ARRANGE */
    expect_em_timer_stop();
    expect_motor_stop_event();

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, SHORT_PRESS);
}


static void given_controller_idle_when_long_press_then_manual_mode(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);
    /* ASSERT */


    /* ARRANGE*/
    expect_enter_manual_mode(UP);

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, LONG_PRESS);

    /* ARRANGE */
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, VERY_LONG_PRESS);

    /* ARRANGE */
    expect_motor_stop_event();

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);

    /* ASSERT */
}



static void given_controller_in_manual_mode_when_other_buttons_pressed_then_no_influence_on_movement(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);

    /* ARRANGE*/
    expect_enter_manual_mode(UP);

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, LONG_PRESS);

    /* ARRANGE */
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_REMOTE_UP_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_REMOTE_DOWN_PIN_ID, SHORT_PRESS);

    /* ARRANGE */
    expect_motor_stop_event();

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, LOCAL_DOWN_BIT_POS | REMOTE_UP_BIT_POS | REMOTE_DOWN_BIT_POS);
    assert_int_equal(controller.buttons.long_pressed, 0);
    assert_int_equal(controller.buttons.very_long_pressed, 0);
    assert_int_equal(controller.currently_operating_button, INVALID_PIN_ID);
}

static void given_controller_idle_when_buttons_pressed_shortly_then_buttons_state_is_corretly_saved(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, 0);
    assert_int_equal(controller.buttons.long_pressed, 0);
    assert_int_equal(controller.buttons.very_long_pressed, 0);
    assert_int_equal(controller.currently_operating_button, INVALID_PIN_ID);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, LOCAL_UP_BIT_POS);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, SHORT_PRESS);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, LOCAL_UP_BIT_POS | LOCAL_DOWN_BIT_POS);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_REMOTE_UP_PIN_ID, SHORT_PRESS);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, LOCAL_UP_BIT_POS | LOCAL_DOWN_BIT_POS | REMOTE_UP_BIT_POS);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_REMOTE_DOWN_PIN_ID, SHORT_PRESS);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, ALL_BUTTONS);
    assert_int_equal(controller.currently_operating_button, INVALID_PIN_ID);
}

static void given_controller_idle_when_buttons_pressed_long_then_buttons_state_is_corretly_saved(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, 0);
    assert_int_equal(controller.buttons.long_pressed, 0);
    assert_int_equal(controller.buttons.very_long_pressed, 0);
    assert_int_equal(controller.currently_operating_button, INVALID_PIN_ID);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_REMOTE_UP_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_REMOTE_DOWN_PIN_ID, SHORT_PRESS);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, LONG_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, LONG_PRESS);
    send_button_pressed_event(BUTTON_REMOTE_UP_PIN_ID, LONG_PRESS);
    send_button_pressed_event(BUTTON_REMOTE_DOWN_PIN_ID, LONG_PRESS);

    /* ASSERT */
    assert_int_equal(controller.buttons.long_pressed, ALL_BUTTONS);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);
    send_button_released_event(BUTTON_LOCAL_DOWN_PIN_ID);
    send_button_released_event(BUTTON_REMOTE_UP_PIN_ID);
    send_button_released_event(BUTTON_REMOTE_DOWN_PIN_ID);

    /* ASSERT */
    assert_int_equal(controller.buttons.short_pressed, 0);
    assert_int_equal(controller.buttons.long_pressed, 0);
    assert_int_equal(controller.buttons.very_long_pressed, 0);
}


static void given_controller_in_idle_mode_when_two_very_long_buttons_pressed_then_config_mode_activated(void **state)
{
    /* ARRANGE */
    const struct subscriber *test_subscriber = &controller_subscriber;
    struct travel_time mocked_time = {.time =60};

    expect_get_list_of_devices_by_type(DEVICE_TYPE_NVM, nvm_list, 1);
    expect_init(&mocked_time);

    /* ACT */
    test_subscriber->init(0);

    /* ARRANGE*/
    /* Nothing expected. */

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, SHORT_PRESS);

    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, LONG_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, LONG_PRESS);

    /* ARRANGE */
    expect_ui_notify_event();

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, VERY_LONG_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_DOWN_PIN_ID, VERY_LONG_PRESS);

    /* ARRANGE */
    /* Releasing one button has no effect. */

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);

    /* Releasing second button enables measurement of time. */
    send_button_released_event(BUTTON_LOCAL_DOWN_PIN_ID);

    /* ARRANGE */
    /* On button press, time measurements starts and motor is moving. */
    expect_motor_up_event();

    /* ACT */
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, SHORT_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, LONG_PRESS);
    send_button_pressed_event(BUTTON_LOCAL_UP_PIN_ID, VERY_LONG_PRESS);

    /* ARRANGE*/
    /* Button is released -> shutter is closed. Stop motor & notify user. */
    expect_motor_stop_event();
    expect_ui_notify_event();

    /* ACT */
    send_button_released_event(BUTTON_LOCAL_UP_PIN_ID);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup(given_empty_device_list_when_initializing_then_hsm_idles, test_setup),
        cmocka_unit_test_setup(given_valid_nvm_in_device_list_when_initializing_then_init_it, test_setup),
        cmocka_unit_test_setup(given_controller_idle_when_short_press_then_auto_mode, test_setup),
        cmocka_unit_test_setup(given_controller_in_auto_mode_when_short_press_then_stop_movement_and_go_to_idle, test_setup),
        cmocka_unit_test_setup(given_controller_idle_when_long_press_then_manual_mode, test_setup),
        cmocka_unit_test_setup(given_controller_in_manual_mode_when_other_buttons_pressed_then_no_influence_on_movement, test_setup),
        cmocka_unit_test_setup(given_controller_in_idle_mode_when_two_very_long_buttons_pressed_then_config_mode_activated, test_setup),
        
        cmocka_unit_test_setup(given_controller_idle_when_buttons_pressed_shortly_then_buttons_state_is_corretly_saved, test_setup),
        cmocka_unit_test_setup(given_controller_idle_when_buttons_pressed_long_then_buttons_state_is_corretly_saved, test_setup),
        
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
