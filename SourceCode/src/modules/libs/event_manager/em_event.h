/*
 * event.h
 *
 *  Created on: 24 Jan 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENT_MANAGER_EM_EVENT_H_
#define SRC_MODULES_EVENT_MANAGER_EM_EVENT_H_

/* Private includes ----------------------------------------------------------*/
#include <stdint.h>
#include <stdlib.h>

#include "em_subscriber.h"

/* Public define -------------------------------------------------------------*/
/* Size of an event. It directly influences the executors queue size. */
#define EVENT_SIZE (32)

/* Public typedef ------------------------------------------------------------*/
typedef void *event_id_t;

struct event
{
    event_id_t id;
};

struct event_subscribers_in_executor
{
    void *executor;
    /* Null terminated list of subscribers.*/
    const struct subscriber **subscribers;
};

struct event_subscribers
{
    /* NULL terminated list of subscribers. */
    const struct event_subscribers_in_executor **subscibers;
};

/* Public macro --------------------------------------------------------------*/
/* Used to pass multiple subscibers at once. */
#define ADD_SUBSCRIBER(...) __VA_ARGS__

/**
 * Create list of subscribers per executor.
 * @param list_name Name of the list.
 * @param executor_name Name of the executor.
 * @param subscribers_list List of the subscribers.
 *
 * Example:
 * uint32_t system_executor;
 * CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(shutdown_request_subscriber_list, system_executor, ADD_SUBSCRIBER(NULL))
 *
 */
#define CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(list_name, executor_name, subscribers_list)                             \
    static const struct subscriber *executor_name##_subscriber_list[] = {subscribers_list, NULL};                      \
    static const struct event_subscribers_in_executor list_name = {.subscribers = executor_name##_subscriber_list,     \
                                                                   .executor = &executor_name};

/**
 * Creates ane event.
 * @param event_name Name of the event.
 * @param subscribers_list List of the subscribers.
 *
 * Example:
 * uint32_t system_executor;
 * CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(shutdown_request_subscriber_list, system_executor, ADD_SUBSCRIBER(NULL))
 * CREATE_EVENT(SHUTDOWN_EVENT, ADD_SUBSCRIBER(&shutdown_request_subscriber_list))
 */
#define CREATE_EVENT(event_name, subscribers_list)                                                                     \
    const struct event_subscribers_in_executor *event_name##_executors_list[] = {subscribers_list, NULL};

/**
 * Message type has to be declared before declaring event.
 * @param event_struct_tag name of the event type.
 * @param message_union_tag Name of the message type.
 *
 * Example:
 * struct event_manager_shutdown_request
 *   {
 *       struct event super;
 *   };
 *
 * MESSAGE_TYPE(event_manager_shutdown_request, shutdown_request_message)
 */
#define MESSAGE_TYPE(event_struct_tag, message_union_tag)                                                              \
    union message_union_tag {                                                                                          \
        struct event_struct_tag event;                                                                                 \
        uint8_t padding[EVENT_SIZE];                                                                                   \
    };                                                                                                                 \
    _Static_assert(sizeof(struct event_struct_tag) <= EVENT_SIZE,                                                      \
                   "struct " #event_struct_tag " is too\
 "                                                               \
                   "big to be an event. Reduce its size or increase EVENT_SIZE.");

/**
 * Returns unique ID of the event.
 * @param event_name Name of the event.
 */
#define ID_OF(event_name) (struct event *)event_name##_executors_list

/**
 * Declares the event. Used in header file.
 * @param event_name Name of the event.
 *
 * When declaring an event, do it like this:
 *
 * struct event_manager_shutdown_request
 *   {
 *       struct event super;
 *   };
 *
 * MESSAGE_TYPE(event_manager_shutdown_request, shutdown_request_message)
 * DECLARE_EVENT(SHUTDOWN_EVENT)
 * #define SHUTDOWN_EVENT_ID ID_OF(SHUTDOWN_EVENT)
 *
 * In application use only `SHUTDOWN_EVENT_ID`.
 *
 */
#define DECLARE_EVENT(event_name) extern const struct event_subscribers_in_executor *event_name##_executors_list[];

/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

/**
 * Publish message and sends it to all subscribers.
 * @param message Message to publish.
 * @return None.
 */
void em_publish_message(void *message);

static inline void em_set_message_event(struct event *super, void *event)
{
    super->id = event;
}

#endif /* SRC_MODULES_EVENT_MANAGER_EM_EVENT_H_ */
