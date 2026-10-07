/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"

#include "em_event.h"

#include "hsm_controller.h"
#include "hsm_controller_internal.h"
#include "hsm_controller_states.h"

#include "utils.h"

#include "button_pressed_event.h"
#include "button_released_event.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);

    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        process_pressed_event((union button_pressed_message *)event_id, controller);
        return switch_state(pmachine, hsm_controller_any_mode_candidate);
    }
    else if (event_id->id == BUTTON_RELEASED_EVENT_ID)
    {
        /* In idle statuses of released are only saved, nothing more. */
        process_released_event((union button_released_message *)event_id, controller);
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_controller_idle[] = {
    {event_handler, NULL, NULL, hsm_controller_root, NULL, 1},
};
