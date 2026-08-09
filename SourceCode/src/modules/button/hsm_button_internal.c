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
#include "hsm_button_internal.h"


/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

void send_event(void * event,
                enum board_input_pin_id button,  
                enum button_press_duration duration)
{
    union button_pressed_message message = {0};
    em_set_message_event(&message.event.super, event);
    message.event.button = button;
    message.event.duration = duration;
    em_publish_message(&message);
}
