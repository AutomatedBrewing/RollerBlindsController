#ifndef PWM_H
#define PWM_H

/* Private includes ----------------------------------------------------------*/
#include <stdint.h>
#include <stdbool.h>

#include "gpio_pins.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/

typedef void *pwm_handle_t;

/* Public function prototypes ------------------------------------------------*/
pwm_handle_t pwm_init(enum board_input_pin_id pin_id,
                      uint32_t frequency_hz);

bool pwm_start(pwm_handle_t handle);
bool pwm_stop(pwm_handle_t handle);

bool pwm_set_frequency(pwm_handle_t handle,
                       uint32_t frequency_hz);

#endif /* PWM_H */