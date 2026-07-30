/*
 * button_pressed_event.c
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#include "button_pressed_event.h"
#include "em_event.h"
#include "executors.h"
#include "hsm_button.h"
#include "hsm_scheduler.h"

CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor,
                                       ADD_SUBSCRIBER(&button_subscriber, &scheduler_subscriber))
CREATE_EVENT(BUTTON_PRESSED_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))
