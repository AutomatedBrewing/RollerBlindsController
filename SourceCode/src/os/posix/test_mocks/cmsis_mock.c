/*
 * cmsis_mock.c
 *
 *  Created on: 9 Feb 2023
 *      Author: dev
 */
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <string.h>

#include "cmsis_mock.h"

osThreadId_t __wrap_osThreadNew(osThreadFunc_t func, void *argument, const osThreadAttr_t *attr)
{
    function_called();
    (void)(func);
    check_expected_any(argument);
    check_expected_any(attr);
    return mock_type(osThreadId_t);
}

void expect_osThreadNew(void *argument, const osThreadAttr_t *attr, osThreadId_t returned_thread_id)
{
    expect_function_call(__wrap_osThreadNew);
    expect_uint_value(__wrap_osThreadNew,argument, (uintptr_t)argument);
    expect_uint_value(__wrap_osThreadNew, attr, (uintptr_t)attr);
    will_return(__wrap_osThreadNew, returned_thread_id);
}


osMessageQueueId_t __wrap_osMessageQueueNew(uint32_t msg_count, uint32_t msg_size, const osMessageQueueAttr_t *attr)
{
    function_called();
    check_expected_any(msg_count);
    check_expected_any(msg_size);
    check_expected_any(attr);
    return mock_type(osMessageQueueId_t);
}


void expect_osMessageQueueNew(uint32_t msg_count, uint32_t msg_size, const osMessageQueueAttr_t *attr, osMessageQueueId_t returned_queue_id)
{
    expect_function_call(__wrap_osMessageQueueNew);
     expect_uint_value(__wrap_osMessageQueueNew, msg_count, msg_count);
     expect_uint_value(__wrap_osMessageQueueNew, msg_size, msg_size);
     expect_uint_value(__wrap_osMessageQueueNew, attr, attr);
    will_return(__wrap_osMessageQueueNew, returned_queue_id);
}


osStatus_t __wrap_osMessageQueueGet(osMessageQueueId_t mq_id, void *msg_ptr, uint8_t *msg_prio, uint32_t timeout)
{
    function_called();
    check_expected_any(mq_id);
//    check_expected_any(msg_prio);
    (void)(msg_prio);
    check_expected_any(timeout);
    void * copy_from = mock_type(void*);
    uint32_t copy_size = mock_type(uint32_t);
    memcpy(msg_ptr, copy_from, copy_size);
    return mock_type(osStatus_t);
}


void expect_osMessageQueueGet(osMessageQueueId_t mq_id, uint32_t timeout, osStatus_t returned_id, void * msg, uint32_t msg_size)
{
    expect_function_call(__wrap_osMessageQueueGet);
     expect_uint_value(__wrap_osMessageQueueGet, mq_id, mq_id);
     expect_uint_value(__wrap_osMessageQueueGet, timeout, timeout);
    will_return(__wrap_osMessageQueueGet, msg);
    will_return(__wrap_osMessageQueueGet, msg_size);
    will_return(__wrap_osMessageQueueGet, returned_id);
}

osStatus_t __wrap_osMessageQueuePut (osMessageQueueId_t mq_id, const void *msg_ptr, uint8_t msg_prio, uint32_t timeout) {
    function_called();
    check_expected_any(mq_id);
    void * expected_message = mock_type(void*);
    uint32_t expected_message_size = mock_type(uint32_t);
    int result = memcmp(msg_ptr, expected_message, expected_message_size);
    assert_false(result);
    //    (void)(msg_ptr);
    (void)(msg_prio);
    check_expected_any(timeout);
    return mock_type(osStatus_t);
}

void expect_osMessageQueuePut(osMessageQueueId_t mq_id, void * expected_message, uint32_t expected_message_size, uint32_t timeout, osStatus_t returned_id)
{
    expect_function_call(__wrap_osMessageQueuePut);
     expect_uint_value(__wrap_osMessageQueuePut, mq_id, mq_id);
     expect_uint_value(__wrap_osMessageQueuePut, timeout, timeout);
    will_return(__wrap_osMessageQueuePut, expected_message);
    will_return(__wrap_osMessageQueuePut, expected_message_size);
    will_return(__wrap_osMessageQueuePut, returned_id);
}

osTimerId_t __wrap_osTimerNew (osTimerFunc_t func, osTimerType_t type, void *argument, const osTimerAttr_t *attr)
{
    function_called();
    (void)(func);
    check_expected_any(type);
    check_expected_any(argument);
    (void)(attr);
    return mock_type(osTimerId_t);
}

void expect_osTimerNew(osTimerType_t type, void *argument, osTimerId_t returned_id)
{
    expect_function_call(__wrap_osTimerNew);
     expect_uint_value(__wrap_osTimerNew, type, type);
     expect_uint_value(__wrap_osTimerNew, argument, argument);
    will_return(__wrap_osTimerNew, returned_id);
}

osStatus_t __wrap_osTimerStart (osTimerId_t timer_id, uint32_t ticks)
{
    function_called();
    check_expected_any(timer_id);
    check_expected_any(ticks);
    return mock_type(osStatus_t);
}

void expect_osTimerStart(osTimerId_t expected_timer_id, uint32_t expected_ticks, osStatus_t returned_status)
{
    expect_function_call(__wrap_osTimerStart);
     expect_uint_value(__wrap_osTimerStart, timer_id, expected_timer_id);
     expect_uint_value(__wrap_osTimerStart, ticks, expected_ticks);
    will_return(__wrap_osTimerStart, returned_status);
}

osStatus_t __wrap_osTimerStop (osTimerId_t timer_id)
{
    function_called();
    check_expected_any(timer_id);
    return mock_type(osStatus_t);
}


void expect_osTimerStop(osTimerId_t expected_timer_id, uint32_t returned_status)
{
    expect_function_call(__wrap_osTimerStop);
     expect_uint_value(__wrap_osTimerStop, timer_id, expected_timer_id);
    will_return(__wrap_osTimerStop, returned_status);
}


uint32_t __wrap_osTimerIsRunning (osTimerId_t timer_id)
{
    function_called();
    check_expected_any(timer_id);
    return mock_type(uint32_t);
}


void expect_osTimerIsRunning(osTimerId_t expected_timer_id, uint32_t returned_status)
{
    expect_function_call(__wrap_osTimerIsRunning);
     expect_uint_value(__wrap_osTimerIsRunning, timer_id, expected_timer_id);
    will_return(__wrap_osTimerIsRunning, returned_status);
}


