/*
 * button_pressed_event.c
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#include "get_irrigation_schedule_answer_event.h"
#include "em_event.h"
#include "executors.h"
#include "hsm_display.h"
#include "hsm_scheduler.h"

CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor,
                                       ADD_SUBSCRIBER(&scheduler_subscriber, &display_subscriber))
CREATE_EVENT(GET_IRRIGATION_SCHEDULE_ANSWER_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))
