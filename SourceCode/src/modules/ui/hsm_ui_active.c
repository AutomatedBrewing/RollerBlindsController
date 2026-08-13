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

#include "hsm_ui.h"
#include "hsm_ui_states.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_ui_context *ui = CONTAINER_OF(pmachine, struct hsm_ui_context, machine);
    
    em_timer_set_period(&ui->timer, ui->configuration->timings.on_time);
    em_timer_start(&ui->timer);
    gpio_output_set(ui->buzzer.gpio_handle);

    return EVENT_HANDLED;
}

static state_machine_result_t exit_handler(state_machine_t *const pmachine)
{
    struct hsm_ui_context *ui = CONTAINER_OF(pmachine, struct hsm_ui_context, machine);

    gpio_output_clear(ui->buzzer.gpio_handle);

    return EVENT_HANDLED;
}


static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    
    struct event *event_id = pmachine->Event;
    if ((event_id->id == UI_TIMER_EVENT_ID))
    {
        return switch_state(pmachine, hsm_ui_inactive);
    }
    
    return EVENT_UN_HANDLED;
}

const state_t hsm_ui_active[] = {
    {event_handler, entry_handler, exit_handler, hsm_ui_notifying, NULL, 3},
};
