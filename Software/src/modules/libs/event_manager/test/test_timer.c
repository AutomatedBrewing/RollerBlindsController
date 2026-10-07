/*
 * test_timer.c
 *
 *  Created on: 20 Feb 2023
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>

#include <cmocka.h>

#include "cmsis_os.h"
#include "em_executor.h"
#include "em_timer.h"

#include "cmsis_mock.h"

/* Included to test static functions. */
#include "em_timer.c"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void handle_test_event(void *event)
{
    function_called();
    check_expected_any(event);
}

static void initialize_test_timer(struct em_timer *me, osTimerId_t expected_timer_id, bool repeating, void *context)
{
    expect_osTimerNew(repeating ? osTimerPeriodic : osTimerOnce, me, expected_timer_id);
    em_timer_create(me, NULL, repeating, context);
    assert_int_equal(me->period, 0);
}

static void validate_timer_structure(struct em_timer *tested_timer, void *expected_context,
                                     bool expected_repetition_type)
{
    assert_ptr_equal(tested_timer->context, expected_context);
    assert_ptr_equal(tested_timer->repeating, expected_repetition_type);
}

static void test_create_timer(void **state)
{
    struct em_timer test_timer;
    uint32_t dummy_executor = 0x69;
    uint32_t dummy_context = 0x70;
    osTimerId_t expected_timer_id = (osTimerId_t)0x71;
    bool result;

    /* Create with success. */
    expect_osTimerNew(osTimerPeriodic, &test_timer, expected_timer_id);
    result = em_timer_create(&test_timer, NULL, true, &dummy_context);
    validate_timer_structure(&test_timer, &dummy_context, true);
    assert_true(result);

    /* Create not repeating timer. */
    expect_osTimerNew(osTimerOnce, &test_timer, expected_timer_id);
    result = em_timer_create(&test_timer, NULL, false, &dummy_context);
    validate_timer_structure(&test_timer, &dummy_context, false);
    assert_true(result);

    /* Create with failure. */
    expect_osTimerNew(osTimerPeriodic, &test_timer, NULL);
    result = em_timer_create(&test_timer, NULL, true, &dummy_context);
    validate_timer_structure(&test_timer, &dummy_context, true);
    assert_false(result);
}

static void build_expected_timer_message(union timer_message *expected_timer_message, struct event *expected_event,
                                         void *expected_context)
{
    expected_timer_message->event.super.id = expected_event;
    expected_timer_message->event.context = expected_context;
}

static void test_timer_expired(void **state)
{
    struct em_timer test_timer;
    uint32_t dummy_executor = 0x69;
    uint32_t dummy_context = 0x70;
    osTimerId_t expected_timer_id = (osTimerId_t)0x71;

    static struct executor test_executor_1 = {0};
    static const struct subscriber test_subscriber = {.handle_event = handle_test_event};
    CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(test_executor_1_subscribers, test_executor_1,
                                           ADD_SUBSCRIBER(&test_subscriber))
    CREATE_EVENT(timer_expired_event, ADD_SUBSCRIBER(&test_executor_1_subscribers))
    //    DECLARE_EVENT(BLINK_EVENT)
#define BLINK_EVENT_ID ID_OF(timer_expired_event)

    initialize_test_timer(&test_timer, expected_timer_id, false, &dummy_context);

    union timer_message expected_timer_message = {0};
    build_expected_timer_message(&expected_timer_message, BLINK_EVENT_ID, &dummy_context);

    em_timer_set_event_id(&test_timer, BLINK_EVENT_ID);
    expect_osMessageQueuePut(test_executor_1.queue, &expected_timer_message, EVENT_SIZE, 0, osOK);
    timer_expired_callback(&test_timer);
}

static void test_set_timer_period(void **state)
{
    struct em_timer test_timer;
    osTimerId_t expected_timer_id = (osTimerId_t)0x72;

    /* Test if initialization sets period to 0. */
    initialize_test_timer(&test_timer, expected_timer_id, false, NULL);

    /* Change period of not running timer. */
    expect_osTimerIsRunning(expected_timer_id, false);
    em_timer_set_period(&test_timer, 2);
    assert_int_equal(test_timer.period, 2);

    expect_osTimerIsRunning(expected_timer_id, false);
    em_timer_set_period(&test_timer, 10);
    assert_int_equal(test_timer.period, 10);

    /* Change period of running timer. */
    expect_osTimerIsRunning(expected_timer_id, true);
    expect_osTimerStart(expected_timer_id, 20, osOK);
    em_timer_set_period(&test_timer, 20);
    assert_int_equal(test_timer.period, 20);
}

static void test_start_timer(void **state)
{
    struct em_timer test_timer;
    osTimerId_t expected_timer_id = (osTimerId_t)0x73;

    initialize_test_timer(&test_timer, expected_timer_id, false, NULL);

    expect_osTimerIsRunning(expected_timer_id, false);
    em_timer_set_period(&test_timer, 10);

    expect_osTimerStart(expected_timer_id, 10, osOK);
    em_timer_start(&test_timer);
}

static void test_stop_timer(void **state)
{
    struct em_timer test_timer;
    osTimerId_t expected_timer_id = (osTimerId_t)0x74;

    initialize_test_timer(&test_timer, expected_timer_id, false, NULL);

    expect_osTimerStop(expected_timer_id, osOK);
    em_timer_stop(&test_timer);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_create_timer),     cmocka_unit_test(test_timer_expired),
        cmocka_unit_test(test_set_timer_period), cmocka_unit_test(test_start_timer),
        cmocka_unit_test(test_stop_timer),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
