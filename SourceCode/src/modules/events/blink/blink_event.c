/*
 * blink_event.c
 *
 *  Created on: 24 Jan 2023
 *      Author: dev
 */

#include "blink_event.h"
#include "em_event.h"
#include "executors.h"
#include "hsm_blink.h"

CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&blink_subscriber))
CREATE_EVENT(BLINK_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))
