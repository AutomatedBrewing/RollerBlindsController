/*
 * executor.h
 *
 *  Created on: 23 Jan 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENT_MANAGER_EM_EXECUTOR_H_
#define SRC_MODULES_EVENT_MANAGER_EM_EXECUTOR_H_

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os.h"
#include <stdbool.h>

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/

struct executor
{
    void *task;
    void *queue;
    const struct subscriber **subscribers;
};

/* Public macro --------------------------------------------------------------*/

/**
 * Defines executor with supported subscribers.
 * @param executor_name Name of the executor.
 * @param subscribers_list List of supported subscribers.
 *
 * Adding subscribers is mandatory.
 */
#define CREATE_EXECUTOR_WITH_SUPPORTED_SUBSCRIBERS(executor_name, subscribers_list)                                    \
    static const struct subscriber *executor_name##_internal_subscriber_list[] = {subscribers_list, NULL};             \
    struct executor executor_name = {.subscribers = executor_name##_internal_subscriber_list};

/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
/**
 * Creates executor.
 * @param executor Name of the executor.
 * @param attributes Attributes of task.
 * @param max_enqueued_events Internal queue size (used to fetch messages).
 *
 * @retval true in case of success, 0 otherwise.
 */
bool em_create_executor(struct executor *executor, const osThreadAttr_t *attributes, uint8_t max_enqueued_events);

#endif /* SRC_MODULES_EVENT_MANAGER_EM_EXECUTOR_H_ */
