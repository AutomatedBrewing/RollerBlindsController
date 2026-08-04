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

static state_machine_result_t handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected_any(pmachine->Event);
    check_expected_any(pmachine->State);

    /* Assign next state. */
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

static void expect_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                           state_machine_result_t expected_result)
{
    expect_function_call(handler);
    expect_value(handler, pmachine->Event, expected_event);
    expect_value(handler, pmachine->State, expected_state);
    will_return(handler, next_event);
    will_return(handler, expected_result);
}

const state_t testHSM[1] = {handler, NULL,
                            NULL,
#if HIERARCHICAL_STATES
                            NULL,    NULL,
                            0
#endif
};

state_machine_t machine;
state_machine_t *const machineList[] = {&machine};
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void test_event_triggered(void **state)
{
    /* Event is handled correctly. */
    machine.State = testHSM;   // initial state
    machine.Event = (void *)1; // trigger event to state machine

    expect_handler(1, 1, testHSM, EVENT_HANDLED);
    state_machine_result_t result;
    result = dispatch_event(machineList, 1);
    assert_true(result == EVENT_HANDLED);
}

static void test_event_not_handled(void **state)
{
    machine.State = &testHSM[0];
    machine.Event = (void *)1;

    expect_handler(1, 1, testHSM, EVENT_UN_HANDLED);
    state_machine_result_t result;
    result = dispatch_event(machineList, 1);
    assert_true(result == EVENT_UN_HANDLED);
}

static void test_event_triggered_to_self(void **state)
{
    machine.State = &testHSM[0];
    machine.Event = (void *)1;

    expect_handler(1, 2, testHSM, TRIGGERED_TO_SELF);
    expect_handler(2, 2, testHSM, EVENT_HANDLED);
    state_machine_result_t result;
    result = dispatch_event(machineList, 1);
    assert_true(result == EVENT_HANDLED);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_event_triggered),
        cmocka_unit_test(test_event_not_handled),
        cmocka_unit_test(test_event_triggered_to_self),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
