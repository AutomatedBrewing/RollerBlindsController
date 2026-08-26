#ifndef SOFT_QUEUE_H
#define SOFT_QUEUE_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

typedef struct
{
    uint8_t *buffer;
    uint32_t capacity;
    uint32_t item_size;

    uint32_t head;
    uint32_t tail;
    uint32_t count;
} soft_queue_t;

/**
 * @brief Initialize a queue.
 *
 * @param queue Queue object.
 * @param buffer Storage buffer.
 * @param capacity Number of elements.
 * @param item_size Size of one element in bytes.
 */
bool soft_queue_init(soft_queue_t *queue,
                     void *buffer,
                     uint32_t capacity,
                     uint32_t item_size);

/**
 * @brief Put an element into the queue.
 *
 * Non-blocking.
 */
bool soft_queue_put(soft_queue_t *queue, const void *item);

/**
 * @brief Get an element from the queue.
 *
 * Non-blocking.
 */
bool soft_queue_get(soft_queue_t *queue, void *item);

/**
 * @brief Return number of elements currently stored.
 */
uint32_t soft_queue_count(const soft_queue_t *queue);

/**
 * @brief Return whether queue is full.
 */
bool soft_queue_is_full(const soft_queue_t *queue);

/**
 * @brief Return whether queue is empty.
 */
bool soft_queue_is_empty(const soft_queue_t *queue);

#endif /* SOFT_QUEUE_H */