/*
 * button_pressed_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef CONTROLLER_INTERNAL_H_
#define CONTROLLER_INTERNAL_H_

#include "button_pressed_event.h"
#include "button_released_event.h"
#include "hsm_controller.h"

extern struct hsm_controller_context controller;

uint32_t pin_id_to_bit(enum board_input_pin_id pin_id);
enum direction pin_id_to_direction(enum board_input_pin_id pin_id);
void process_pressed_event(union button_pressed_message *event, struct hsm_controller_context *controller);
void process_released_event(union button_released_message *event, struct hsm_controller_context *controller);

void send_motor_up_request(void);
void send_motor_down_request(void);
void send_motor_stop_request(void);
void send_ui_notify_request(void);

#endif /* CONTROLLER_INTERNAL_H_ */
