/*
 * cmsis_mock.h
 *
 *  Created on: 9 Feb 2023
 *      Author: dev
 */

#ifndef SRC_OS_FREERTOS_TEST_CMSIS_MOCK_H_
#define SRC_OS_FREERTOS_TEST_CMSIS_MOCK_H_

#include "cmsis_os.h"

osThreadId_t __wrap_osThreadNew(osThreadFunc_t func, void *argument, const osThreadAttr_t *attr);
osMessageQueueId_t __wrap_osMessageQueueNew(uint32_t msg_count, uint32_t msg_size, const osMessageQueueAttr_t *attr);
osStatus_t __wrap_osMessageQueueGet(osMessageQueueId_t mq_id, void *msg_ptr, uint8_t *msg_prio, uint32_t timeout);
osStatus_t __wrap_osMessageQueuePut (osMessageQueueId_t mq_id, const void *msg_ptr, uint8_t msg_prio, uint32_t timeout);
osTimerId_t __wrap_osTimerNew (osTimerFunc_t func, osTimerType_t type, void *argument, const osTimerAttr_t *attr);
osStatus_t __wrap_osTimerStart (osTimerId_t timer_id, uint32_t ticks);
uint32_t __wrap_osTimerIsRunning (osTimerId_t timer_id);
osStatus_t __wrap_osTimerStop (osTimerId_t timer_id);

void expect_osThreadNew(void *argument, const osThreadAttr_t *attr, osThreadId_t returned_thread_id);

void expect_osMessageQueueNew(uint32_t msg_count, uint32_t msg_size, const osMessageQueueAttr_t *attr, osMessageQueueId_t returned_queue_id);
void expect_osMessageQueueGet(osMessageQueueId_t mq_id, uint32_t timeout, osStatus_t returned_id, void * msg, uint32_t msg_size);
void expect_osMessageQueuePut(osMessageQueueId_t mq_id, void * expected_message, uint32_t expected_message_size, uint32_t timeout, osStatus_t returned_id);

void expect_osTimerNew(osTimerType_t type, void *argument, osTimerId_t returned_id);
void expect_osTimerStart(osTimerId_t expected_timer_id, uint32_t expected_ticks, osStatus_t returned_status);
void expect_osTimerStop(osTimerId_t expected_timer_id, uint32_t returned_status);
void expect_osTimerIsRunning(osTimerId_t expected_timer_id, uint32_t returned_status);



#endif /* SRC_OS_FREERTOS_TEST_CMSIS_MOCK_H_ */
