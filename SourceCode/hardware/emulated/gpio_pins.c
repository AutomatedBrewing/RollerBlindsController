/*
 * gpio_pins.c
 *
 *  Created on: 9 Mar 2023
 *      Author: dev
 */
#include "gpio_pins.h"

#define B1_Pin       0
#define B1_GPIO_Port 0
#define LED_PIN      1
#define LED_PORT     0

const struct gpio_pin gpio_pins[] = {
    { LED_PIN_ID, LED_PIN, LED_PORT, ACTIVE_LOW, PIN_NO_PULL, PIN_MODE_OUTPUT_PUSH_PULL, PIN_SPEED_LOW, BOTH_EDGES_INTERRUPTS },
};

