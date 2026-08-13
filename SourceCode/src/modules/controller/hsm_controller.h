/*
 * hsm_blink.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_CONTROLLER_HSM_CONTROLLER_H_
#define SRC_MODULES_CONTROLLER_HSM_CONTROLLER_H_

/* Private includes ----------------------------------------------------------*/
#include "hsm.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/

struct hsm_controller_context
{
    state_machine_t machine;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber controller_subscriber;

/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_MODULES_CONTROLLER_HSM_CONTROLLER_H_ */
