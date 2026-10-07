#include "em_executor_memory.h"

#include "em_executor_config.h"

#include <stddef.h>
#include <stdint.h>

#ifndef DYNAMIC_ALLOCATION_ENABLED

/*
 * One memory block per executor.
 *
 * Each block can contain EM_EXECUTOR_QUEUE_SIZE events.
 */
static uint8_t executor_memory_pool[EM_EXECUTOR_MAX_COUNT][EVENT_SIZE * EM_EXECUTOR_QUEUE_SIZE];

/*
 * Indicates which memory blocks are currently in use.
 */
static bool executor_memory_used[EM_EXECUTOR_MAX_COUNT];

#endif /* DYNAMIC_ALLOCATION_ENABLED */

bool em_executor_memory_acquire(void **memory, uint32_t required_size)
{
    if (memory == NULL)
    {
        return false;
    }

#ifdef DYNAMIC_ALLOCATION_ENABLED

    /*
     * In the dynamically allocated configuration the CMSIS
     * implementation is responsible for allocating queue memory.
     *
     * We therefore don't provide memory here.
     */
    (void)required_size;

    *memory = NULL;

    return true;

#else

    /*
     * Every executor gets exactly one fixed-size block.
     */
    if (required_size > (EVENT_SIZE * EM_EXECUTOR_QUEUE_SIZE))
    {
        return false;
    }

    for (uint32_t i = 0U; i < EM_EXECUTOR_MAX_COUNT; ++i)
    {
        if (!executor_memory_used[i])
        {
            executor_memory_used[i] = true;
            *memory = executor_memory_pool[i];

            return true;
        }
    }

    return false;

#endif
}

void em_executor_memory_release(void *memory)
{
#ifdef DYNAMIC_ALLOCATION_ENABLED

    /*
     * Nothing to release here. The CMSIS/RTOS layer owns the memory.
     */
    (void)memory;

#else

    if (memory == NULL)
    {
        return;
    }

    for (uint32_t i = 0U; i < EM_EXECUTOR_MAX_COUNT; ++i)
    {
        if (memory == executor_memory_pool[i])
        {
            executor_memory_used[i] = false;
            return;
        }
    }

#endif
}