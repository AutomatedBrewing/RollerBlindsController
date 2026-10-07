/*
 * hsm_button_states.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_CONTROLLER_HSM_CONTROLLER_STATES_H_
#define SRC_MODULES_CONTROLLER_HSM_CONTROLLER_STATES_H_

#include "hsm.h"

extern const state_t hsm_controller_root[];
extern const state_t hsm_controller_idle[];
extern const state_t hsm_controller_any_mode_candidate[];
extern const state_t hsm_controller_auto_mode[];
extern const state_t hsm_controller_manual_mode[];
extern const state_t hsm_controller_config_mode[];
extern const state_t hsm_controller_config_mode_time_counting[];

#endif /* SRC_MODULES_CONTROLLER_HSM_CONTROLLER_STATES_H_ */
