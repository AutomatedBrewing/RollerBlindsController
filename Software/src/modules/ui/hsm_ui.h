/*
 * hsm_blink.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_UI_HSM_UI_H_
#define SRC_MODULES_UI_HSM_UI_H_

/* Private includes ----------------------------------------------------------*/
#include "em_timer.h"
#include "hsm.h"

#include "ui_configuration.h"
/* Public define -------------------------------------------------------------*/
DECLARE_EVENT(UI_TIMER_EVENT)
#define UI_TIMER_EVENT_ID ID_OF(UI_TIMER_EVENT)

/* Public typedef ------------------------------------------------------------*/

struct buzzer
{
    const struct gpio_pin *gpio_info;
    void *gpio_handle;
    uint32_t finished_repetitions;
};

struct hsm_ui_context
{
    state_machine_t machine;
    struct em_timer timer;
    struct buzzer_configuration const *configuration;
    struct buzzer buzzer;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber ui_subscriber;

/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_MODULES_UI_HSM_UI_H_ */
