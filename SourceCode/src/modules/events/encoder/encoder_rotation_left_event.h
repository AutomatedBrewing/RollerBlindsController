/*
 * encoder_rotation_left_event.h
 *
 *  Created on: 23 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_ENCODER_ENCODER_ROTATION_LEFT_EVENT_H_
#define SRC_MODULES_EVENTS_ENCODER_ENCODER_ROTATION_LEFT_EVENT_H_

#include "em_event.h"

struct encoder_rotation_left_event
{
    struct event super;
};

MESSAGE_TYPE(encoder_rotation_left_event, encoder_rotation_left_message)

DECLARE_EVENT(ENCODER_ROTATION_LEFT_EVENT)
#define ENCODER_ROTATION_LEFT_EVENT_ID ID_OF(ENCODER_ROTATION_LEFT_EVENT)

#endif /* SRC_MODULES_EVENTS_ENCODER_ENCODER_ROTATION_LEFT_EVENT_H_ */
