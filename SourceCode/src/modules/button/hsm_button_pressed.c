/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"

#include "em_event.h"

#include "button_pressed_event.h"
#include "hsm_button.h"
#include "hsm_button_states.h"
#include "utils.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_button_context *button = CONTAINER_OF(pmachine, struct hsm_button_context, machine);

    button_input_wait_for_event(button, false);
    switch_state(pmachine, hsm_button_pressed_short);
    return EVENT_HANDLED;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    return EVENT_UN_HANDLED;
}

const state_t hsm_button_pressed[] = {
    {event_handler, entry_handler, NULL, hsm_button_root, hsm_button_pressed_short, 1},
};
