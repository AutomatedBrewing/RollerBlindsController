#include "soft_timer.h"

#include <stddef.h>

static soft_timer_t timers[SOFT_TIMER_MAX];

void soft_timer_init(void)
{
    for (uint32_t i = 0U; i < SOFT_TIMER_MAX; ++i)
    {
        timers[i].allocated = false;
        timers[i].running = false;
        timers[i].periodic = false;
        timers[i].period = 0U;
        timers[i].elapsed = 0U;
        timers[i].callback = NULL;
        timers[i].argument = NULL;
    }
}

soft_timer_t *soft_timer_create(soft_timer_callback_t callback,
                                bool periodic,
                                void *argument)
{
    if (callback == NULL)
    {
        return NULL;
    }

    for (uint32_t i = 0U; i < SOFT_TIMER_MAX; ++i)
    {
        if (!timers[i].allocated)
        {
            timers[i].allocated = true;
            timers[i].running = false;
            timers[i].periodic = periodic;
            timers[i].period = 0U;
            timers[i].elapsed = 0U;
            timers[i].callback = callback;
            timers[i].argument = argument;

            return &timers[i];
        }
    }

    return NULL;
}

bool soft_timer_start(soft_timer_t *timer, uint32_t ticks)
{
    if ((timer == NULL) ||
        !timer->allocated ||
        (ticks == 0U))
    {
        return false;
    }

    timer->period = ticks;
    timer->elapsed = 0U;
    timer->running = true;

    return true;
}

bool soft_timer_stop(soft_timer_t *timer)
{
    if ((timer == NULL) || !timer->allocated)
    {
        return false;
    }

    timer->running = false;
    timer->elapsed = 0U;

    return true;
}

bool soft_timer_is_running(const soft_timer_t *timer)
{
    if ((timer == NULL) || !timer->allocated)
    {
        return false;
    }

    return timer->running;
}

void soft_timer_tick(void)
{
    for (uint32_t i = 0U; i < SOFT_TIMER_MAX; ++i)
    {
        if (timers[i].allocated && timers[i].running)
        {
            if (timers[i].elapsed < UINT32_MAX)
            {
                ++timers[i].elapsed;
            }
        }
    }
}

void soft_timer_handler(void)
{
    for (uint32_t i = 0U; i < SOFT_TIMER_MAX; ++i)
    {
        soft_timer_t *timer = &timers[i];

        if (!timer->allocated || !timer->running)
        {
            continue;
        }

        if (timer->elapsed < timer->period)
        {
            continue;
        }

        if (timer->periodic)
        {
            /*
             * Preserve the timer phase instead of resetting elapsed
             * to zero. This makes the timer independent of the exact
             * frequency at which soft_timer_handler() is called.
             */
            timer->elapsed -= timer->period;
        }
        else
        {
            timer->running = false;
            timer->elapsed = 0U;
        }

        /*
         * Callback is intentionally called from main context.
         */
        timer->callback(timer->argument);
    }
}