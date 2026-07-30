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

state_machine_result_t level1_child1_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level1_child1_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level1_child1_entry_handler);
    expect_value(level1_child1_entry_handler, pmachine->Event, expected_event);
    expect_value(level1_child1_entry_handler, pmachine->State, expected_state);
    will_return(level1_child1_entry_handler, next_event);
    will_return(level1_child1_entry_handler, expected_result);
}

state_machine_result_t level1_child1_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level1_child1_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level1_child1_exit_handler);
    expect_value(level1_child1_exit_handler, pmachine->Event, expected_event);
    expect_value(level1_child1_exit_handler, pmachine->State, expected_state);
    will_return(level1_child1_exit_handler, next_event);
    will_return(level1_child1_exit_handler, expected_result);
}

state_machine_result_t level1_child2_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level1_child2_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level1_child2_entry_handler);
    expect_value(level1_child2_entry_handler, pmachine->Event, expected_event);
    expect_value(level1_child2_entry_handler, pmachine->State, expected_state);
    will_return(level1_child2_entry_handler, next_event);
    will_return(level1_child2_entry_handler, expected_result);
}

state_machine_result_t level1_child2_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level1_child2_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level1_child2_exit_handler);
    expect_value(level1_child2_exit_handler, pmachine->Event, expected_event);
    expect_value(level1_child2_exit_handler, pmachine->State, expected_state);
    will_return(level1_child2_exit_handler, next_event);
    will_return(level1_child2_exit_handler, expected_result);
}

state_machine_result_t level1_child3_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level1_child3_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level1_child3_entry_handler);
    expect_value(level1_child3_entry_handler, pmachine->Event, expected_event);
    expect_value(level1_child3_entry_handler, pmachine->State, expected_state);
    will_return(level1_child3_entry_handler, next_event);
    will_return(level1_child3_entry_handler, expected_result);
}

state_machine_result_t level1_child3_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level1_child3_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level1_child3_exit_handler);
    expect_value(level1_child3_exit_handler, pmachine->Event, expected_event);
    expect_value(level1_child3_exit_handler, pmachine->State, expected_state);
    will_return(level1_child3_exit_handler, next_event);
    will_return(level1_child3_exit_handler, expected_result);
}

/*----------------------------  LEVEL 2 */

state_machine_result_t level2_child1_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child1_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level2_child1_entry_handler);
    expect_value(level2_child1_entry_handler, pmachine->Event, expected_event);
    expect_value(level2_child1_entry_handler, pmachine->State, expected_state);
    will_return(level2_child1_entry_handler, next_event);
    will_return(level2_child1_entry_handler, expected_result);
}

state_machine_result_t level2_child1_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child1_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level2_child1_exit_handler);
    expect_value(level2_child1_exit_handler, pmachine->Event, expected_event);
    expect_value(level2_child1_exit_handler, pmachine->State, expected_state);
    will_return(level2_child1_exit_handler, next_event);
    will_return(level2_child1_exit_handler, expected_result);
}

state_machine_result_t level2_child2_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child2_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level2_child2_entry_handler);
    expect_value(level2_child2_entry_handler, pmachine->Event, expected_event);
    expect_value(level2_child2_entry_handler, pmachine->State, expected_state);
    will_return(level2_child2_entry_handler, next_event);
    will_return(level2_child2_entry_handler, expected_result);
}

state_machine_result_t level2_child2_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child2_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level2_child2_exit_handler);
    expect_value(level2_child2_exit_handler, pmachine->Event, expected_event);
    expect_value(level2_child2_exit_handler, pmachine->State, expected_state);
    will_return(level2_child2_exit_handler, next_event);
    will_return(level2_child2_exit_handler, expected_result);
}

state_machine_result_t level2_child3_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child3_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level2_child3_entry_handler);
    expect_value(level2_child3_entry_handler, pmachine->Event, expected_event);
    expect_value(level2_child3_entry_handler, pmachine->State, expected_state);
    will_return(level2_child3_entry_handler, next_event);
    will_return(level2_child3_entry_handler, expected_result);
}

