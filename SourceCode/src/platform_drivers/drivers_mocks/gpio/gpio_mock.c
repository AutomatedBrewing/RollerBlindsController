/*
 * gpio_mock.c
 *
 *  Created on: 18 Aug 2023
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>
#include <stdint.h>

#include <cmocka.h>

#include "gpio_mock.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
enum gpio_pin_status __wrap_gpio_pin_init(const void *pin_info, void **pin_handle)
{
    function_called();
    check_expected_any(pin_info);
    *pin_handle = mock_type(void *);
    return mock_type(enum gpio_pin_status);
}

void expect_gpio_pin_init(void *expected_pin_info, void *expected_pin_handle, enum gpio_pin_status expected_result)
{
    expect_function_call(__wrap_gpio_pin_init);
    expect_uint_value(__wrap_gpio_pin_init, pin_info, (uintmax_t)expected_pin_info);
    will_return(__wrap_gpio_pin_init, expected_pin_handle);
    will_return(__wrap_gpio_pin_init, expected_result);
}

void __wrap_gpio_configure_pullup_down(void *pin_handle, enum gpio_pin_pull pull)
{
    function_called();
    check_expected_any(pin_handle);
    check_expected_any(pull);
}

void expect_gpio_configure_pullup_down(void *expected_pin_handle, enum gpio_pin_pull expected_pull)
{
    expect_function_call(__wrap_gpio_configure_pullup_down);
    expect_uint_value(__wrap_gpio_configure_pullup_down, pin_handle, (uintmax_t)expected_pin_handle);
    will_return(__wrap_gpio_configure_pullup_down, expected_pull);
}

void __wrap_gpio_output_configure(void *pin_handle, enum board_pin_mode mode)
{
    function_called();
    check_expected_any(pin_handle);
    check_expected_any(mode);
}

void expect_gpio_output_configure(void *expected_pin_handle, enum board_pin_mode expected_mode)
{
    expect_function_call(__wrap_gpio_output_configure);
    expect_uint_value(__wrap_gpio_output_configure, pin_handle, (uintmax_t)expected_pin_handle);
    expect_uint_value(__wrap_gpio_output_configure, mode, expected_mode);
}

void __wrap_gpio_output_toggle(void *pin_handle)
{
    function_called();
    check_expected_any(pin_handle);
}

void expect_gpio_output_toggle(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_output_toggle);
    expect_uint_value(__wrap_gpio_output_toggle, pin_handle, (uintmax_t)expected_pin_handle);
}

void __wrap_gpio_output_set(void *pin_handle)
{
    function_called();
    check_expected_any(pin_handle);
}

void expect_gpio_output_set(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_output_set);
    expect_uint_value(__wrap_gpio_output_set, pin_handle, (uintmax_t)expected_pin_handle);
}

void __wrap_gpio_output_clear(void *pin_handle)
{
    function_called();
    check_expected_any(pin_handle);
}

void expect_gpio_output_clear(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_output_clear);
    expect_uint_value(__wrap_gpio_output_clear, pin_handle, (uintmax_t)expected_pin_handle);
}

void __wrap_gpio_input_configure(void *pin_handle, struct input_pin_config *input_config, bool int_enabled)
{
    function_called();
    check_expected_any(pin_handle);
    (void)(input_config);
    //    check_expected_any(input_config);
    check_expected_any(int_enabled);
}

void expect_gpio_input_configure(void *expected_pin_handle, bool expected_int_enabled)
{
    expect_function_call(__wrap_gpio_input_configure);
    expect_uint_value(__wrap_gpio_input_configure, pin_handle, (uintmax_t)expected_pin_handle);
    //    expect_value(__wrap_gpio_input_configure, input_config, expected_input_config);
    expect_uint_value(__wrap_gpio_input_configure, int_enabled, expected_int_enabled);
}

void __wrap_gpio_input_interrupt_enable(void *pin_handle)
{
    function_called();
    check_expected_any(pin_handle);
}

void expect_gpio_input_interrupt_enable(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_input_interrupt_enable);
    expect_uint_value(__wrap_gpio_input_interrupt_enable, pin_handle, (uintmax_t)expected_pin_handle);
}

void __wrap_gpio_input_interrupt_disable(void *pin_handle)
{
    function_called();
    check_expected_any(pin_handle);
}

void expect_gpio_input_interrupt_disable(void *expected_pin_handle)
{
    expect_function_call(__wrap_gpio_input_interrupt_disable);
    expect_uint_value(__wrap_gpio_input_interrupt_disable, pin_handle, (uintmax_t)expected_pin_handle);
}

bool __wrap_gpio_input_is_active(void *pin_handle)
{
    function_called();
    check_expected_any(pin_handle);
    return mock_type(bool);
}

void expect_gpio_input_is_active(void *expected_pin_handle, bool expected_result)
{
    expect_function_call(__wrap_gpio_input_is_active);
    expect_uint_value(__wrap_gpio_input_is_active, pin_handle, (uintmax_t)expected_pin_handle);
    will_return(__wrap_gpio_input_is_active, expected_result);
}