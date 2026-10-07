/*
 * system_events.h
 *
 *  Created on: 17 Feb 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENT_MANAGER_EM_SYSTEM_EVENTS_H_
#define SRC_MODULES_EVENT_MANAGER_EM_SYSTEM_EVENTS_H_

/* Private includes ----------------------------------------------------------*/
#include "em_event.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct event_manager_shutdown_request
{
    struct event super;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
MESSAGE_TYPE(event_manager_shutdown_request, shutdown_request_message)
DECLARE_EVENT(SHUTDOWN_EVENT)
#define SHUTDOWN_EVENT_ID ID_OF(SHUTDOWN_EVENT)

/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_MODULES_EVENT_MANAGER_EM_SYSTEM_EVENTS_H_ */
