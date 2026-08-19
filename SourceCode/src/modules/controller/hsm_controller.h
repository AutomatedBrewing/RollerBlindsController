/*
 * hsm_blink.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_CONTROLLER_HSM_CONTROLLER_H_
#define SRC_MODULES_CONTROLLER_HSM_CONTROLLER_H_

/* Private includes ----------------------------------------------------------*/
#include "hsm.h"
#include "em_timer.h"
#include "utils.h"
#include "gpio_pins.h"
#include "nvm.h"
#include "nvm_configuration.h"

/* Public define -------------------------------------------------------------*/
#define BUTTONS_COUNT (4)

#define LOCAL_UP_BIT_POS (BIT(0))
#define LOCAL_DOWN_BIT_POS (BIT(1))
#define REMOTE_UP_BIT_POS (BIT(2))
#define REMOTE_DOWN_BIT_POS (BIT(3))

#define ALL_BUTTONS ( LOCAL_UP_BIT_POS | LOCAL_DOWN_BIT_POS | REMOTE_UP_BIT_POS | REMOTE_DOWN_BIT_POS)

#define ANY_BITS_SET(value, mask) \
    (((value) & (mask)) != 0U)

#define ALL_BITS_CLEAR(value, mask) \
    (((value) & (mask)) == 0U)

#define LOCAL_BITS_SET(value) \
    (((value) & (LOCAL_UP_BIT_POS | LOCAL_DOWN_BIT_POS)) == \
     (LOCAL_UP_BIT_POS | LOCAL_DOWN_BIT_POS))

#define MORE_THAN_ONE_BIT_SET(value) \
    ((value) != 0U && ((value) & ((value) - 1U)) != 0U)

DECLARE_EVENT(CONTROLLER_TIMER_EVENT)
#define CONTROLLER_TIMER_EVENT_ID ID_OF(CONTROLLER_TIMER_EVENT)
/* Public typedef ------------------------------------------------------------*/

enum signal_source
{
    LOCAL,
    REMOTE,
};

enum direction
{
    UP,
    DOWN,
    INVALID
};

struct buttons_events
{
    uint32_t short_pressed;
    uint32_t long_pressed;
    uint32_t very_long_pressed;
};

struct hsm_controller_context
{
    state_machine_t machine;
    struct em_timer timer;
    struct travel_time movement_config;
    struct buttons_events buttons;
    enum board_input_pin_id currently_operating_button;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber controller_subscriber;

/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_MODULES_CONTROLLER_HSM_CONTROLLER_H_ */
