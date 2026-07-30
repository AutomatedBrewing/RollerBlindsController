/*
 * button_pressed_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_BUTTON_BUTTON_PRESSED_EVENT_H_
#define SRC_MODULES_EVENTS_BUTTON_BUTTON_PRESSED_EVENT_H_

#include "em_event.h"

struct button_pressed_event
{
    struct event super;
};

MESSAGE_TYPE(button_pressed_event, button_pressed_message)

DECLARE_EVENT(BUTTON_PRESSED_EVENT)
#define BUTTON_PRESSED_EVENT_ID ID_OF(BUTTON_PRESSED_EVENT)

#endif /* SRC_MODULES_EVENTS_BUTTON_BUTTON_PRESSED_EVENT_H_ */
