/*
 * em_timer.h
 *
 *  Created on: 20 Feb 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENT_MANAGER_EM_TIMER_H_
#define SRC_MODULES_EVENT_MANAGER_EM_TIMER_H_

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os.h"
#include <stdbool.h>

#include "em_event.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/*@brief Typedef of notification callback. */
typedef void (*timer_callback_t)(void *context);

struct em_timer
{
    osTimerId_t os_timer_id;
    uint32_t period;
    struct event *event;
    void *context;
    bool repeating;
};

struct timer_event
{
    struct event super;
    void *context;
};

MESSAGE_TYPE(timer_event, timer_message)

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

/**
 * Creates timer.
 * @param timer Pointer to the timer structure.
 * @param callback Optional parameter. When timeout occurs, timer can communicate it to the user in two ways:
 *        1. By sending the event.
 *        2. By calling the callback function.
 *        When callback parameter is set to NULL, timer will send the message. Otherwise it will call the callback.
 * @param repeating true if repeating timer, false otherwise.
 * @param context Context passed on timer callback.
 *
 * @retval true in case of success, 0 otherwise.
 */
bool em_timer_create(struct em_timer *timer, timer_callback_t callback, bool repeating, void *context);

/**
 * Sets event id of the timer.
 * @param me Pointer to the timer structure.
 * @param event Event to set.
 *
 * @retval None.
 */
void em_timer_set_event_id(struct em_timer *me, struct event *event);

/**
 * Sets period of the timer.
 * @param me Pointer to the timer structure.
 * @param period_ms Period in [ms].
 *
 * @retval None.
 */
void em_timer_set_period(struct em_timer *me, uint32_t period_ms);

/**
 * Starts or restarts the timer.
 * @param me Pointer to the timer structure.
 *
 * @retval None.
 */
void em_timer_start(struct em_timer *me);

/**
 * Stops the timer.
 * @param me Pointer to the timer structure.
 *
 * @retval None.
 */
void em_timer_stop(struct em_timer *me);

/**
 * Return information if timer is running
 * @param me Pointer to the timer structure.
 *
 * @retval True Timer is running. False Otherwise.
 */
bool em_timer_is_running(struct em_timer *me);

/**
 * Return information when timer will expire.
 * @param me Pointer to the timer structure.
 *
 * @retval How many ms is needed to expire the timer.
 */
uint32_t em_timer_get_expiry_time(struct em_timer *me);

#endif /* SRC_MODULES_EVENT_MANAGER_EM_TIMER_H_ */
