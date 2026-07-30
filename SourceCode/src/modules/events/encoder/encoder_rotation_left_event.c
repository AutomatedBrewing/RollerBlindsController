/*
 * encoder_rotation_left_event.c
 *
 *  Created on: 23 Mar 2023
 *      Author: dev
 */

#include "encoder_rotation_left_event.h"
#include "em_event.h"
#include "executors.h"
#include "hsm_display.h"

CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&display_subscriber))
CREATE_EVENT(ENCODER_ROTATION_LEFT_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))
