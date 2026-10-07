#include "soft_timer.h"

#include <stddef.h>


void soft_timer_init(void)
{
}

soft_timer_t *soft_timer_create(soft_timer_callback_t callback, bool periodic, void *argument)
{
    (void)(callback);
    (void)(periodic);
    (void)(argument);
    return NULL;
}

bool soft_timer_start(soft_timer_t *timer, uint32_t ticks)
{
    (void)(timer);
    (void)(ticks);
    return true;
}

bool soft_timer_stop(soft_timer_t *timer)
{
    (void)(timer);
    return true;
}

bool soft_timer_is_running(const soft_timer_t *timer)
{
    (void)(timer);
    return true;
}

void soft_timer_tick(void)
{
}

void soft_timer_handler(void)
{
}