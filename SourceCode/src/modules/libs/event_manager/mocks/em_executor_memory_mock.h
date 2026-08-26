/*
 * em_timer_mock.h
 *
 *  Created on: 18 Aug 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_LIBS_EVENT_MANAGER_MOCKS_EM_EXECUTOR_MEMORY_MOCK_H_
#define SRC_MODULES_LIBS_EVENT_MANAGER_MOCKS_EM_EXECUTOR_MEMORY_MOCK_H_

/* Private includes ----------------------------------------------------------*/
#include "em_executor_memory.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
bool __wrap_em_executor_memory_acquire(void **memory, uint32_t required_size);
void __wrap_expect_em_executor_memory_release(void *memory);

void expect_em_executor_memory_acquire(void);
void expect_em_executor_memory_release(void);


#endif /* SRC_MODULES_LIBS_EVENT_MANAGER_MOCKS_EM_EXECUTOR_MEMORY_MOCK_H_ */
