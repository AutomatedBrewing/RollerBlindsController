/*
 * valves.h
 *
 *  Created on: 14 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_IRRIGATION_VALVES_VALVES_H_
#define SRC_MODULES_IRRIGATION_VALVES_VALVES_H_

#include "gpio_pins.h"
#include <stdbool.h>

enum valve_status
{
    VALVE_OK,
    VALVE_PIN_NOT_FOUND,
    VALVE_INVALID_CONFIGURATION,
    VALVE_NO_MEMORY,
};

void valve_initialize(const void *valve_info, void **valve_handle);
void valve_open(void *valve_handle);
void valve_close(void *valve_handle);
bool valve_is_open(void *valve_handle);

#endif /* SRC_MODULES_IRRIGATION_VALVES_VALVES_H_ */
