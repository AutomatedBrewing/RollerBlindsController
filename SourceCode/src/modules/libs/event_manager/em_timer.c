/*
 * timer.c
 *
 *  Created on: 20 Feb 2023
 *      Author: dev
 */
#include <string.h>

#include "em_timer.h"

static void timer_expired_callback(void *argument)
{
    struct em_timer *timer = argument;
    union timer_message message = {0};
    message.event.super.id = timer->event;
    message.event.context = timer->context;
    em_publish_message((void *)&message);
}

static osTimerType_t get_timer_type(bool repeating)
{
    return repeating ? osTimerPeriodic : osTimerOnce;
}

bool em_timer_create(struct em_timer *timer, bool repeating, void *context)
{
    osTimerType_t timer_type = get_timer_type(repeating);
    timer->context = context;
    timer->repeating = repeating;
    timer->period = 0;
    timer->os_timer_id = osTimerNew(timer_expired_callback, timer_type, timer, NULL);
    if (timer->os_timer_id != NULL)
    {
        return true;
    }
    return false;
}

void em_timer_set_event_id(struct em_timer *me, struct event *event)
{
    me->event = event;
}

void em_timer_set_period(struct em_timer *me, uint32_t period_ms)
{
    me->period = period_ms;
    if (osTimerIsRunning(me->os_timer_id))
    {
        osTimerStart(me->os_timer_id, me->period);
    }
}

void em_timer_start(struct em_timer *me)
{
    osTimerStart(me->os_timer_id, me->period);
}

void em_timer_stop(struct em_timer *me)
{
    osTimerStop(me->os_timer_id);
}

bool em_timer_is_running(struct em_timer *me)
{
    return (bool)osTimerIsRunning(me->os_timer_id);
}
