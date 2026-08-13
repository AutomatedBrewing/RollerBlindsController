/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "ui_test_vectors.h"

#include "configuration.h"
#include "ui_configuration.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static const struct buzzer_configuration buzzer_config = {
    .pin_id = BUZZER_PIN_ID,
    .timings =
        {
            .on_time = 100,
            .off_time = 200,
            .repetitions = 1,
        },
};

const struct device_configuration one_buzzer_list[] = {
    {
        .id = DEVICE_BUZZER,
        .type = DEVICE_TYPE_BUZZER,
        .config = &buzzer_config,
    },
};