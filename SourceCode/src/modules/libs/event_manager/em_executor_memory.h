#ifndef EM_EXECUTOR_MEMORY_H
#define EM_EXECUTOR_MEMORY_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "cmsis_os.h"

bool em_executor_memory_acquire(void **memory, uint32_t required_size);

void em_executor_memory_release(void *memory);

#endif /* EM_EXECUTOR_MEMORY_H */