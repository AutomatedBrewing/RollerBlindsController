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

static void handleButtonPressed(union button_pressed_message *message)
{
    (void)(message);
}

static bool canEnterAutoMode(union button_released_message *message, struct hsm_controller_context *controller)
{
    uint32_t bit = pin_id_to_bit(message->event.button);
    
    /* Clear this particular button. */
    CLEAR_BITS(controller->buttons, bit);

    if(ANY_BITS_SET(controller->buttons, ALL_BUTTONS))
    {
        return false;
    }
    else
    {
        controller->pending_request_direction = pin_id_to_direction(message->event.button);
        return true;
    }
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);
    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        handleButtonPressed((union button_pressed_message *)event_id);
        return EVENT_HANDLED;
    }
    else if (event_id->id == BUTTON_RELEASED_EVENT_ID)
    {
        if(canEnterAutoMode((union button_released_message *)event_id, controller))
        {
            return switch_state(pmachine, hsm_controller_auto_mode);
        }
        else
        {
            return EVENT_HANDLED;
        }
        
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_controller_any_mode_candidate[] = {
    {event_handler, NULL, NULL, hsm_controller_idle, NULL, 2},
};