state_machine_result_t level2_child3_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child3_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level2_child3_exit_handler);
    expect_value(level2_child3_exit_handler, pmachine->Event, expected_event);
    expect_value(level2_child3_exit_handler, pmachine->State, expected_state);
    will_return(level2_child3_exit_handler, next_event);
    will_return(level2_child3_exit_handler, expected_result);
}

state_machine_result_t level2_child4_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child4_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level2_child4_entry_handler);
    expect_value(level2_child4_entry_handler, pmachine->Event, expected_event);
    expect_value(level2_child4_entry_handler, pmachine->State, expected_state);
    will_return(level2_child4_entry_handler, next_event);
    will_return(level2_child4_entry_handler, expected_result);
}

state_machine_result_t level2_child4_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level2_child4_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level2_child4_exit_handler);
    expect_value(level2_child4_exit_handler, pmachine->Event, expected_event);
    expect_value(level2_child4_exit_handler, pmachine->State, expected_state);
    will_return(level2_child4_exit_handler, next_event);
    will_return(level2_child4_exit_handler, expected_result);
}

/*---------------------------- LEVEL 3*/
state_machine_result_t level3_child1_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child1_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level3_child1_entry_handler);
    expect_value(level3_child1_entry_handler, pmachine->Event, expected_event);
    expect_value(level3_child1_entry_handler, pmachine->State, expected_state);
    will_return(level3_child1_entry_handler, next_event);
    will_return(level3_child1_entry_handler, expected_result);
}

state_machine_result_t level3_child1_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child1_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level3_child1_exit_handler);
    expect_value(level3_child1_exit_handler, pmachine->Event, expected_event);
    expect_value(level3_child1_exit_handler, pmachine->State, expected_state);
    will_return(level3_child1_exit_handler, next_event);
    will_return(level3_child1_exit_handler, expected_result);
}

state_machine_result_t level3_child2_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child2_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level3_child2_entry_handler);
    expect_value(level3_child2_entry_handler, pmachine->Event, expected_event);
    expect_value(level3_child2_entry_handler, pmachine->State, expected_state);
    will_return(level3_child2_entry_handler, next_event);
    will_return(level3_child2_entry_handler, expected_result);
}

state_machine_result_t level3_child2_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child2_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level3_child2_exit_handler);
    expect_value(level3_child2_exit_handler, pmachine->Event, expected_event);
    expect_value(level3_child2_exit_handler, pmachine->State, expected_state);
    will_return(level3_child2_exit_handler, next_event);
    will_return(level3_child2_exit_handler, expected_result);
}

state_machine_result_t level3_child3_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child3_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level3_child3_entry_handler);
    expect_value(level3_child3_entry_handler, pmachine->Event, expected_event);
    expect_value(level3_child3_entry_handler, pmachine->State, expected_state);
    will_return(level3_child3_entry_handler, next_event);
    will_return(level3_child3_entry_handler, expected_result);
}

state_machine_result_t level3_child3_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child3_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level3_child3_exit_handler);
    expect_value(level3_child3_exit_handler, pmachine->Event, expected_event);
    expect_value(level3_child3_exit_handler, pmachine->State, expected_state);
    will_return(level3_child3_exit_handler, next_event);
    will_return(level3_child3_exit_handler, expected_result);
}

state_machine_result_t level3_child4_entry_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child4_entry_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                        state_machine_result_t expected_result)
{
    expect_function_call(level3_child4_entry_handler);
    expect_value(level3_child4_entry_handler, pmachine->Event, expected_event);
    expect_value(level3_child4_entry_handler, pmachine->State, expected_state);
    will_return(level3_child4_entry_handler, next_event);
    will_return(level3_child4_entry_handler, expected_result);
}

state_machine_result_t level3_child4_exit_handler(state_machine_t *const pmachine)
{
    function_called();
    check_expected(pmachine->Event);
    check_expected(pmachine->State);
    pmachine->Event = mock_type(void *);
    return mock_type(state_machine_result_t);
}

