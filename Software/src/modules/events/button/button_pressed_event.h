/*
 * button_pressed_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_BUTTON_BUTTON_PRESSED_EVENT_H_
#define SRC_MODULES_EVENTS_BUTTON_BUTTON_PRESSED_EVENT_H_

#include "em_event.h"
#include "gpio_pins.h"

enum button_press_duration
{
    SHORT_PRESS,
    LONG_PRESS,
    VERY_LONG_PRESS,
};

struct button_pressed_event
{
    struct event super;
    enum board_input_pin_id button;
    enum button_press_duration duration;
};

MESSAGE_TYPE(button_pressed_event, button_pressed_message)

DECLARE_EVENT(BUTTON_PRESSED_EVENT)
#define BUTTON_PRESSED_EVENT_ID ID_OF(BUTTON_PRESSED_EVENT)

#endif /* SRC_MODULES_EVENTS_BUTTON_BUTTON_PRESSED_EVENT_H_ */
