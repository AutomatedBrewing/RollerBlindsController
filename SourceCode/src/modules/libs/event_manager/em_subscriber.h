/*
 * subscriber.h
 *
 *  Created on: 23 Jan 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENT_MANAGER_EM_SUBSCRIBER_H_
#define SRC_MODULES_EVENT_MANAGER_EM_SUBSCRIBER_H_

/* Private includes ----------------------------------------------------------*/
#include <stdint.h>

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct subscriber
{
    uint32_t init_flags;               /* These flags are passed on init call. */
    void (*init)(uint32_t flags);      /* Function pointer used to initialize subscriber. */
    void (*handle_event)(void *event); /* Function pointer used to handle event. */
    void (*shutdown)(void);            /* Function pointer used to terminate the subscriber. */
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_MODULES_EVENT_MANAGER_EM_SUBSCRIBER_H_ */
