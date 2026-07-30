/*
 * set_irrigation_schedule_event.h
 *
 *  Created on: 8 May 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_SCHEDULER_SET_IRRIGATION_SCHEDULE_EVENT_H_
#define SRC_MODULES_EVENTS_SCHEDULER_SET_IRRIGATION_SCHEDULE_EVENT_H_

#include "em_event.h"
#include "scheduler_context.h"

struct set_irrigation_schedule_event
{
    struct event super;
    struct irrigation_week irrigation_plan;
};

MESSAGE_TYPE(set_irrigation_schedule_event, set_irrigation_schedule_message)

DECLARE_EVENT(SET_IRRIGATION_SCHEDULE_EVENT)
#define SET_IRRIGATION_SCHEDULE_EVENT_ID ID_OF(SET_IRRIGATION_SCHEDULE_EVENT)

#endif /* SRC_MODULES_EVENTS_SCHEDULER_SET_IRRIGATION_SCHEDULE_EVENT_H_ */
