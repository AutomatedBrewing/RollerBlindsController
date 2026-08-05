/*
 * gpio_pins_mock.h
 *
 *  Created on: 23 Aug 2023
 *      Author: dev
 */

#ifndef SCONFIGURATION_MOCK_H_
#define SCONFIGURATION_MOCK_H_

/* Private includes ----------------------------------------------------------*/
#include "configuration.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
const struct device_configuration * __wrap_get_list_of_devices_by_type(enum device_type type, uint8_t * devices_count);

void expect_get_list_of_devices_by_type(enum device_type expected_type, const struct device_configuration * returned_list, uint8_t returned_list_size);

#endif /* SCONFIGURATION_MOCK_H_ */
