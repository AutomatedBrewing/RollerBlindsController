/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"
#include "gpio_pins.h"

#include "blink_event.h"
#include "em_event.h"

#include "button_pressed_event.h"
#include "encoder_rotation_left_event.h"
#include "hsm.h"
#include "hsm_blink.h"
#include "hsm_blink_states.h"
#include "rtc.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    gpio_output_clear(blink_context.led_handle);
    return EVENT_HANDLED;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == BLINK_EVENT_ID)
    {
        traverse_state(pmachine, hsm_blink_on);
        return EVENT_HANDLED;
    }
    else if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        traverse_state(pmachine, hsm_blink_on);
        return EVENT_HANDLED;
    }
    else if (event_id->id == ENCODER_ROTATION_LEFT_EVENT_ID)
    {
        traverse_state(pmachine, hsm_blink_on);
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_blink_off[] = {
    {event_handler, entry_handler, NULL, hsm_blink_root, NULL, 1},
};
