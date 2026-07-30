/*
 * executor.c
 *
 *  Created on: 24 Jan 2023
 *      Author: dev
 */
#include "stdbool.h"
#include <string.h>

#include "em_event.h"
#include "em_executor.h"
#include "em_subscriber.h"
#include "em_system_events.h"

static void dispatch_event_for_all_subscribers(struct event *event, const struct subscriber **subscribers)
{
    const struct subscriber **subscribers_list = subscribers;
    const struct subscriber *subscriber;
    while (*subscribers_list != NULL)
    {
        subscriber = (const struct subscriber *)*subscribers_list;
        subscriber->handle_event(event);
        subscribers_list++;
    }
}

const struct subscriber **find_subscibers_for_executor(struct executor *me, struct event *event)
{
    const struct event_subscribers *subscribers_list = (const struct event_subscribers *)event->id;
    const struct event_subscribers_in_executor *subscriber;
    while (subscribers_list != NULL)
    {
        subscriber = (const struct event_subscribers_in_executor *)subscribers_list->subscibers;
        if (subscriber != NULL)
        {
            if (subscriber->executor == me)
            {
                return subscriber->subscribers;
            }
        }
        else
        {
            break;
        }
        subscribers_list++;
    }

    return NULL;
}

static void shutdown_all_subscribers(struct executor *me)
{
    const struct subscriber **subscribers_list = me->subscribers;
    const struct subscriber *subscriber;
    while (*subscribers_list != NULL)
    {
        subscriber = (const struct subscriber *)*subscribers_list;
        if (subscriber->shutdown)
        {
            subscriber->shutdown();
        }
        subscribers_list++;
    }
}

static bool check_for_system_event_and_process_if_needed(struct executor *me, struct event *event)
{
    if (event == SHUTDOWN_EVENT_ID)
    {
        shutdown_all_subscribers(me);
        return true;
    }
    return false;
}

static void dispatch_event(struct executor *me, struct event *event)
{
    bool event_processed;
    event_processed = check_for_system_event_and_process_if_needed(me, event);
    if (!event_processed)
    {
        const struct subscriber **subscribers = find_subscibers_for_executor(me, event);
        if (subscribers == NULL)
        {
            return;
        }
        dispatch_event_for_all_subscribers(event, subscribers);
    }
}

static void initialize_all_subscribers(struct executor *me)
{
    const struct subscriber **subscribers_list = me->subscribers;
    const struct subscriber *subscriber;
    while (*subscribers_list != NULL)
    {
        subscriber = (const struct subscriber *)*subscribers_list;
        if (subscriber->init)
        {
            subscriber->init(subscriber->init_flags);
        }
        subscribers_list++;
    }
}

static void executor_code(void *executor)
{
    struct executor *me = executor;
    initialize_all_subscribers(me);
    osStatus_t status;
    uint8_t receive_buffer[EVENT_SIZE];
    while (true)
    {
        status = osMessageQueueGet(me->queue, receive_buffer, NULL, osWaitForever);
        if (status == osOK)
        {
            dispatch_event(me, (struct event *)receive_buffer);
        }
    }
}

static bool create_thread(struct executor *executor, const osThreadAttr_t *attributes)
{
    executor->task = osThreadNew(executor_code, executor, attributes);
    if (executor->task == NULL)
    {
        return false;
    }
    return true;
}

static bool create_queue(struct executor *executor, uint8_t max_enqueued_events)
{
    executor->queue = osMessageQueueNew((uint32_t)max_enqueued_events, EVENT_SIZE, NULL);
    if (executor->queue == NULL)
    {
        return false;
    }
    return true;
}

bool em_create_executor(struct executor *executor, const osThreadAttr_t *attributes, uint8_t max_enqueued_events)
{
    bool result;
    result = create_thread(executor, attributes);
    if (!result)
    {
        return result;
    }

    result = create_queue(executor, max_enqueued_events);
    return result;
}

static void send_event_to_all_executors(void *message, const struct event_subscribers_in_executor **executor_list_entry)
{
    uint8_t msg_buffer[EVENT_SIZE] = {0};
    memcpy(msg_buffer, message, EVENT_SIZE);

    const struct executor *executor;
    while (*executor_list_entry != NULL)
    {
        executor = (*executor_list_entry)->executor;
        osMessageQueuePut(executor->queue, msg_buffer, 0U, 0U);
        executor_list_entry++;
    }
}

void em_publish_message(void *message)
{
    struct event *event_id = (struct event *)message;
    const struct event_subscribers **executors_list = (const struct event_subscribers **)event_id->id;
    send_event_to_all_executors(message, (const struct event_subscribers_in_executor **)executors_list);
}
