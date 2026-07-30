/*
 * display.h
 *
 *  Created on: 23 Mar 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_INCLUDE_DISPLAY_H_
#define SRC_PLATFORM_DRIVERS_INCLUDE_DISPLAY_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"
#include <stdbool.h>
#include <stdint.h>

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct lcd_pins
{
    const struct gpio_pin *D7;
    const struct gpio_pin *D6;
    const struct gpio_pin *D5;
    const struct gpio_pin *D4;
    const struct gpio_pin *RS;
    const struct gpio_pin *RW;
    const struct gpio_pin *E;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_PLATFORM_DRIVERS_INCLUDE_DISPLAY_H_ */
