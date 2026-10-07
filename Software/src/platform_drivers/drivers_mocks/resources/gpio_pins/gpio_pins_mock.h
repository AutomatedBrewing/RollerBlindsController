/*
 * gpio_pins_mock.h
 *
 *  Created on: 23 Aug 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_DRIVERS_MOCKS_GPIO_PINS_GPIO_PINS_MOCK_H_
#define SRC_PLATFORM_DRIVERS_DRIVERS_MOCKS_GPIO_PINS_GPIO_PINS_MOCK_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
const struct gpio_pin *__wrap_find_gpio_pin_context(enum board_input_pin_id pin_id);

void expect_find_gpio_pin_context(enum board_input_pin_id expected_pin_id, void *expected_gpio_pin);

#endif /* SRC_PLATFORM_DRIVERS_DRIVERS_MOCKS_GPIO_PINS_GPIO_PINS_MOCK_H_ */
