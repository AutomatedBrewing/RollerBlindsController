/*
 * hsm_button_states.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_BUTTON_HSM_BUTTON_STATES_H_
#define SRC_MODULES_BUTTON_HSM_BUTTON_STATES_H_

#include "hsm.h"

extern const state_t hsm_button_root[];
extern const state_t hsm_button_released[];
extern const state_t hsm_button_pressed[];
extern const state_t hsm_button_pressed_short[];
extern const state_t hsm_button_pressed_long[];
extern const state_t hsm_button_pressed_very_long[];

#endif /* SRC_MODULES_BUTTON_HSM_BUTTON_STATES_H_ */
