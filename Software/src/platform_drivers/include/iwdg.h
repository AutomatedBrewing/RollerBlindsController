#ifndef IWDG_H
#define IWDG_H

#include <stdint.h>

enum iwdg_result
{
    IWDG_OK = 0,
    IWDG_INVALID_ARGUMENT,
    IWDG_TIMEOUT,
    IWDG_ERROR
};

/*
 * Initialize the watchdog with the requested timeout in milliseconds.
 */
enum iwdg_result iwdg_init(uint32_t timeout_ms);

/*
 * Reload the watchdog counter.
 */
void iwdg_refresh(void);

#endif /* IWDG_H */