/*
 * utils.h
 *
 *  Created on: 12 Mar 2023
 *      Author: dev
 */

#ifndef CONFIGURATION_H_
#define CONFIGURATION_H_

/* Private includes ----------------------------------------------------------*/
#include "gpio_pins.h"

/* Includes for devices configurations. */
#include "button_configuration.h"
#include "buzzer_configuration.h"
#include "motor_configuration.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
enum device_id
{
    DEVICE_BUTTON_LOCAL_UP,
    DEVICE_BUTTON_LOCAL_DOWN,
    DEVICE_BUTTON_REMOTE_UP,
    DEVICE_BUTTON_REMOTE_DOWN,
    DEVICE_BUZZER,
    DEVICE_MOTOR_UP,
    DEVICE_MOTOR_DOWN,
    DEVICE_COUNT,
};

enum device_type
{
    DEVICE_TYPE_UNKNOWN,
    DEVICE_TYPE_BUTTON,
    DEVICE_TYPE_BUZZER,
    DEVICE_TYPE_MOTOR,
};

struct device_configuration
{
    enum device_id id;
    enum device_type type;
    const void * config;
};


/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

const struct device_configuration * get_list_of_devices_by_type(enum device_type type, uint8_t * devices_count);

#endif /* CONFIGURATION_H_ */
