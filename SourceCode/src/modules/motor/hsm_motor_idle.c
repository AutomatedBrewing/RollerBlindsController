/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "em_event.h"

#include "motor_up_event.h"
#include "motor_down_event.h"

#include "hsm_motor.h"
#include "hsm_motor_states.h"

#include "utils.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/


static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == MOTOR_UP_EVENT_ID)
    {
        return switch_state(pmachine, hsm_motor_moves_up);
    }
    else if (event_id->id == MOTOR_DOWN_EVENT_ID)
    {
        return switch_state(pmachine, hsm_motor_moves_down);
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_motor_idle[] = {
    {event_handler, NULL, NULL, hsm_motor_root, NULL, 1},
};
