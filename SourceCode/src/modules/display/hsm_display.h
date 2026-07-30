/*
 * hsm_display.h
 *
 *  Created on: 31 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_DISPLAY_HSM_DISPLAY_H_
#define SRC_MODULES_DISPLAY_HSM_DISPLAY_H_

/* Private includes ----------------------------------------------------------*/
#include "buf_lcd.h"
#include "em_timer.h"
#include "hsm.h"
#include "rtc.h"
#include "scheduler_context.h"

/* Public define -------------------------------------------------------------*/
DECLARE_EVENT(DISPLAY_REFRESH_EVENT)
#define DISPLAY_REFRESH_EVENT_ID ID_OF(DISPLAY_REFRESH_EVENT)

DECLARE_EVENT(USER_INACTIVITY_EVENT)
#define USER_INACTIVITY_EVENT_ID ID_OF(USER_INACTIVITY_EVENT)

#define NO_OF_SCREENS (7)

/* Public typedef ------------------------------------------------------------*/
struct hsm_display_context
{
    struct em_timer refresh_timer;
    struct em_timer inactivity_timer;
    struct irrigation_week irrigation_plan;
    struct irrigation_week irrigation_plan_cache;
    state_machine_t machine;
    const LCD_screen *screens[NO_OF_SCREENS];
    uint32_t currenct_screen_index;
    TWIN *layer_pointed_by_cursor;
    uint32_t index_of_layer_pointed_by_cursor;
};

struct day_display_context
{
    struct hsm_display_context *p_hsm;
    enum rtc_weekday day;
    uint8_t section;
};
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber display_subscriber;
/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_MODULES_DISPLAY_HSM_DISPLAY_H_ */
