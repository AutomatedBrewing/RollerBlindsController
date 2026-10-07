/*
 * log.c
 *
 *  Created on: 30 Sep 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#if defined(CONFIG_LOG_ENABLED)
#include <stdarg.h>

#include "SEGGER_RTT.h"
#endif

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
void log_initialize(void)
{
#if defined(CONFIG_LOG_ENABLED)
    SEGGER_RTT_ConfigUpBuffer(0, NULL, NULL, 0, SEGGER_RTT_MODE_BLOCK_IF_FIFO_FULL);
#endif
}

void log_string(const char *string)
{
#if defined(CONFIG_LOG_ENABLED)
    SEGGER_RTT_WriteString(0, string);
#else
    (void)(string);
#endif
}

void log_printf(const char *string, ...)
{
#if defined(CONFIG_LOG_ENABLED)
    va_list ParamList;

    va_start(ParamList, string);
    SEGGER_RTT_vprintf(0, string, &ParamList);
    va_end(ParamList);
#else
    (void)(string);
#endif
}

void log_putc(char c)
{
#if defined(CONFIG_LOG_ENABLED)
    SEGGER_RTT_PutChar(0, c);
#else
    (void)(c);
#endif
}
