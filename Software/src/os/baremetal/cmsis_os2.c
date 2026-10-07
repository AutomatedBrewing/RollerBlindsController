#include "cmsis_os.h"

#include "soft_timer.h"
#include "soft_queue.h"

#include "stm32c0xx_ll_utils.h"

#include <stdint.h>
#include <string.h>
#include <stddef.h>

/* -------------------------------------------------------------------------- */
/* Configuration                                                              */
/* -------------------------------------------------------------------------- */

#ifndef CMSIS_OS_MAX_THREADS
#define CMSIS_OS_MAX_THREADS 1U
#endif

#ifndef CMSIS_OS_TICK_FREQ
#define CMSIS_OS_TICK_FREQ 1000U
#endif

/* -------------------------------------------------------------------------- */
/* Types                                                                      */
/* -------------------------------------------------------------------------- */

typedef struct
{
    bool allocated;
    osThreadFunc_t function;
    void *argument;
} cmsis_thread_t;

typedef struct
{
    bool allocated;
    soft_queue_t queue;
} cmsis_message_queue_t;

/* -------------------------------------------------------------------------- */
/* Static storage                                                             */
/* -------------------------------------------------------------------------- */

static cmsis_thread_t threads[CMSIS_OS_MAX_THREADS];

static cmsis_message_queue_t message_queues[
    CMSIS_OS_MAX_THREADS
];
static volatile uint32_t kernel_tick;

/* -------------------------------------------------------------------------- */
/* Private functions                                                          */
/* -------------------------------------------------------------------------- */

// static bool is_valid_thread(osThreadId_t thread_id)
// {
//     return thread_id != NULL;
// }

static bool is_valid_message_queue(osMessageQueueId_t mq_id)
{
    return mq_id != NULL;
}

/* -------------------------------------------------------------------------- */
/* Kernel                                                                     */
/* -------------------------------------------------------------------------- */

osStatus_t osKernelInitialize(void)
{
    memset(threads, 0, sizeof(threads));
    memset(message_queues, 0, sizeof(message_queues));

    kernel_tick = 0U;
    soft_timer_init();

    return osOK;
}

osStatus_t osKernelGetInfo(osVersion_t *version,
                           char *id_buf,
                           uint32_t id_size)
{
    if (version != NULL)
    {
        version->api = 0U;
        version->kernel = 0U;
    }

    if ((id_buf != NULL) && (id_size > 0U))
    {
        const char id[] = "bare-metal";

        strncpy(id_buf, id, id_size - 1U);
        id_buf[id_size - 1U] = '\0';
    }

    return osOK;
}

osKernelState_t osKernelGetState(void)
{
    return osKernelReady;
}

osStatus_t osKernelStart(void)
{
     __enable_irq();
     
    while (1)
    {
        soft_timer_handler();

        for (uint32_t i = 0U; i < CMSIS_OS_MAX_THREADS; ++i)
        {
            if (threads[i].allocated &&
                (threads[i].function != NULL))
            {
                threads[i].function(threads[i].argument);
            }
        }
    }
}

int32_t osKernelLock(void)
{
    uint32_t primask;

    primask = __get_PRIMASK();

    __disable_irq();

    return (int32_t)primask;
}

int32_t osKernelUnlock(void)
{
    uint32_t primask;

    primask = __get_PRIMASK();

    __enable_irq();

    return (int32_t)primask;
}

int32_t osKernelRestoreLock(int32_t lock)
{
    if ((lock & 1) != 0)
    {
        __disable_irq();
    }
    else
    {
        __enable_irq();
    }

    return lock;
}

void osKernelTick(void)
{
    ++kernel_tick;
    soft_timer_tick();
}

uint32_t osKernelGetTickCount(void)
{
    return kernel_tick;
}

uint32_t osKernelGetTickFreq(void)
{
    return CMSIS_OS_TICK_FREQ;
}

uint32_t osKernelGetSysTimerCount(void)
{
    return osKernelGetTickCount();
}

/* -------------------------------------------------------------------------- */
/* Threads                                                                    */
/* -------------------------------------------------------------------------- */

osThreadId_t osThreadNew(osThreadFunc_t func,
                         void *argument,
                         const osThreadAttr_t *attr)
{
    (void)attr;

    if (func == NULL)
    {
        return NULL;
    }

    for (uint32_t i = 0U; i < CMSIS_OS_MAX_THREADS; ++i)
    {
        if (!threads[i].allocated)
        {
            threads[i].allocated = true;
            threads[i].function = func;
            threads[i].argument = argument;

            return (osThreadId_t)&threads[i];
        }
    }

    return NULL;
}

