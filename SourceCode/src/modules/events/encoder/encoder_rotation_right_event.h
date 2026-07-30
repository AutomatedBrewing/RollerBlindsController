/*
 * encoder_rotation_right_event.h
 *
 *  Created on: 23 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_ENCODER_ENCODER_ROTATION_RIGHT_EVENT_H_
#define SRC_MODULES_EVENTS_ENCODER_ENCODER_ROTATION_RIGHT_EVENT_H_

#include "em_event.h"

struct encoder_rotation_right_event
{
    struct event super;
};

MESSAGE_TYPE(encoder_rotation_right_event, encoder_rotation_right_message)

DECLARE_EVENT(ENCODER_ROTATION_RIGHT_EVENT)
#define ENCODER_ROTATION_RIGHT_EVENT_ID ID_OF(ENCODER_ROTATION_RIGHT_EVENT)

#endif /* SRC_MODULES_EVENTS_ENCODER_ENCODER_ROTATION_RIGHT_EVENT_H_ */
