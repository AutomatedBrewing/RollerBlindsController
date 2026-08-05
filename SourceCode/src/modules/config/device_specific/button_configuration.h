/*
 * utils.h
 *
 *  Created on: 12 Mar 2023
 *      Author: dev
 */

#ifndef BUTTON_CONFIGURATION_H_
#define BUTTON_CONFIGURATION_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"

/* Public define -------------------------------------------------------------*/
#define NO_OF_SUPPORTED_BUTTONS (4)

/* Public typedef ------------------------------------------------------------*/
struct button_timings
{
    uint32_t debounce_time;
    uint32_t long_press_time;
    uint32_t very_long_press_time;
};

struct events
{
    void *event_pressed;
    void *event_released;
};

struct button_configuration
{
    const enum board_input_pin_id  pin_id;
    const struct button_timings timings;
    const struct events events;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

#endif /* BUTTON_CONFIGURATION_H_ */
