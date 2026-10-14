/*
 * pwm_stm32c0.c
 *
 * PWM driver for STM32C011F4P6.
 * Supported output: PC15 / TIM3_CH3 / AF3.
 */

#include "pwm.h"

#include <stddef.h>
#include <stdint.h>

pwm_handle_t pwm_init(enum board_input_pin_id pin_id, uint32_t frequency_hz)
{
    (void)(pin_id);
    (void)(frequency_hz);
    return NULL;
}

bool pwm_start(pwm_handle_t handle)
{
    (void)(handle);
    return true;
}

bool pwm_stop(pwm_handle_t handle)
{
    (void)(handle);
    return true;
}

bool pwm_set_frequency(pwm_handle_t handle, uint32_t frequency_hz)
{
    (void)(handle);
    (void)(frequency_hz);
    return true;
}