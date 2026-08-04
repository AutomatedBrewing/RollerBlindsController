/*
 * blink.h
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

#ifndef SRC_SCHEDULER_H_
#define SRC_SCHEDULER_H_

/* Private includes ----------------------------------------------------------*/
#include "scheduler_context.h"
#include <stdbool.h>
/* Public define -------------------------------------------------------------*/

/* Public typedef ------------------------------------------------------------*/
struct scheduler_context
{
    struct irrigation_week plan;
    void *valves_handles[VALVES_COUNT];
};
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber scheduler_subscriber;
extern struct scheduler_context scheduler;
/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_SCHEDULER_H_ */
