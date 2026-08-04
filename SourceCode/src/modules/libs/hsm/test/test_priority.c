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

#include "hsm.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
typedef enum
{
    EN_EVENT1 = 1,
    EN_EVENT2,
    EN_EVENT3,
} en_event;
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

static state_machine_result_t handler_1(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);

    /* Assign next state. */
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

static void expect_handler_1(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                             state_machine_result_t expected_result)
{
    expect_function_call(handler_1);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_1, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state; expect_uint_value(handler_1, state_val, state_val);
    will_return(handler_1, next_event);
    will_return(handler_1, expected_result);
}

static state_machine_result_t handler_2(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);
    pmachine->Event = mock_type(void *);

    state_machine_result_t (*func)(state_machine_t *const pmachine) = mock_type(void *);
    /* Assign next state. */
    if (func != NULL)
    {
        (void)mock_type(state_machine_result_t);
        return (*func)(NULL);
    }
    else
    {
        return mock_type(state_machine_result_t);
    }
}

static void expect_handler_2(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                             state_machine_result_t expected_result,
                             state_machine_result_t (*func)(state_machine_t *const pmachine))
{
    expect_function_call(handler_2);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_2, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state; expect_uint_value(handler_2, state_val, state_val);
    will_return(handler_2, next_event);
    will_return(handler_2, func);
    will_return(handler_2, expected_result);
}

static state_machine_result_t handler_3(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);
    pmachine->Event = mock_type(void *);

    state_machine_result_t (*func)(state_machine_t *const pmachine) = mock_type(void *);
    /* Assign next state. */
    if (func != NULL)
    {
        (void)mock_type(state_machine_result_t);
        return (*func)(NULL);
    }
    else
    {
        return mock_type(state_machine_result_t);
    }
}

static void expect_handler_3(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                             state_machine_result_t expected_result,
                             state_machine_result_t (*func)(state_machine_t *const pmachine))
{
    expect_function_call(handler_3);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_3, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state; expect_uint_value(handler_3, state_val, state_val);
    will_return(handler_3, next_event);
    will_return(handler_3, func);
    will_return(handler_3, expected_result);
}

const static state_t testHSM[] = {handler_1, NULL, NULL, NULL, NULL, 0};

const static state_t test1HSM[] = {handler_2, NULL, NULL, NULL, NULL, 0};

const static state_t test2HSM[] = {handler_3, NULL, NULL, NULL, NULL, 0};

state_machine_t machine1, machine2, machine3;
state_machine_t *const machineList[] = {&machine1, &machine2, &machine3};

state_machine_result_t triggerEvent(state_machine_t *const)
{
    machine1.Event = (void *)1;
    machine3.Event = (void *)1;
    return EVENT_HANDLED;
}

state_machine_result_t selfTrigger(state_machine_t *const)
{
    machine2.Event = (void *)1;
    return TRIGGERED_TO_SELF;
}
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void test_all_state_machines_are_triggered(void **state)
{
    machine1.State = &testHSM[0];
    machine2.State = &test1HSM[0];
    machine3.State = &test2HSM[0];

    machine1.Event = (void *)EN_EVENT1;
    machine2.Event = (void *)EN_EVENT2;
    machine3.Event = (void *)EN_EVENT3;

    expect_handler_1(EN_EVENT1, EN_EVENT1, machine1.State, EVENT_HANDLED);
    expect_handler_2(EN_EVENT2, EN_EVENT2, machine2.State, EVENT_HANDLED, NULL);
    expect_handler_3(EN_EVENT3, EN_EVENT3, machine3.State, EVENT_HANDLED, NULL);
    state_machine_result_t result;
    result = dispatch_event(machineList, 3);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine1.Event == 0);
    assert_true(machine2.Event == 0);
    assert_true(machine3.Event == 0);
}

static void test_medium_priority_machine_triggers_events_of_higher_and_lower_priority_machines(void **state)
{
    machine2.Event = (void *)EN_EVENT1;

    expect_handler_2(EN_EVENT1, EN_EVENT1, machine2.State, EVENT_HANDLED, triggerEvent);
    expect_handler_1(EN_EVENT1, EN_EVENT1, machine1.State, EVENT_HANDLED);
    expect_handler_3(EN_EVENT1, EN_EVENT1, machine3.State, EVENT_HANDLED, NULL);

    state_machine_result_t result;
    result = dispatch_event(machineList, 3);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine1.Event == 0);
    assert_true(machine2.Event == 0);
    assert_true(machine3.Event == 0);
}

static void test_a_lower_priority_machine_triggers_event_to_self_and_to_a_higher_priority_machine(void **state)
{
    machine3.Event = (void *)EN_EVENT1;

    expect_handler_3(EN_EVENT1, EN_EVENT1, machine3.State, EVENT_HANDLED, selfTrigger);
    expect_handler_2(EN_EVENT1, EN_EVENT1, machine2.State, EVENT_HANDLED, NULL);
    expect_handler_3(EN_EVENT1, EN_EVENT1, machine3.State, EVENT_HANDLED, NULL);

    state_machine_result_t result;
    result = dispatch_event(machineList, 3);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine1.Event == 0);
    assert_true(machine2.Event == 0);
    assert_true(machine3.Event == 0);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_all_state_machines_are_triggered),
        cmocka_unit_test(test_medium_priority_machine_triggers_events_of_higher_and_lower_priority_machines),
        cmocka_unit_test(test_a_lower_priority_machine_triggers_event_to_self_and_to_a_higher_priority_machine),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
