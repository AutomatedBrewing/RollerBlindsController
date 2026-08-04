/*
 * hsm_blink.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_BUTTON_HSM_BLINK_H_
#define SRC_MODULES_BUTTON_HSM_BLINK_H_

/* Private includes ----------------------------------------------------------*/
#include "em_timer.h"
#include "hsm.h"

/* Public define -------------------------------------------------------------*/
#define NO_OF_SUPPORTED_BUTTONS (4)

DECLARE_EVENT(TIMER_DEBOUNCE_EVENT)
#define TIMER_DEBOUNCE_EVENT_EVENT_ID ID_OF(TIMER_DEBOUNCE_EVENT)

/* Public typedef ------------------------------------------------------------*/
enum button_press_state
{
    BUTTON_RELEASED,
    BUTTON_SHORT_PRESSED,
    BUTTON_LONG_PRESSED,
    BUTTON_VERY_LONG_PRESSED,
};

struct button_timings
{
    uint32_t debounce_time;
    uint32_t long_press_time;
    uint32_t very_long_press_time;
};

struct hsm_button_context
{
    struct em_timer timer;
    state_machine_t machine;
    struct button_timings timings;
    const struct gpio_pin *button_info;
    void *button_handle;
    void *event_pressed;
    void *event_released;
    enum button_press_state state;
    bool is_used;
};
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber button_subscriber;
// extern struct blink_context blink_context;
/* Public function prototypes ------------------------------------------------*/
void button_input_wait_for_event(struct hsm_button_context *button_entry, bool wait_for_activity);

#endif /* SRC_MODULES_BUTTON_HSM_BLINK_H_ */
