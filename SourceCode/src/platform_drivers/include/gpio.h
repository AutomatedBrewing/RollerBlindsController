/*
 * gpio.h
 *
 *  Created on: 30 Sep 2022
 *      Author: Kamil Lazowski
 */

#ifndef SRC_PLATFORM_DRIVERS_INCLUDE_GPIO_H_
#define SRC_PLATFORM_DRIVERS_INCLUDE_GPIO_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"
#include <stdbool.h>
#include <stdint.h>

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
enum gpio_pin_status
{
    GPIO_OK,
    GPIO_PIN_NOT_FOUND,
    GPIO_INVALID_CONFIGURATION,
    GPIO_NO_MEMORY,
};

enum gpio_pin_pull
{
    GPIO_PIN_PULLUP,
    GPIO_PIN_PULLDOWN,
    GPIO_PIN_NO_PULL
};

enum interrupt_pin_activity
{
    INTERRUPT_PIN_ACTIVITY_ACTIVE_TO_INACTIVE,
    INTERRUPT_PIN_ACTIVITY_INACTIVE_TO_ACTIVE,
    INTERRUPT_PIN_ACTIVITY_TOGGLE
};

struct input_pin_config
{
    enum interrupt_pin_activity activity;
    void (*callback)(void *);
    void *callback_data;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

/**
 *  Initialize the gpio pin.
 * @param pin_info Pointer to pin info structure.
 * @param pin_handle Handle to the pin.
 *
 * @retval GPIO_OK in case of success, error code otherwise.
 */
enum gpio_pin_status gpio_pin_init(const void *pin_info, void **pin_handle);

/**
 *  Configures pins pullup.
 * @param pin_handle Handle to the pin.
 * @param pull Pull value.
 */
void gpio_configure_pullup_down(void *pin_handle, enum gpio_pin_pull pull);

void gpio_output_configure(void *pin_handle, enum board_pin_mode mode);

/**
 *  Toggles the output pin.
 * @param pin_handle Handle to the pin.
 */
void gpio_output_toggle(void *pin_handle);

/**
 *  Sets the output pin.
 * @param pin_handle Handle to the pin.
 */
void gpio_output_set(void *pin_handle);

/**
 *  Clears the output pin.
 * @param pin_handle Handle to the pin.
 */
void gpio_output_clear(void *pin_handle);

/**
 *  Configures input pin.
 * @param pin_handle Handle to the pin.
 * @param input_config Configuration of interrupt.
 * @param int_enabled True if interrupt has to be enabled immediately. False otherwise.
 */
void gpio_input_configure(void *pin_handle, struct input_pin_config *input_config, bool int_enabled);

/**
 *  Enable pin interrupt
 * @param pin_handle Handle to the pin.
 */
void gpio_input_interrupt_enable(void *pin_handle);

/**
 *  Disable pin interrupt
 * @param pin_handle Handle to the pin.
 */
void gpio_input_interrupt_disable(void *pin_handle);

/*
 *  Enable pin interrupt
 * @param pin_handle Handle to the pin.
 */
bool gpio_input_is_active(void *pin_handle);

#endif /* SRC_PLATFORM_DRIVERS_INCLUDE_GPIO_H_ */
