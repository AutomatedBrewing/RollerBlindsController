/*
 * hsm_blink.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_MOTOR_HSM_MOTOR_H_
#define SRC_MODULES_MOTOR_HSM_MOTOR_H_

/* Private includes ----------------------------------------------------------*/
#include "hsm.h"
#include "em_timer.h"

#include "motor_configuration.h"
/* Public define -------------------------------------------------------------*/
DECLARE_EVENT(SAFETY_TIMER_EVENT)
#define SAFETY_TIMER_EVENT_ID ID_OF(SAFETY_TIMER_EVENT)

/* Public typedef ------------------------------------------------------------*/

struct motor 
{
    const struct gpio_pin *gpio_info;
    void *gpio_handle;
};

struct hsm_motor_context
{
    state_machine_t machine;
    struct em_timer safety_timer;
    struct motor_configuration const *configuration;
    struct motor motor_up;
    struct motor motor_down;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber motor_subscriber;

/* Public function prototypes ------------------------------------------------*/


#endif /* SRC_MODULES_MOTOR_HSM_MOTOR_H_ */
