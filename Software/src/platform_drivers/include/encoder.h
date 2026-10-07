/*
 * encoder.h
 *
 *  Created on: 22 Mar 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_INCLUDE_ENCODER_H_
#define SRC_PLATFORM_DRIVERS_INCLUDE_ENCODER_H_

/* Private includes ----------------------------------------------------------*/
#include <stdbool.h>
#include <stdint.h>

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
void encoder_init(const void *pin_info_channel_A, const void *pin_info_channel_B, void *event_rotation_left,
                  void *event_rotation_right);

#endif /* SRC_PLATFORM_DRIVERS_INCLUDE_ENCODER_H_ */
