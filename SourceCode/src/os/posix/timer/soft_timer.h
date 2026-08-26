#ifndef SOFT_TIMER_H
#define SOFT_TIMER_H

#include <stdint.h>
#include <stdbool.h>

#ifndef SOFT_TIMER_MAX
#define SOFT_TIMER_MAX 16U
#endif

typedef void (*soft_timer_callback_t)(void *argument);

typedef struct
{
    bool allocated;
    bool running;
    bool periodic;

    uint32_t period;
    uint32_t elapsed;

    soft_timer_callback_t callback;
    void *argument;
} soft_timer_t;

/**
 * @brief Initialize timer subsystem.
 */
void soft_timer_init(void);

/**
 * @brief Allocate a timer.
 *
 * @return Pointer to allocated timer or NULL if no timer is available.
 */
soft_timer_t *soft_timer_create(soft_timer_callback_t callback,
                                bool periodic,
                                void *argument);

/**
 * @brief Start or restart a timer.
 *
 * @param timer Timer object.
 * @param ticks Timeout in milliseconds.
 *
 * @return true on success.
 */
bool soft_timer_start(soft_timer_t *timer, uint32_t ticks);

/**
 * @brief Stop a timer.
 *
 * @param timer Timer object.
 *
 * @return true on success.
 */
bool soft_timer_stop(soft_timer_t *timer);

/**
 * @brief Check whether a timer is running.
 */
bool soft_timer_is_running(const soft_timer_t *timer);

/**
 * @brief Increment timer counters.
 *
 * This function should be called from SysTick every 1 ms.
 *
 * IMPORTANT:
 * This function does not execute callbacks.
 */
void soft_timer_tick(void);

/**
 * @brief Process expired timers.
 *
 * This function should be called periodically from main context.
 * Timer callbacks are executed from this function.
 */
void soft_timer_handler(void);

#endif /* SOFT_TIMER_H */