/*
 * gpio_pins.h
 *
 *  Created on: 29 Sep 2022
 *      Author: Kamil Lazowski
 */

#ifndef HARDWARE_GPIO_PINS_H_
#define HARDWARE_GPIO_PINS_H_

/* Private includes ----------------------------------------------------------*/
#include <stdint.h>

/* Public define -------------------------------------------------------------*/
#define HIGH_TO_LOW_INTERRUPT (0x01UL)
#define LOW_TO_HIGH_INTERRUPT (0x02UL)
#define BOTH_EDGES_INTERRUPTS (HIGH_TO_LOW_INTERRUPT | LOW_TO_HIGH_INTERRUPT)

enum board_input_pin_id {
    BUTTON_LOCAL_UP_PIN_ID,
    BUTTON_LOCAL_DOWN_PIN_ID,
    BUTTON_REMOTE_UP_PIN_ID,
    BUTTON_REMOTE_DOWN_PIN_ID,
    MOTOR_UP_PIN_ID,
    MOTOR_DOWN_PIN_ID,
    BUZZER_PIN_ID,
    INVALID_PIN_ID=0xFFFF,
};

enum board_input_polarity {
    ACTIVE_LOW,
    ACTIVE_HIGH
};

enum board_input_pin_pull {
    PIN_PULLUP,
    PIN_PULLDOWN,
    PIN_NO_PULL
};

enum board_pin_mode {
    PIN_MODE_INPUT,
    PIN_MODE_OUTPUT_OPEN_DRAIN,
    PIN_MODE_OUTPUT_PUSH_PULL,
    PIN_MODE_ANALOG,
    PIN_MODE_ALTERNATE, /* State specific to hardware. */
};


enum board_input_pin_speed {
    PIN_SPEED_LOW,
    PIN_SPEED_MEDIUM,
    PIN_SPEED_HIGH
};

struct gpio_pin {
    enum board_input_pin_id pin_id;
    uint32_t pin;
    uint32_t port;
    enum board_input_polarity polarity;
    enum board_input_pin_pull pull;
    enum board_pin_mode mode;
    enum board_input_pin_speed speed;
    uint32_t alternate_function;
    uint8_t interrupt_capacities;
};
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
extern const struct gpio_pin gpio_pins[];
const struct gpio_pin * find_gpio_pin_context(enum board_input_pin_id pin_id);

#endif /* HARDWARE_GPIO_PINS_H_ */
