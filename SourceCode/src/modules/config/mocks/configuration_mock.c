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

#include "configuration_mock.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

const struct device_configuration * __wrap_get_list_of_devices_by_type(enum device_type type, uint8_t * devices_count)
{
    function_called();
    check_expected(type);
    *devices_count = mock_type(uint8_t);
    return mock_type(const struct device_configuration *);
}


void expect_get_list_of_devices_by_type(enum device_type expected_type, const struct device_configuration * returned_list, uint8_t returned_list_size)
{
    expect_function_call(__wrap_get_list_of_devices_by_type);
    expect_value(__wrap_get_list_of_devices_by_type, type, expected_type);
    will_return(__wrap_get_list_of_devices_by_type, returned_list_size);
    will_return(__wrap_get_list_of_devices_by_type, returned_list);
}