void expect_level3_child4_exit_handler(uint32_t expected_event, uint32_t next_event, const state_t *expected_state,
                                       state_machine_result_t expected_result)
{
    expect_function_call(level3_child4_exit_handler);
    expect_value(level3_child4_exit_handler, pmachine->Event, expected_event);
    expect_value(level3_child4_exit_handler, pmachine->State, expected_state);
    will_return(level3_child4_exit_handler, next_event);
    will_return(level3_child4_exit_handler, expected_result);
}

extern const state_t Level2_Child1_HSM[];
extern const state_t Level2_Child3_HSM[];
extern const state_t Level3_Child1_HSM[];
extern const state_t Level3_Child3_HSM[];
extern const state_t Level3_Child4_HSM[];

const state_t Level1_HSM[] = {
    {NULL, level1_child1_entry_handler, level1_child1_exit_handler, NULL, Level2_Child1_HSM, 0},
    {NULL, level1_child2_entry_handler, level1_child2_exit_handler, NULL, Level2_Child3_HSM, 0},
    {NULL, level1_child3_entry_handler, level1_child3_exit_handler, NULL, NULL, 0}};

const state_t Level2_Child1_HSM[] = {
    {NULL, level2_child1_entry_handler, level2_child1_exit_handler, &Level1_HSM[0], NULL, 1},
    {NULL, level2_child2_entry_handler, level2_child2_exit_handler, &Level1_HSM[0], Level3_Child1_HSM, 1},
};

const state_t Level2_Child3_HSM[] = {
    {NULL, level2_child3_entry_handler, level2_child3_exit_handler, &Level1_HSM[1], Level3_Child3_HSM, 1},
    {NULL, level2_child4_entry_handler, level2_child4_exit_handler, &Level1_HSM[1], Level3_Child4_HSM, 1},
};

const state_t Level3_Child1_HSM[] = {
    {NULL, level3_child1_entry_handler, level3_child1_exit_handler, &Level2_Child1_HSM[1], NULL, 2},
    {NULL, level3_child2_entry_handler, level3_child2_exit_handler, &Level2_Child1_HSM[1], NULL, 2},
};

const state_t Level3_Child3_HSM[] = {
    {NULL, level3_child3_entry_handler, level3_child3_exit_handler, &Level2_Child3_HSM[0], NULL, 2}};

const state_t Level3_Child4_HSM[] = {
    {NULL, level3_child4_entry_handler, level3_child4_exit_handler, &Level2_Child3_HSM[1], NULL, 2}};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void test_transition_from_same_level_and_same_parent(void **state)
{
    /* Transition from Level3_Child1 to Level3_Child2 */
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level3_Child1_HSM;

    expect_level3_child1_exit_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level3_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level3_Child1_HSM[1]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level3_Child1_HSM[1]);
}

/* test_transition_from_same_level_and_different_parent_states*/
static void test_transition_from_Level3_Child3_to_Level3_Child4(void **state)
{
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level3_Child3_HSM;

    expect_level3_child3_exit_handler(0, 0, Level3_Child4_HSM, TRIGGERED_TO_SELF);
    expect_level2_child3_exit_handler(0, 0, Level3_Child4_HSM, EVENT_HANDLED);
    expect_level2_child4_entry_handler(0, 0, Level3_Child4_HSM, EVENT_HANDLED);
    expect_level3_child4_entry_handler(0, 0, Level3_Child4_HSM, EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, Level3_Child4_HSM);
    assert_true(result == TRIGGERED_TO_SELF);
    assert_true(machine.State == Level3_Child4_HSM);
}

static void test_transition_from_Level3_Child4_to_Level3_Child2(void **state)
{
    /* Transition from Level3_Child3 to Level3_Child4 */
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level3_Child4_HSM;

    expect_level3_child4_exit_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level2_child4_exit_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level1_child2_exit_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level1_child1_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level2_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level3_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level3_Child1_HSM[1]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level3_Child1_HSM[1]);
}

