/*
 * button_pressed_event.c
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#include "motor_down_event.h"
#include "em_event.h"
#include "executors.h"

#include "hsm_motor.h"

CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&motor_subscriber))
CREATE_EVENT(MOTOR_DOWN_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))
