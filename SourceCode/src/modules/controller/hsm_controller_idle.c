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
#include "hsm_controller_states.h"

#include "utils.h"

#include "button_pressed_event.h"
#include "button_released_event.h"

#include "log.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void handleButtonPressed(union button_pressed_message *message)
{
    log_printf("Button: %d: ", message->event.button);
    if(message->event.duration == SHORT_PRESS)
    {
        log_printf("SHORT PRESS\n");
    } else if (message->event.duration == LONG_PRESS)
    {
        log_printf("LONG PRESS\n");
    } else if (message->event.duration == VERY_LONG_PRESS)
    {
        log_printf("VERY LONG PRESS\n");
    }
    else{
        log_printf("UNKNOWN\n");
    }
}

static void handleButtonReleased(union button_released_message *message)
{
    log_printf("Button: %d: RELEASED", message->event.button);
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    
    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        handleButtonPressed((union button_pressed_message *)event_id);
        return EVENT_HANDLED;
    }
    else if (event_id->id == BUTTON_RELEASED_EVENT_ID)
    {
        handleButtonReleased((union button_released_message *)event_id);
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_controller_idle[] = {
    {event_handler, NULL, NULL, hsm_controller_root, NULL, 1},
};
