/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * @file    gpio.c
 * @brief   This file provides code for the configuration
 *          of all used GPIO pins.
 ******************************************************************************
 * @attention
 *
 * Copyright (c) 2022 STMicroelectronics.
 * All rights reserved.
 *
 * This software is licensed under terms that can be found in the LICENSE file
 * in the root directory of this software component.
 * If no LICENSE file comes with this software, it is provided AS-IS.
 *
 ******************************************************************************
 */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "gpio.h"

#include <stddef.h>

#include "gpio_pins.h"

/*----------------------------------------------------------------------------*/
/* Configure GPIO                                                             */
/*----------------------------------------------------------------------------*/
enum gpio_pin_status gpio_pin_init(const void *pin_info, void **pin_handle)
{
    (void)(pin_info);
    (void)(pin_handle);
    return GPIO_OK;
}

void gpio_configure_pullup_down(void *pin_handle, enum gpio_pin_pull pull)
{
    (void)(pin_handle);
    (void)(pull);
}

void gpio_output_toggle(void *pin_handle)
{
    (void)(pin_handle);
}

void gpio_output_set(void *pin_handle)
{
    (void)(pin_handle);
}

void gpio_output_clear(void *pin_handle)
{
    (void)(pin_handle);
}

void gpio_input_configure(void *pin_handle, struct input_pin_config *input_config, bool int_enabled)
{
    (void)(pin_handle);
    (void)(input_config);
    (void)(int_enabled);
}

void gpio_input_interrupt_enable(void *pin_handle)
{
    (void)(pin_handle);
}

void gpio_input_interrupt_disable(void *pin_handle)
{
    (void)(pin_handle);
}

bool gpio_input_is_active(void *pin_handle)
{
    (void)(pin_handle);
    return false;
}
