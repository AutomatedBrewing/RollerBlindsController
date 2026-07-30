/*
 * get_irrigation_schedule_answer_event.h
 *
 *  Created on: 8 May 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_SCHEDULER_GET_IRRIGATION_SCHEDULE_ANSWER_EVENT_H_
#define SRC_MODULES_EVENTS_SCHEDULER_GET_IRRIGATION_SCHEDULE_ANSWER_EVENT_H_

#include "em_event.h"
#include "scheduler_context.h"

struct get_irrigation_schedule_answer_event
{
    struct event super;
    struct irrigation_week irrigation_plan;
};

MESSAGE_TYPE(get_irrigation_schedule_answer_event, get_irrigation_schedule_answer_message)

DECLARE_EVENT(GET_IRRIGATION_SCHEDULE_ANSWER_EVENT)
#define GET_IRRIGATION_SCHEDULE_ANSWER_EVENT_ID ID_OF(GET_IRRIGATION_SCHEDULE_ANSWER_EVENT)

#endif /* SRC_MODULES_EVENTS_SCHEDULER_GET_IRRIGATION_SCHEDULE_ANSWER_EVENT_H_ */
