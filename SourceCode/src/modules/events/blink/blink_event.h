/*
 * blink_event.h
 *
 *  Created on: 24 Jan 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_BLINK_EVENT_H_
#define SRC_MODULES_EVENTS_BLINK_EVENT_H_

#include "em_event.h"

struct blink_event
{
    struct event super;
};

MESSAGE_TYPE(blink_event, blink_message)

DECLARE_EVENT(BLINK_EVENT)
#define BLINK_EVENT_ID ID_OF(BLINK_EVENT)

#endif /* SRC_MODULES_EVENTS_BLINK_EVENT_H_ */
