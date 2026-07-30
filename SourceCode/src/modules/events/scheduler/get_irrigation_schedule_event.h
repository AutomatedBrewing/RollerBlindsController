/*
 * scheduler_get_schedule.h
 *
 *  Created on: 8 May 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_SCHEDULER_SCHEDULER_GET_SCHEDULE_H_
#define SRC_MODULES_EVENTS_SCHEDULER_SCHEDULER_GET_SCHEDULE_H_

#include "em_event.h"
#include "scheduler_context.h"

struct get_irrigation_schedule_event
{
    struct event super;
};

MESSAGE_TYPE(get_irrigation_schedule_event, get_irrigation_schedule_message)

DECLARE_EVENT(GET_IRRIGATION_SCHEDULE_EVENT)
#define GET_IRRIGATION_SCHEDULE_EVENT_ID ID_OF(GET_IRRIGATION_SCHEDULE_EVENT)

#endif /* SRC_MODULES_EVENTS_SCHEDULER_SCHEDULER_GET_SCHEDULE_H_ */
