/*
 * button_released_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_BUTTON_BUTTON_RELEASED_EVENT_H_
#define SRC_MODULES_EVENTS_BUTTON_BUTTON_RELEASED_EVENT_H_

#include "em_event.h"

struct button_released_event
{
    struct event super;
};

MESSAGE_TYPE(button_released_event, button_released_message)

DECLARE_EVENT(BUTTON_RELEASED_EVENT)
#define BUTTON_RELEASED_EVENT_ID ID_OF(BUTTON_RELEASED_EVENT)

#endif /* SRC_MODULES_EVENTS_BUTTON_BUTTON_RELEASED_EVENT_H_ */
