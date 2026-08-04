/*
 * scheduler_context.h
 *
 *  Created on: 8 May 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_SCHEDULER_SCHEDULER_CONTEXT_H_
#define SRC_MODULES_SCHEDULER_SCHEDULER_CONTEXT_H_

#include <stdbool.h>

#define VALVES_COUNT (4)
#define DAYS_IN_WEEK (7)

/* Public typedef ------------------------------------------------------------*/
struct irrigation_day
{
    uint8_t valves[VALVES_COUNT];
};

struct irrigation_week
{
    struct irrigation_day week[DAYS_IN_WEEK];
};

#endif /* SRC_MODULES_SCHEDULER_SCHEDULER_CONTEXT_H_ */
