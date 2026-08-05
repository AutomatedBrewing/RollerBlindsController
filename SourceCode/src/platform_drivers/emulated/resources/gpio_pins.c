/*
 * gpio_pins.c
 *
 *  Created on: 23 Aug 2023
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"
#include <stddef.h>
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static const uint8_t gpio_pins_size = sizeof(gpio_pins) / sizeof(gpio_pins[0]);
const struct gpio_pin *find_gpio_pin_context(enum board_input_pin_id pin_id)
{
    for (uint8_t id = 0; id < gpio_pins_size; id++)
    {
        if (gpio_pins[id].pin_id == pin_id)
        {
            return &gpio_pins[id];
        }
    }
    return NULL;
}
