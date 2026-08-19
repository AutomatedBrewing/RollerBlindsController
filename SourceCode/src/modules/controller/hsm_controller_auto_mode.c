/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"

#include "em_event.h"
#include "em_timer.h"

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
static void start_counting_movement_time(struct em_timer *timer, uint32_t movement_time)
{
    em_timer_set_period(timer, movement_time);
    em_timer_start(timer);
}

static void request_motor_movement(enum direction motor_direction)
{
    if (motor_direction == UP)
    {
        send_motor_up_request();
    }
    else if (motor_direction == DOWN)
    {
        send_motor_down_request();
    }
}

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);
    union button_released_message *event = (union button_released_message *)pmachine->Event;

    /* Clear button pressed status now. */
    process_released_event(event, controller);

    enum direction motor_direction = pin_id_to_direction(event->event.button);
    request_motor_movement(motor_direction);

    start_counting_movement_time(&controller->timer, controller->movement_config.time);

    return EVENT_HANDLED;
}

static state_machine_result_t exit_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);

    send_motor_stop_request();

    return EVENT_HANDLED;
}

/* Private function bodies ---------------------------------------------------*/

static void handleButtonPressed(union button_pressed_message *message, struct hsm_controller_context *controller)
{
    process_pressed_event(message, controller);
    em_timer_stop(&controller->timer);
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);
    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        handleButtonPressed((union button_pressed_message *)event_id, controller);
        return switch_state(pmachine, hsm_controller_idle);
    }
    else if (event_id->id == CONTROLLER_TIMER_EVENT_ID)
    {
        return switch_state(pmachine, hsm_controller_idle);
    }

    return EVENT_UN_HANDLED;
}

const state_t hsm_controller_auto_mode[] = {
    {event_handler, entry_handler, exit_handler, hsm_controller_any_mode_candidate, NULL, 3},
};
