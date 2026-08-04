/*
 * brewapp_init.c
 *
 *  Created on: 11 Sep 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "app.h"
#include "cmsis_os.h"
#include <stdio.h>

#include "clock.h"
#include "em_executor.h"
#include "interrupt.h"
#include "rtc.h"

#include "executors.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
void app_init()
{
    clock_initialize();
    interrupt_initialize();
    clock_configure();
    rtc_initialize();

    osKernelInitialize();

    create_executors();
}

void app_start()
{
    osKernelStart();
}
