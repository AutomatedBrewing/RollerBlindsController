#ifndef EM_EXECUTOR_CONFIG_H
#define EM_EXECUTOR_CONFIG_H

#include "CMSIS_config.h"

#define EM_EXECUTOR_RTOS_ENALBED      (0)
#define EM_EXECUTOR_BAREMETAL_ENALBED (1)
#define EVENT_SIZE                    (16U)
#define EM_EXECUTOR_QUEUE_SIZE        (8U)
#define EM_EXECUTOR_MAX_COUNT         (CMSIS_OS_MAX_THREADS)

#endif