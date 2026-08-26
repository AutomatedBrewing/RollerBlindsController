/*
 * em_timer_mock.c
 *
 *  Created on: 18 Aug 2023
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>

#include <cmocka.h>

#include "em_executor_memory_mock.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

bool __wrap_em_executor_memory_acquire(void **memory, uint32_t required_size)
{
    function_called();
    (void)(memory);
    (void)(required_size);
    return true;
}
void __wrap_em_executor_memory_release(void *memory)
{
    function_called();
    (void)(memory);
}

void expect_em_executor_memory_acquire(void)
{
    expect_function_call(__wrap_em_executor_memory_acquire);
}
void expect_em_executor_memory_release(void)
{
    expect_function_call(__wrap_em_executor_memory_release);
}