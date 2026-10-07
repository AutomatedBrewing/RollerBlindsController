/*
 * hsm_button_states.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_UI_HSM_UI_STATES_H_
#define SRC_MODULES_UI_HSM_UI_STATES_H_

#include "hsm.h"

extern const state_t hsm_ui_root[];
extern const state_t hsm_ui_idle[];
extern const state_t hsm_ui_notifying[];
extern const state_t hsm_ui_active[];
extern const state_t hsm_ui_inactive[];

#endif /* SRC_MODULES_UI_HSM_UI_STATES_H_ */
