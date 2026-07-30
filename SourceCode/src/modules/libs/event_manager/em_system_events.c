/*
 * system_events.c
 *
 *  Created on: 15 Feb 2023
 *      Author: dev
 */

#include <stdlib.h>

#include "em_system_events.h"

uint32_t system_executor;

CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(shutdown_request_subscriber_list, system_executor, ADD_SUBSCRIBER(NULL))
CREATE_EVENT(SHUTDOWN_EVENT, ADD_SUBSCRIBER(&shutdown_request_subscriber_list))
