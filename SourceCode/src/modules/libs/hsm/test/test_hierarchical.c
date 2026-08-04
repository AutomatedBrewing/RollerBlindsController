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
    EN_EVENT4
} en_event;
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

static state_machine_result_t handler_1(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);
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
    return mock_type(state_machine_result_t);
}

static void expect_handler_2(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                             state_machine_result_t expected_result)
{
    expect_function_call(handler_2);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_2, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state; expect_uint_value(handler_2, state_val, state_val);
    will_return(handler_2, next_event);
    will_return(handler_2, expected_result);
}

static state_machine_result_t handler_3(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

static void expect_handler_3(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                             state_machine_result_t expected_result)
{
    expect_function_call(handler_3);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_3, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state; expect_uint_value(handler_3, state_val, state_val);
    will_return(handler_3, next_event);
    will_return(handler_3, expected_result);
}

extern const state_t childHSM[1];
const state_t rootHSM = {handler_1, NULL, NULL, NULL, childHSM, 0};

const state_t childHSM[1] = {{handler_2, NULL, NULL, &rootHSM, NULL, 1}};

const state_t child1HSM[1] = {{handler_3, NULL, NULL, childHSM, NULL, 1}};

state_machine_t machine;
state_machine_t *const machineList[] = {&machine};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void test_handler_could_not_handle_the_event(void **state)
{
    machine.State = child1HSM;
    machine.Event = (void *)EN_EVENT1;

    expect_handler_3(EN_EVENT1, EN_EVENT1, machine.State, EVENT_UN_HANDLED);
    expect_handler_2(EN_EVENT1, EN_EVENT1, machine.State, EVENT_UN_HANDLED);
    expect_handler_1(EN_EVENT1, EN_EVENT1, machine.State, EVENT_HANDLED);

    state_machine_result_t result;
    result = dispatch_event(machineList, 1);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.Event == 0);
}

static void test_all_handlers_could_not_handle_the_event(void **state)
{
    machine.State = child1HSM;
    machine.Event = (void *)EN_EVENT1;

    expect_handler_3(EN_EVENT1, EN_EVENT1, machine.State, EVENT_UN_HANDLED);
    expect_handler_2(EN_EVENT1, EN_EVENT1, machine.State, EVENT_UN_HANDLED);
    expect_handler_1(EN_EVENT1, EN_EVENT1, machine.State, EVENT_UN_HANDLED);

    state_machine_result_t result;
    result = dispatch_event(machineList, 1);
    assert_true(result == EVENT_UN_HANDLED);
    assert_true(machine.Event == (void *)EN_EVENT1);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_handler_could_not_handle_the_event),
        cmocka_unit_test(test_all_handlers_could_not_handle_the_event),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
