/*
 * em_timer_mock.c
 *
 *  Created on: 18 Aug 2023
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>

#include <cmocka.h>

#include "em_timer_mock.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
bool __wrap_em_timer_create(struct em_timer *timer, timer_callback_t callback, bool repeating, void *context)
{
    function_called();
    check_expected(timer);
    check_expected(callback);
    check_expected(repeating);
    check_expected(context);
    return mock_type(bool);
}

void expect_em_timer_create(struct em_timer *expected_timer, timer_callback_t expected_callback,
                            bool expected_repeating, void *expected_context, bool expected_result)
{
    expect_function_call(__wrap_em_timer_create);
    expect_value(__wrap_em_timer_create, timer, expected_timer);
    expect_value(__wrap_em_timer_create, callback, expected_callback);
    expect_value(__wrap_em_timer_create, repeating, expected_repeating);
    expect_value(__wrap_em_timer_create, context, expected_context);
    will_return(__wrap_em_timer_create, expected_result);
}

void __wrap_em_timer_set_event_id(struct em_timer *me, struct event *event)
{
    function_called();
    check_expected(me);
    check_expected(event);
}

void expect_em_timer_set_event_id(struct em_timer *expected_timer, struct event *expected_event)
{
    expect_function_call(__wrap_em_timer_set_event_id);
    expect_value(__wrap_em_timer_set_event_id, me, expected_timer);
    expect_value(__wrap_em_timer_set_event_id, event, expected_event);
}

void __wrap_em_timer_set_period(struct em_timer *me, uint32_t period_ms)
{
    function_called();
    check_expected(me);
    check_expected(period_ms);
}

void expect_em_timer_set_period(struct em_timer *expected_timer, uint32_t expected_period_ms)
{
    expect_function_call(__wrap_em_timer_set_period);
    expect_value(__wrap_em_timer_set_period, me, expected_timer);
    expect_value(__wrap_em_timer_set_period, period_ms, expected_period_ms);
}

void __wrap_em_timer_start(struct em_timer *me)
{
    function_called();
    check_expected(me);
}

void expect_em_timer_start(struct em_timer *expected_timer)
{
    expect_function_call(__wrap_em_timer_start);
    expect_value(__wrap_em_timer_start, me, expected_timer);
}

void __wrap_em_timer_stop(struct em_timer *me)
{
    function_called();
    check_expected(me);
}

void expect_em_timer_stop(struct em_timer *expected_timer)
{
    expect_function_call(__wrap_em_timer_stop);
    expect_value(__wrap_em_timer_stop, me, expected_timer);
}

bool __wrap_em_timer_is_running(struct em_timer *me)
{
    function_called();
    check_expected(me);
    return mock_type(bool);
}

void expect_em_timer_is_running(struct em_timer *expected_timer, bool expected_result)
{
    expect_function_call(__wrap_em_timer_is_running);
    expect_value(__wrap_em_timer_is_running, me, expected_timer);
    will_return(__wrap_em_timer_is_running, expected_result);
}

uint32_t __wrap_em_timer_get_expiry_time(struct em_timer *me)
{
    function_called();
    check_expected(me);
    return mock_type(uint32_t);
}

void expect_em_timer_get_expiry_time(struct em_timer *expected_timer, uint32_t expected_result)
{
    expect_function_call(__wrap_em_timer_get_expiry_time);
    expect_value(__wrap_em_timer_get_expiry_time, me, expected_timer);
    will_return(__wrap_em_timer_get_expiry_time, expected_result);
}
