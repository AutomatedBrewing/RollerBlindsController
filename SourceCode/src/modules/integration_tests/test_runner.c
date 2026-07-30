/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os.h"
#include "unity_fixture.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static void RunAllTests(void)
{
    RUN_TEST_GROUP(test_blink);
}

static void itest_task(void *argument)
{
    (void)(argument);
    UnityMain(0, NULL, RunAllTests);
}

void itest_initialize(void)
{
    osThreadNew(itest_task, NULL, NULL);
}
