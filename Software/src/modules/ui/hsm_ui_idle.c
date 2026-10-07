/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "em_event.h"

#include "ui_notify_event.h"

#include "hsm_ui.h"
#include "hsm_ui_states.h"

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
    if (event_id->id == UI_NOTIFY_EVENT_ID)
    {
        return switch_state(pmachine, hsm_ui_notifying);
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_ui_idle[] = {
    {event_handler, NULL, NULL, hsm_ui_root, NULL, 1},
};
