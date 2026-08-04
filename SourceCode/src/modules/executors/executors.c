/*
 * executors.c
 *
 *  Created on: 24 Jan 2023
 *      Author: dev
 */

#include "em_event.h"
#include "em_executor.h"

#include "executors.h"
#include "hsm_button.h"

CREATE_EXECUTOR_WITH_SUPPORTED_SUBSCRIBERS(main_executor, ADD_SUBSCRIBER(&button_subscriber))

void create_executors(void)
{
    em_create_executor(&main_executor, NULL, 4);
}
