/*
 * encoder_switch_pressed_event.h
 *
 *  Created on: 23 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_ENCODER_SWITCH_PRESSED_EVENT_H_
#define SRC_MODULES_EVENTS_ENCODER_SWITCH_PRESSED_EVENT_H_

#include "em_event.h"

struct encoder_switch_pressed_event
{
    struct event super;
};

MESSAGE_TYPE(encoder_switch_pressed_event, encoder_switch_pressed_message)

DECLARE_EVENT(ENCODER_SWITCH_PRESSED_EVENT)
#define ENCODER_SWITCH_PRESSED_EVENT_ID ID_OF(ENCODER_SWITCH_PRESSED_EVENT)

#endif /* SRC_MODULES_EVENTS_ENCODER_SWITCH_PRESSED_EVENT_H_ */
