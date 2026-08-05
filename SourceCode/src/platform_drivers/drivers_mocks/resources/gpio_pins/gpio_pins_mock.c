/*
 * gpio_pins_mock.c
 *
 *  Created on: 23 Aug 2023
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>

#include <cmocka.h>

#include "gpio_pins_mock.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
const struct gpio_pin *__wrap_find_gpio_pin_context(enum board_input_pin_id pin_id)
{
    function_called();
    check_expected(pin_id);
    return mock_type(const struct gpio_pin *);
}

void expect_find_gpio_pin_context(enum board_input_pin_id expected_pin_id, void *expected_gpio_pin)
{
    expect_function_call(__wrap_find_gpio_pin_context);
    expect_value(__wrap_find_gpio_pin_context, pin_id, expected_pin_id);
    will_return(__wrap_find_gpio_pin_context, expected_gpio_pin);
}
