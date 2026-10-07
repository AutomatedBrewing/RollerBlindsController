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

static state_machine_result_t determine_manual_or_config(state_machine_t *const pmachine,
                                                         union button_pressed_message *message,
                                                         struct hsm_controller_context *controller)
{
    process_pressed_event(message, controller);
    if (IS_BIT_SET(controller->buttons.very_long_pressed, LOCAL_UP_BIT_POS) &&
        IS_BIT_SET(controller->buttons.very_long_pressed, LOCAL_DOWN_BIT_POS))
    {
        return switch_state(pmachine, hsm_controller_config_mode);
    }
    else if ((message->event.duration == LONG_PRESS) && (!MORE_THAN_ONE_BIT_SET(controller->buttons.short_pressed)))
    {
        return switch_state(pmachine, hsm_controller_manual_mode);
    }
    else
    {
        return EVENT_HANDLED;
    }
}

static bool canEnterAutoMode(struct hsm_controller_context *controller)
{
    if (ANY_BITS_SET(controller->buttons.short_pressed, ALL_BUTTONS))
    {
        return false;
    }
    else
    {
        return true;
    }
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);
    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        return determine_manual_or_config(pmachine, (union button_pressed_message *)event_id, controller);
    }
    else if (event_id->id == BUTTON_RELEASED_EVENT_ID)
    {
        process_released_event((union button_released_message *)event_id, controller);
        if (canEnterAutoMode(controller))
        {
            return switch_state(pmachine, hsm_controller_auto_mode);
        }
        else
        {
            /* At least one more signal is active. Go to idle to ignore it. */
            return switch_state(pmachine, hsm_controller_idle);
        }
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_controller_any_mode_candidate[] = {
    {event_handler, NULL, NULL, hsm_controller_idle, NULL, 2},
};
