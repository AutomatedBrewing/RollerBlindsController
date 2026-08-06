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

static void send_event(void * event,
                enum board_input_pin_id button,  
                enum button_press_duration duration)
{
    union button_pressed_message message = {0};
    em_set_message_event(&message.event.super, event);
    message.event.button = button;
    message.event.duration = duration;
    em_publish_message(&message);
}

static void handle_previously_released(struct hsm_button_context *button)
{
    button->state = BUTTON_SHORT_PRESSED;
    send_event(button->configuration->events.event_pressed, button->configuration->pin_id, SHORT_PRESS);
    
    /* Restart the timer. Possibly button if pressed longer. */
    em_timer_set_period(&button->timer, button->configuration->timings.long_press_time);
    em_timer_start(&button->timer);
}

static void handle_previously_short_pressed(struct hsm_button_context *button)
{
    button->state = BUTTON_LONG_PRESSED;
    send_event(button->configuration->events.event_pressed, button->button_info->pin_id, LONG_PRESS);
    
    /* Restart the timer. Possibly button if pressed longer. */
    em_timer_set_period(&button->timer, button->configuration->timings.very_long_press_time);
    em_timer_start(&button->timer);
}

static void handle_previously_long_pressed(struct hsm_button_context *button)
{
    button->state = BUTTON_VERY_LONG_PRESSED;
    send_event(button->configuration->events.event_pressed, button->button_info->pin_id, VERY_LONG_PRESS);
    
    /* Reset the timer period. */
    em_timer_set_period(&button->timer, button->configuration->timings.debounce_time);
}

static void send_button_pressed_message(struct hsm_button_context *button)
{
    switch (button->state)
    {
    case BUTTON_RELEASED:
        handle_previously_released(button);
        return;
    
    case BUTTON_SHORT_PRESSED:
        handle_previously_short_pressed(button);
        return;

    case BUTTON_LONG_PRESSED:
        handle_previously_long_pressed(button);
        return;

    case BUTTON_VERY_LONG_PRESSED:
        /* Nothing to do.*/
        break;

    default:
        break;
    }
}

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_button_context *button = CONTAINER_OF(pmachine, struct hsm_button_context, machine);
    button_input_wait_for_event(button, false);
    handle_previously_released(button);
    return EVENT_HANDLED;
}

static bool isButtonInactive(union timer_message *message)
{
    struct hsm_button_context *button = message->event.context;
    if (gpio_input_is_active(button->button_handle))
    {
        send_button_pressed_message(button);
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
        if (isButtonInactive((union timer_message *)event_id))
        {
            traverse_state(pmachine, hsm_button_released);
        }
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

const state_t hsm_button_pressed[] = {
    {event_handler, entry_handler, NULL, hsm_button_root, NULL, 1},
};
