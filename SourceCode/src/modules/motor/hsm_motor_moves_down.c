/*
 * motor.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"
#include "utils.h"

#include "em_event.h"

#include "motor_stop_event.h"

#include "hsm_motor.h"
#include "hsm_motor_states.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_motor_context *motor = CONTAINER_OF(pmachine, struct hsm_motor_context, machine);

    em_timer_start(&motor->safety_timer);
    gpio_output_set(motor->motor_down.gpio_handle);

    return EVENT_HANDLED;
}

static state_machine_result_t exit_handler(state_machine_t *const pmachine)
{
    struct hsm_motor_context *motor = CONTAINER_OF(pmachine, struct hsm_motor_context, machine);

    em_timer_stop(&motor->safety_timer);
    gpio_output_clear(motor->motor_down.gpio_handle);

    return EVENT_HANDLED;
}


static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if ((event_id->id == MOTOR_STOP_EVENT_ID) ||
        (event_id->id == SAFETY_TIMER_EVENT_ID))
    {
        return switch_state(pmachine, hsm_motor_idle);
    }

    return EVENT_UN_HANDLED;
}

const state_t hsm_motor_moves_down[] = {
    {event_handler, entry_handler, exit_handler, hsm_motor_idle, NULL, 2},
};
