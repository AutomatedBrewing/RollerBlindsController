/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os2.h"
#include "gpio.h"

#include "em_event.h"
#include "em_timer.h"

#include "hsm_controller.h"
#include "hsm_controller_internal.h"
#include "hsm_controller_states.h"

#include "utils.h"

#include "button_pressed_event.h"
#include "button_released_event.h"
#include "ui_notify_event.h"

#include "nvm.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

/* Private function prototypes -----------------------------------------------*/
static uint32_t elapsed_ms(uint32_t start)
{
    uint32_t elapsed_ticks = osKernelGetTickCount() - start;
    uint32_t tick_freq = osKernelGetTickFreq();

    return (uint32_t)(((uint64_t)elapsed_ticks * 1000U) / tick_freq);
}

static void start_counting_movement_time(struct hsm_controller_context *controller)
{
    controller->timestamp = osKernelGetTickCount();
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

static void save_measured_time(uint32_t travel_time, struct hsm_controller_context *controller)
{
    controller->movement_config.time = travel_time;
    nvm_write(NVM_ID_TRAVEL_TIME, &controller->movement_config);
}

static state_machine_result_t exit_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);

    send_motor_stop_request();

    uint32_t measured_time = elapsed_ms(controller->timestamp); /* To be removed. */
    save_measured_time(measured_time, controller);

    controller->currently_operating_button = INVALID_PIN_ID;

    send_ui_notify_request();

    return EVENT_HANDLED;
}

/* Private function bodies ---------------------------------------------------*/

static void handleButtonPressed(union button_pressed_message *message, struct hsm_controller_context *controller)
{
    process_pressed_event(message, controller);

    if (controller->currently_operating_button == INVALID_PIN_ID)
    {
        controller->currently_operating_button = message->event.button;
        enum direction motor_direction = pin_id_to_direction(message->event.button);

        request_motor_movement(motor_direction);
        start_counting_movement_time(controller);
    }
}

static state_machine_result_t handleButtonReleased(state_machine_t *const pmachine,
                                                   union button_released_message *message,
                                                   struct hsm_controller_context *controller)
{
    process_released_event(message, controller);

    if (message->event.button == controller->currently_operating_button)
    {
        controller->currently_operating_button = INVALID_PIN_ID;
        return switch_state(pmachine, hsm_controller_idle);
    }
    else
    {
        return EVENT_HANDLED;
    }
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct hsm_controller_context *controller = CONTAINER_OF(pmachine, struct hsm_controller_context, machine);
    struct event *event_id = pmachine->Event;
    if (event_id->id == BUTTON_PRESSED_EVENT_ID)
    {
        handleButtonPressed((union button_pressed_message *)event_id, controller);
        return EVENT_HANDLED;
    }
    else if (event_id->id == BUTTON_RELEASED_EVENT_ID)
    {
        return handleButtonReleased(pmachine, (union button_released_message *)event_id, controller);
    }

    return EVENT_UN_HANDLED;
}

const state_t hsm_controller_config_mode_time_counting[] = {
    {event_handler, NULL, exit_handler, hsm_controller_config_mode, NULL, 4},
};
