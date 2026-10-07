/*
 * brewapp_init.c
 *
 *  Created on: 11 Sep 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "app.h"
#include "cmsis_os.h"

#include "clock.h"
#include "gpio.h"
#include "interrupt.h"
#include "log.h"

#include "integration_test.h"

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
    gpio_initialize();
    log_initialize();

    osKernelInitialize();

    itest_initialize();
}

void app_start()
{
    osKernelStart();
}
