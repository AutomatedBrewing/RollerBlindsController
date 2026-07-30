/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
// #include "gpio.h"
// #include "gpio_pins.h"

#include "em_event.h"

#include "button_pressed_event.h"
#include "hsm.h"
#include "hsm_scheduler.h"
#include "hsm_scheduler_states.h"
#include "valves.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    for (uint32_t valve = 0; valve < VALVES_COUNT; valve++)
    {
        valve_close(scheduler.valves_handles[valve]);
    }
    return EVENT_HANDLED;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        traverse_state(pmachine, hsm_scheduler_active);
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_scheduler_waiting[] = {
    {event_handler, entry_handler, NULL, hsm_scheduler_root, NULL, 1},
};
