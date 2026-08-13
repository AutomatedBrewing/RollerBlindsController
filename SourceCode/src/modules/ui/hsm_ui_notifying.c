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
    if (ui->buzzer.finished_repetitions < ui->configuration->timings.repetitions)
    {
        return switch_state(pmachine, hsm_ui_active);
    }
    else
    {
        ui->buzzer.finished_repetitions = 0;
        return switch_state(pmachine, hsm_ui_idle);
    }
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    return EVENT_UN_HANDLED;
}

const state_t hsm_ui_notifying[] = {
    {event_handler, entry_handler, NULL, hsm_ui_idle, NULL, 2},
};
