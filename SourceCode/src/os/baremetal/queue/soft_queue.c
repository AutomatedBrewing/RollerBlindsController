#include "soft_queue.h"

#include <string.h>

bool soft_queue_init(soft_queue_t *queue,
                     void *buffer,
                     uint32_t capacity,
                     uint32_t item_size)
{
    if ((queue == NULL) ||
        (buffer == NULL) ||
        (capacity == 0U) ||
        (item_size == 0U))
    {
        return false;
    }

    queue->buffer = (uint8_t *)buffer;
    queue->capacity = capacity;
    queue->item_size = item_size;

    queue->head = 0U;
    queue->tail = 0U;
    queue->count = 0U;

    return true;
}

bool soft_queue_put(soft_queue_t *queue, const void *item)
{
    uint8_t *destination;

    if ((queue == NULL) || (item == NULL))
    {
        return false;
    }

    if (queue->count >= queue->capacity)
    {
        return false;
    }

    destination = &queue->buffer[queue->head * queue->item_size];

    memcpy(destination, item, queue->item_size);

    ++queue->head;

    if (queue->head >= queue->capacity)
    {
        queue->head = 0U;
    }

    ++queue->count;

    return true;
}

bool soft_queue_get(soft_queue_t *queue, void *item)
{
    uint8_t *source;

    if ((queue == NULL) || (item == NULL))
    {
        return false;
    }

    if (queue->count == 0U)
    {
        return false;
    }

    source = &queue->buffer[queue->tail * queue->item_size];

    memcpy(item, source, queue->item_size);

    ++queue->tail;

    if (queue->tail >= queue->capacity)
    {
        queue->tail = 0U;
    }

    --queue->count;

    return true;
}

uint32_t soft_queue_count(const soft_queue_t *queue)
{
    if (queue == NULL)
    {
        return 0U;
    }

    return queue->count;
}

bool soft_queue_is_full(const soft_queue_t *queue)
{
    if (queue == NULL)
    {
        return false;
    }

    return queue->count >= queue->capacity;
}

bool soft_queue_is_empty(const soft_queue_t *queue)
{
    if (queue == NULL)
    {
        return true;
    }

    return queue->count == 0U;
}