osStatus_t osThreadTerminate (osThreadId_t thread_id)
{
    (void)(thread_id);
    return osOK;
}

/* -------------------------------------------------------------------------- */
/* Delay                                                                      */
/* -------------------------------------------------------------------------- */

osStatus_t osDelay(uint32_t ticks)
{
    /*
     * This bare-metal port does not have a task scheduler capable of
     * suspending and resuming individual thread contexts.
     *
     * Therefore osDelay() is implemented as a blocking delay.
     *
     * It should not be used from application threads because it blocks
     * the entire cooperative scheduler.
     */
    LL_mDelay(ticks);

    return osOK;
}

/* -------------------------------------------------------------------------- */
/* Message queues                                                             */
/* -------------------------------------------------------------------------- */

osMessageQueueId_t osMessageQueueNew(uint32_t msg_count,
                                     uint32_t msg_size,
                                     const osMessageQueueAttr_t *attr)
{
    void *memory = NULL;

    if ((msg_count == 0U) || (msg_size == 0U))
    {
        return NULL;
    }

    /*
     * This port intentionally does not allocate memory dynamically.
     * Queue storage must therefore be supplied by the application.
     */
    if ((attr == NULL) || (attr->mq_mem == NULL))
    {
        return NULL;
    }

    if (attr->mq_size < (msg_count * msg_size))
    {
        return NULL;
    }

    memory = attr->mq_mem;

    for (uint32_t i = 0U; i < CMSIS_OS_MAX_THREADS; ++i)
    {
        if (!message_queues[i].allocated)
        {
            if (!soft_queue_init(&message_queues[i].queue,
                                 memory,
                                 msg_count,
                                 msg_size))
            {
                return NULL;
            }

            message_queues[i].allocated = true;

            return (osMessageQueueId_t)&message_queues[i];
        }
    }

    return NULL;
}

osStatus_t osMessageQueueGet(osMessageQueueId_t mq_id,
                             void *msg_ptr,
                             uint8_t *msg_prio,
                             uint32_t timeout)
{
    cmsis_message_queue_t *queue;

    (void)msg_prio;
    (void)timeout;

    if (!is_valid_message_queue(mq_id) ||
        (msg_ptr == NULL))
    {
        return osErrorParameter;
    }

    queue = (cmsis_message_queue_t *)mq_id;

    if (!queue->allocated)
    {
        return osErrorParameter;
    }

    if (!soft_queue_get(&queue->queue, msg_ptr))
    {
        return osErrorResource;
    }

    return osOK;
}

osStatus_t osMessageQueuePut(osMessageQueueId_t mq_id,
                             const void *msg_ptr,
                             uint8_t msg_prio,
                             uint32_t timeout)
{
    cmsis_message_queue_t *queue;

    (void)msg_prio;
    (void)timeout;

    if (!is_valid_message_queue(mq_id) ||
        (msg_ptr == NULL))
    {
        return osErrorParameter;
    }

    queue = (cmsis_message_queue_t *)mq_id;

    if (!queue->allocated)
    {
        return osErrorParameter;
    }

    if (!soft_queue_put(&queue->queue, msg_ptr))
    {
        return osErrorResource;
    }

    return osOK;
}

/* -------------------------------------------------------------------------- */
/* Timers                                                                     */
/* -------------------------------------------------------------------------- */

osTimerId_t osTimerNew(osTimerFunc_t func,
                       osTimerType_t type,
                       void *argument,
                       const osTimerAttr_t *attr)
{
    (void)attr;

    if (func == NULL)
    {
        return NULL;
    }

    if ((type != osTimerOnce) &&
        (type != osTimerPeriodic))
    {
        return NULL;
    }

    return (osTimerId_t)soft_timer_create(
        (soft_timer_callback_t)func,
        type == osTimerPeriodic,
        argument
    );
}

osStatus_t osTimerStart(osTimerId_t timer_id,
                        uint32_t ticks)
{
    if (timer_id == NULL)
    {
        return osErrorParameter;
    }

    if (!soft_timer_start((soft_timer_t *)timer_id, ticks))
    {
        return osErrorParameter;
    }

    return osOK;
}

osStatus_t osTimerStop(osTimerId_t timer_id)
{
    if (timer_id == NULL)
    {
        return osErrorParameter;
    }

    if (!soft_timer_stop((soft_timer_t *)timer_id))
    {
        return osErrorParameter;
    }

    return osOK;
}

uint32_t osTimerIsRunning(osTimerId_t timer_id)
{
    if (timer_id == NULL)
    {
        return 0U;
    }

    return soft_timer_is_running(
        (const soft_timer_t *)timer_id
    ) ? 1U : 0U;
}