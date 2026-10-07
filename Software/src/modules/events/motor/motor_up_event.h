/*
 * motor_up_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_MOTOR_UP_EVENT_H_
#define SRC_MODULES_EVENTS_MOTOR_UP_EVENT_H_

#include "em_event.h"

struct motor_up_event
{
    struct event super;
};

MESSAGE_TYPE(motor_up_event, motor_up_message)

DECLARE_EVENT(MOTOR_UP_EVENT)
#define MOTOR_UP_EVENT_ID ID_OF(MOTOR_UP_EVENT)

#endif /* SRC_MODULES_EVENTS_MOTOR_UP_EVENT_H_ */
