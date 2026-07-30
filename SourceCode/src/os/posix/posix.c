/*
 * posix.c
 *
 *  Created on: 3 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
osStatus_t osKernelInitialize (void)
{
    return (osOK);
}

osStatus_t osKernelGetInfo (osVersion_t * version, char * id_buf,
        uint32_t id_size)
{
    (void)(version);
    (void)(id_buf);
    (void)(id_size);
    return (osOK);
}

osKernelState_t osKernelGetState (void)
{

    return (osKernelReady);
}

osStatus_t osKernelStart (void)
{
    return (osOK);
}

int32_t osKernelLock (void)
{
    return 0;
}

int32_t osKernelUnlock (void)
{
    return 0;
}

int32_t osKernelRestoreLock (int32_t lock)
{
    (void)(lock);
    return 0;
}

uint32_t osKernelGetTickCount (void)
{
    return 0;
}

uint32_t osKernelGetTickFreq (void)
{
    return 0;
}

uint32_t osKernelGetSysTimerCount (void)
{
    return 0;
}

osThreadId_t osThreadNew (osThreadFunc_t func, void * argument,
        const osThreadAttr_t * attr)
{
    (void)(func);
    (void)(argument);
    (void)(attr);
    return NULL;
}

osStatus_t osDelay (uint32_t ticks)
{
    (void) (ticks);
    return (osOK);
}


osMessageQueueId_t osMessageQueueNew(uint32_t msg_count, uint32_t msg_size, const osMessageQueueAttr_t *attr)
{
    (void) (msg_count);
    (void) (msg_size);
    (void) (attr);
    return (NULL);
}



osStatus_t osMessageQueueGet(osMessageQueueId_t mq_id, void *msg_ptr, uint8_t *msg_prio, uint32_t timeout)
{
    (void) (mq_id);
    (void) (msg_ptr);
    (void) (msg_prio);
    (void) (timeout);
    return (osOK);
}


osStatus_t osMessageQueuePut (osMessageQueueId_t mq_id, const void *msg_ptr, uint8_t msg_prio, uint32_t timeout) {
    (void) (mq_id);
    (void) (msg_ptr);
    (void) (msg_prio);
    (void) (timeout);
    return (osOK);
}


osTimerId_t osTimerNew (osTimerFunc_t func, osTimerType_t type, void *argument, const osTimerAttr_t *attr)
{
    (void) (func);
    (void) (type);
    (void) (argument);
    (void) (attr);
    return (NULL);
}


osStatus_t osTimerStart (osTimerId_t timer_id, uint32_t ticks)
{
    (void) (timer_id);
    (void) (ticks);
    return (osOK);
}


osStatus_t osTimerStop (osTimerId_t timer_id)
{
    (void) (timer_id);
    return (osOK);
}


uint32_t osTimerIsRunning (osTimerId_t timer_id)
{
    (void) (timer_id);
    return (0);
}

