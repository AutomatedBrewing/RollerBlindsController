/*
 * hsm_blink.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_BUTTON_HSM_BLINK_H_
#define SRC_MODULES_BUTTON_HSM_BLINK_H_

/* Private includes ----------------------------------------------------------*/
#include "button_configuration.h"
#include "em_timer.h"
#include "hsm.h"

/* Public define -------------------------------------------------------------*/

DECLARE_EVENT(TIMER_DEBOUNCE_EVENT)
#define TIMER_DEBOUNCE_EVENT_EVENT_ID ID_OF(TIMER_DEBOUNCE_EVENT)

DECLARE_EVENT(TIMER_DURATION_EVENT)
#define TIMER_DURATION_EVENT_EVENT_ID ID_OF(TIMER_DURATION_EVENT)

/* Public typedef ------------------------------------------------------------*/

struct hsm_button_context
{
    struct em_timer debounce_timer;
    struct em_timer duration_timer;
    state_machine_t machine;
    struct button_configuration const *configuration;
    const struct gpio_pin *button_info;
    void *button_handle;
    bool is_used;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber button_subscriber;
// extern struct blink_context blink_context;
/* Public function prototypes ------------------------------------------------*/
void button_input_wait_for_event(struct hsm_button_context *button_entry, bool wait_for_activity);

#endif /* SRC_MODULES_BUTTON_HSM_BLINK_H_ */
