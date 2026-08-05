/*
 * utils.h
 *
 *  Created on: 12 Mar 2023
 *      Author: dev
 */

#ifndef BUZZER_CONFIGURATION_H_
#define BUZZER_CONFIGURATION_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct buzzer_timings
{
    uint32_t on_time;
    uint32_t off_time;
    uint32_t repetitions;
};


struct buzzer_configuration
{
    const enum board_input_pin_id  pin_id;
    const struct buzzer_timings timings;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

#endif /* BUZZER_CONFIGURATION_H_ */
