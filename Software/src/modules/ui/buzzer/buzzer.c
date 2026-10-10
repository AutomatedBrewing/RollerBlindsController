/*
 * motor.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "buzzer.h"
#include <stddef.h>


/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/


bool buzzer_init(struct buzzer *buzzer,
                 const struct buzzer_config *config)
{
    if (buzzer == NULL || config == NULL) {
        return false;
    }

    if (config->frequency_hz == 0U) {
        return false;
    }

    buzzer->pin_id = config->pin_id;
    buzzer->frequency_hz = config->frequency_hz;
    buzzer->is_on = false;
    buzzer->pwm_handle = NULL;

    buzzer->pwm_handle = pwm_init(config->pin_id,
                                  config->frequency_hz);

    if (buzzer->pwm_handle == NULL) {
        return false;
    }

    return true;
}


bool buzzer_on(struct buzzer *buzzer)
{
    if (buzzer == NULL || buzzer->pwm_handle == NULL) {
        return false;
    }

    if (buzzer->is_on) {
        return true;
    }

    if (!pwm_start(buzzer->pwm_handle)) {
        return false;
    }

    buzzer->is_on = true;

    return true;
}


bool buzzer_off(struct buzzer *buzzer)
{
    if (buzzer == NULL || buzzer->pwm_handle == NULL) {
        return false;
    }

    if (!buzzer->is_on) {
        return true;
    }

    if (!pwm_stop(buzzer->pwm_handle)) {
        return false;
    }

    buzzer->is_on = false;

    return true;
}