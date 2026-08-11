/*
 * utils.h
 *
 *  Created on: 12 Mar 2023
 *      Author: dev
 */

#ifndef MOTOR_CONFIGURATION_H_
#define MOTOR_CONFIGURATION_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/

struct motor_configuration
{
    const enum board_input_pin_id motor_up_pin_id;
    const enum board_input_pin_id motor_down_pin_id;
    uint32_t timeout;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

#endif /* MOTOR_CONFIGURATION_H_ */
