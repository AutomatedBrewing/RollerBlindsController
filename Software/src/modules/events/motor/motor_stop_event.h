/*
 * motor_stop_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_MOTOR_STOP_EVENT_H_
#define SRC_MODULES_EVENTS_MOTOR_STOP_EVENT_H_

#include "em_event.h"

struct motor_stop_event
{
    struct event super;
};

MESSAGE_TYPE(motor_stop_event, motor_stop_message)

DECLARE_EVENT(MOTOR_STOP_EVENT)
#define MOTOR_STOP_EVENT_ID ID_OF(MOTOR_STOP_EVENT)

#endif /* SRC_MODULES_EVENTS_MOTOR_STOP_EVENT_H_ */
