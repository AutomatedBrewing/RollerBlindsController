/*
 * gpio_mock.h
 *
 *  Created on: 18 Aug 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_EMULATED_MOCKS_GPIO_GPIO_MOCK_H_
#define SRC_PLATFORM_DRIVERS_EMULATED_MOCKS_GPIO_GPIO_MOCK_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
enum gpio_pin_status __wrap_gpio_pin_init(const void *pin_info, void **pin_handle);
void __wrap_gpio_configure_pullup_down(void *pin_handle, enum gpio_pin_pull pull);
void __wrap_gpio_output_configure(void *pin_handle, enum board_pin_mode mode);
void __wrap_gpio_output_toggle(void *pin_handle);
void __wrap_gpio_output_set(void *pin_handle);
void __wrap_gpio_output_clear(void *pin_handle);
void __wrap_gpio_input_configure(void *pin_handle, struct input_pin_config *input_config, bool int_enabled);
void __wrap_gpio_input_interrupt_enable(void *pin_handle);
void __wrap_gpio_input_interrupt_disable(void *pin_handle);
bool __wrap_gpio_input_is_active(void *pin_handle);

void expect_gpio_pin_init(void *expected_pin_info, void *expected_pin_handle, enum gpio_pin_status expected_result);
void expect_gpio_configure_pullup_down(void *expected_pin_handle, enum gpio_pin_pull expected_pull);
void expect_gpio_output_configure(void *expected_pin_handle, enum board_pin_mode expected_mode);
void expect_gpio_output_toggle(void *expected_pin_handle);
void expect_gpio_output_set(void *expected_pin_handle);
void expect_gpio_output_clear(void *expected_pin_handle);
void expect_gpio_input_configure(void *expected_pin_handle, bool expected_int_enabled);
void expect_gpio_input_interrupt_enable(void *expected_pin_handle);
void expect_gpio_input_interrupt_disable(void *expected_pin_handle);
void expect_gpio_input_is_active(void *expected_pin_handle, bool expected_result);

#endif /* SRC_PLATFORM_DRIVERS_EMULATED_MOCKS_GPIO_GPIO_MOCK_H_ */