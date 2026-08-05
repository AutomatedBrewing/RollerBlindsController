/*
 * em_timer_mock.h
 *
 *  Created on: 18 Aug 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_LIBS_EVENT_MANAGER_MOCKS_EM_TIMER_MOCK_H_
#define SRC_MODULES_LIBS_EVENT_MANAGER_MOCKS_EM_TIMER_MOCK_H_

/* Private includes ----------------------------------------------------------*/
#include "em_timer.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
bool __wrap_em_timer_create(struct em_timer *timer, timer_callback_t callback, bool repeating, void *context);
void __wrap_em_timer_set_event_id(struct em_timer *me, struct event *event);
void __wrap_em_timer_set_period(struct em_timer *me, uint32_t period_ms);
void __wrap_em_timer_start(struct em_timer *me);
void __wrap_em_timer_stop(struct em_timer *me);
bool __wrap_em_timer_is_running(struct em_timer *me);
uint32_t __wrap_em_timer_get_expiry_time(struct em_timer *me);

void expect_em_timer_create(struct em_timer *expected_timer, timer_callback_t expected_callback,
                            bool expected_repeating, void *expected_context, bool expected_result);
void expect_em_timer_set_event_id(struct em_timer *expected_timer, struct event *expected_event);
void expect_em_timer_set_period(struct em_timer *expected_timer, uint32_t expected_period_ms);
void expect_em_timer_start(struct em_timer *expected_timer);
void expect_em_timer_stop(struct em_timer *expected_timer);
void expect_em_timer_is_running(struct em_timer *expected_timer, bool expected_result);
void expect_em_timer_get_expiry_time(struct em_timer *expected_timer, uint32_t expected_result);

#endif /* SRC_MODULES_LIBS_EVENT_MANAGER_MOCKS_EM_TIMER_MOCK_H_ */
