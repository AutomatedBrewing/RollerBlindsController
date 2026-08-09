/*
 * button_pressed_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef BUTTON_INTERNAL_H_
#define BUTTON_INTERNAL_H_

#include "hsm_button.h"
#include "button_pressed_event.h"

extern struct hsm_button_context buttons[NO_OF_SUPPORTED_BUTTONS];

void send_event(void * event,
                enum board_input_pin_id button,  
                enum button_press_duration duration);

#endif /* BUTTON_INTERNAL_H_ */