/* Transition from low level to high level states */
static void test_transition_from_Level3_Child3_to_Level1_Child3(void **state)
{
    /* Transition from Level3_Child3 to Level3_Child4 */
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level3_Child3_HSM;

    expect_level3_child3_exit_handler(0, 0, &Level1_HSM[2], EVENT_HANDLED);
    expect_level2_child3_exit_handler(0, 0, &Level1_HSM[2], EVENT_HANDLED);
    expect_level1_child2_exit_handler(0, 0, &Level1_HSM[2], EVENT_HANDLED);
    expect_level1_child3_entry_handler(0, 0, &Level1_HSM[2], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level1_HSM[2]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level1_HSM[2]);
}

static void test_transition_from_Level3_Child1_to_Level2_Child1(void **state)
{
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level3_Child1_HSM;

    expect_level3_child1_exit_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);
    expect_level2_child2_exit_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);
    expect_level2_child1_entry_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level2_Child1_HSM[0]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level2_Child1_HSM[0]);
}

static void test_transition_from_Level3_Child4_to_Level2_Child1(void **state)
{
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level3_Child4_HSM;

    expect_level3_child4_exit_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);
    expect_level2_child4_exit_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);
    expect_level1_child2_exit_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);
    expect_level1_child1_entry_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);
    expect_level2_child1_entry_handler(0, 0, &Level2_Child1_HSM[0], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level2_Child1_HSM[0]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level2_Child1_HSM[0]);
}

/* Transition from high level to low level states */
static void test_Transition_from_Level1_Child3_to_Level3_Child2(void **state)
{
    state_machine_t machine;
    machine.Event = 0;
    machine.State = &Level1_HSM[2];

    expect_level1_child3_exit_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level1_child1_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level2_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level3_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level3_Child1_HSM[1]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level3_Child1_HSM[1]);
}

static void test_transition_from_Level2_Child1_to_Level3_Child2(void **state)
{
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level2_Child1_HSM;

    expect_level2_child1_exit_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level2_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);
    expect_level3_child2_entry_handler(0, 0, &Level3_Child1_HSM[1], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level3_Child1_HSM[1]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level3_Child1_HSM[1]);
}

static void test_transition_from_Level2_Child1_to_Level3_Child4(void **state)
{
    state_machine_t machine;
    machine.Event = 0;
    machine.State = Level2_Child1_HSM;

    expect_level2_child1_exit_handler(0, 0, &Level3_Child4_HSM[0], EVENT_HANDLED);
    expect_level1_child1_exit_handler(0, 0, &Level3_Child4_HSM[0], EVENT_HANDLED);
    expect_level1_child2_entry_handler(0, 0, &Level3_Child4_HSM[0], EVENT_HANDLED);
    expect_level2_child4_entry_handler(0, 0, &Level3_Child4_HSM[0], EVENT_HANDLED);
    expect_level3_child4_entry_handler(0, 0, &Level3_Child4_HSM[0], EVENT_HANDLED);

    state_machine_result_t result;
    result = traverse_state(&machine, &Level3_Child4_HSM[0]);
    assert_true(result == EVENT_HANDLED);
    assert_true(machine.State == &Level3_Child4_HSM[0]);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_transition_from_same_level_and_same_parent),
        cmocka_unit_test(test_transition_from_Level3_Child3_to_Level3_Child4),
        cmocka_unit_test(test_transition_from_Level3_Child4_to_Level3_Child2),
        cmocka_unit_test(test_transition_from_Level3_Child3_to_Level1_Child3),
        cmocka_unit_test(test_transition_from_Level3_Child1_to_Level2_Child1),
        cmocka_unit_test(test_transition_from_Level3_Child4_to_Level2_Child1),
        cmocka_unit_test(test_Transition_from_Level1_Child3_to_Level3_Child2),
        cmocka_unit_test(test_transition_from_Level2_Child1_to_Level3_Child2),
        cmocka_unit_test(test_transition_from_Level2_Child1_to_Level3_Child4),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
