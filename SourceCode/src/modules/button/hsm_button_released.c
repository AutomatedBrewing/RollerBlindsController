/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"

#include "em_event.h"

#include "button_released_event.h"
#include "hsm_button.h"
#include "hsm_button_states.h"

#include "utils.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static void send_button_released_message(struct hsm_button_context *button)
{
    union button_released_message message = {0};
    if (button->event_released)
    {
        em_set_message_event(&message.event.super, button->event_released);
        em_publish_message(&message);
    }
}

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_button_context *button = CONTAINER_OF(pmachine, struct hsm_button_context, machine);
    button->state = BUTTON_RELEASED;
    button_input_wait_for_event(button, true);
    send_button_released_message(button);
    return EVENT_HANDLED;
}

static bool isButtonActive(union timer_message *message)
{
    struct hsm_button_context *button = message->event.context;
    if (!gpio_input_is_active(button->button_handle))
    {
        gpio_input_interrupt_enable(button->button_handle);
        return false;
    }
    return true;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == TIMER_DEBOUNCE_EVENT_EVENT_ID)
    {
        if (isButtonActive((union timer_message *)event_id))
        {
            traverse_state(pmachine, hsm_button_pressed);
        }
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_button_released[] = {
    {event_handler, entry_handler, NULL, hsm_button_root, NULL, 1},
};
