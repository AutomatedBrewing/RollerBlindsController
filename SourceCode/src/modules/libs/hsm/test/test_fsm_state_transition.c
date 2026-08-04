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
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

static state_machine_result_t handler_1_exit(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);

    /* Assign next state. */
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

static void expect_handler_1_exit(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                  state_machine_result_t expected_result)
{
    expect_function_call(handler_1_exit);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_1_exit, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state;
    expect_uint_value(handler_1_exit, state_val, state_val);
    will_return(handler_1_exit, next_event);
    will_return(handler_1_exit, expected_result);
}

static state_machine_result_t handler_2_entry(state_machine_t *const pmachine)
{
    function_called();
    uintmax_t event_val = (uintmax_t)pmachine->Event; check_expected_uint(event_val);
    uintmax_t state_val = (uintmax_t)pmachine->State;
    check_expected_uint(state_val);

    /* Assign next state. */
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

static void expect_handler_2_entry(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                   state_machine_result_t expected_result)
{
    expect_function_call(handler_2_entry);
    uintmax_t event_val = (uintmax_t)expected_event; expect_uint_value(handler_2_entry, event_val, event_val);
    uintmax_t state_val = (uintmax_t)expected_state;
    expect_uint_value(handler_2_entry, state_val, state_val);
    will_return(handler_2_entry, next_event);
    will_return(handler_2_entry, expected_result);
}

const static state_t testHSM[] = {{NULL, NULL, handler_1_exit,
#if HIERARCHICAL_STATES
                                   NULL, NULL, 0
#endif
                                  },
                                  {NULL, handler_2_entry, NULL,
#if HIERARCHICAL_STATES
                                   NULL, NULL, 0
#endif
                                  }};

state_machine_t machine;
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void test_transition_using_switch_state(void **state)
{
    machine.State = testHSM;

    expect_handler_1_exit(0, 0, &testHSM[1], EVENT_HANDLED);
    expect_handler_2_entry(0, 0, &testHSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = switch_state(&machine, &testHSM[1]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &testHSM[1]);
}

static void test_transition_using_traverse_state(void **state)
{
    machine.State = testHSM;

    expect_handler_1_exit(0, 0, &testHSM[1], EVENT_HANDLED);
    expect_handler_2_entry(0, 0, &testHSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &testHSM[1]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &testHSM[1]);
}

static void test_entry_handler_triggers_event_to_self(void **state)
{
    machine.State = testHSM;

    expect_handler_1_exit(0, 0, &testHSM[1], TRIGGERED_TO_SELF);
    expect_handler_2_entry(0, 0, &testHSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = switch_state(&machine, &testHSM[1]);
    assert_true(result == TRIGGERED_TO_SELF);
    assert_true(machine.State == &testHSM[1]);
}

static void test_exit_handler_triggers_event_to_self(void **state)
{
    machine.State = testHSM;

    expect_handler_1_exit(0, 0, &testHSM[1], EVENT_HANDLED);
    expect_handler_2_entry(0, 0, &testHSM[1], TRIGGERED_TO_SELF);

    state_machine_result_t result;
    result = switch_state(&machine, &testHSM[1]);
    assert_true(result == TRIGGERED_TO_SELF);
    assert_true(machine.State == &testHSM[1]);
}

static void test_entry_handler_returns_error(void **state)
{
    machine.State = testHSM;

    expect_handler_1_exit(0, 0, &testHSM[1], EVENT_UN_HANDLED);

    state_machine_result_t result;
    result = switch_state(&machine, &testHSM[1]);
    assert_true(result == EVENT_UN_HANDLED);
}

static void test_exit_handler_returns_error(void **state)
{
    machine.State = testHSM;

    expect_handler_1_exit(0, 0, &testHSM[1], EVENT_HANDLED);
    expect_handler_2_entry(0, 0, &testHSM[1], EVENT_UN_HANDLED);

    state_machine_result_t result;
    result = switch_state(&machine, &testHSM[1]);
    assert_true(result == EVENT_UN_HANDLED);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_transition_using_switch_state),
        cmocka_unit_test(test_transition_using_traverse_state),
        cmocka_unit_test(test_entry_handler_triggers_event_to_self),
        cmocka_unit_test(test_exit_handler_triggers_event_to_self),
        cmocka_unit_test(test_entry_handler_returns_error),
        cmocka_unit_test(test_exit_handler_returns_error),

    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
