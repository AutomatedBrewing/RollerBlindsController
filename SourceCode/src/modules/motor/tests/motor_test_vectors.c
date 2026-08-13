/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "motor_test_vectors.h"

#include "configuration.h"
#include "motor_configuration.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static const struct motor_configuration motor_config = {
    .motor_up_pin_id = MOTOR_UP_PIN_ID,
    .motor_down_pin_id = MOTOR_DOWN_PIN_ID,
    .timeout = 69,
};

const struct device_configuration one_motor_list[] = {
    {
        .id = DEVICE_MOTOR,
        .type = DEVICE_TYPE_MOTOR,
        .config = &motor_config,
    },
};