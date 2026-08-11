/*
 * hsm_button_states.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_MOTOR_HSM_MOTOR_STATES_H_
#define SRC_MODULES_MOTOR_HSM_MOTOR_STATES_H_

#include "hsm.h"

extern const state_t hsm_motor_root[];
extern const state_t hsm_motor_moves_up[];
extern const state_t hsm_motor_moves_down[];
extern const state_t hsm_motor_idle[];

#endif /* SRC_MODULES_MOTOR_HSM_MOTOR_STATES_H_ */
