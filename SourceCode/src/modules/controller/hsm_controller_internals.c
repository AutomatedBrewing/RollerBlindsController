/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"
#include "gpio_pins.h"

#include "em_event.h"

#include "hsm_controller_internal.h"
#include "utils.h"

#include "motor_up_event.h"
#include "motor_down_event.h"
#include "motor_stop_event.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
uint32_t pin_id_to_bit(enum board_input_pin_id pin_id)
{
    switch (pin_id)
    {
        case BUTTON_LOCAL_UP_PIN_ID:
            return LOCAL_UP_BIT_POS;
        case BUTTON_LOCAL_DOWN_PIN_ID:
            return LOCAL_DOWN_BIT_POS;
        case BUTTON_REMOTE_UP_PIN_ID:
            return REMOTE_UP_BIT_POS;
        case BUTTON_REMOTE_DOWN_PIN_ID:
            return REMOTE_DOWN_BIT_POS;
        default: 
            return 0UL;
    }
}
enum direction pin_id_to_direction(enum board_input_pin_id pin_id)
{
      switch (pin_id)
    {
        case BUTTON_LOCAL_UP_PIN_ID:
        case BUTTON_REMOTE_UP_PIN_ID:
            return UP;
        case BUTTON_LOCAL_DOWN_PIN_ID:
        case BUTTON_REMOTE_DOWN_PIN_ID:
            return DOWN;

        default: 
            return INVALID;
    }  
}
/* Private function bodies ---------------------------------------------------*/

void process_pressed_event(union button_pressed_message *event, struct hsm_controller_context *controller)
{
    enum board_input_pin_id pin_id = event->event.button;
    uint32_t bit = pin_id_to_bit(pin_id);
    SET_BITS(controller->buttons, bit);
}

void process_released_event(union button_pressed_message *event,struct hsm_controller_context *controller)
{
    enum board_input_pin_id pin_id = event->event.button;
    uint32_t bit = pin_id_to_bit(pin_id);
    CLEAR_BITS(controller->buttons, bit);
}


void send_motor_up_request(void)
{
    union motor_up_message message = {0};
    em_set_message_event(&message.event.super, MOTOR_UP_EVENT_ID);
    em_publish_message(&message);
}

void send_motor_down_request(void)
{
    union motor_down_message message = {0};
    em_set_message_event(&message.event.super, MOTOR_DOWN_EVENT_ID);
    em_publish_message(&message);
}

void send_motor_stop_request(void)
{
    union motor_down_message message = {0};
    em_set_message_event(&message.event.super, MOTOR_DOWN_EVENT_ID);
    em_publish_message(&message);
}