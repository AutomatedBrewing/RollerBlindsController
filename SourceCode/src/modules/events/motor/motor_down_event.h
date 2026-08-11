/*
 * motor_down_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_MOTOR_DOWN_EVENT_H_
#define SRC_MODULES_EVENTS_MOTOR_DOWN_EVENT_H_

#include "em_event.h"

struct motor_down_event
{
    struct event super;
};

MESSAGE_TYPE(motor_down_event, motor_down_message)

DECLARE_EVENT(MOTOR_DOWN_EVENT)
#define MOTOR_DOWN_EVENT_ID ID_OF(MOTOR_DOWN_EVENT)

#endif /* SRC_MODULES_EVENTS_MOTOR_DOWN_EVENT_H_ */
