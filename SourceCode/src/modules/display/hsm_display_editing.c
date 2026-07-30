/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "em_event.h"
#include "em_timer.h"
#include <string.h>

#include "buf_lcd.h"
#include "hsm_display.h"
#include "layers.h"

#include "encoder_rotation_left_event.h"
#include "encoder_rotation_right_event.h"
#include "encoder_switch_pressed_event.h"
#include "set_irrigation_schedule_event.h"

#include "hsm_display_states.h"
#include "utils.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static void restart_inactivity_timer_if_needed(struct hsm_display_context *hsm)
{
    if (em_timer_is_running(&hsm->inactivity_timer))
    {
        em_timer_start(&hsm->inactivity_timer);
    }
}

static void send_changed_irrigation_plan_if_needed(struct hsm_display_context *hsm)
{
    if (memcmp(&hsm->irrigation_plan, &hsm->irrigation_plan_cache, sizeof(hsm->irrigation_plan)))
    {
        memcpy(&hsm->irrigation_plan, &hsm->irrigation_plan_cache, sizeof(hsm->irrigation_plan));
        union set_irrigation_schedule_message message = {0};
        em_set_message_event(&message.event.super, SET_IRRIGATION_SCHEDULE_EVENT_ID);
        memcpy(&message.event.irrigation_plan, &hsm->irrigation_plan, sizeof(hsm->irrigation_plan));
        em_publish_message(&message);
    }
}

static state_machine_result_t handle_encoder_rotated_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    struct day_display_context *context = hsm->layer_pointed_by_cursor->context;
    hsm->irrigation_plan_cache.week[context->day].valves[context->section] =
        !hsm->irrigation_plan.week[context->day].valves[context->section];
    LCD_BUF_refresh();
    restart_inactivity_timer_if_needed(hsm);

    return EVENT_HANDLED;
}

static void traverse_to_display_state(struct hsm_display_context *hsm)
{
    hsm->machine.State = hsm_display_displaying;
    traverse_state(&hsm->machine, hsm_display_displaying);
}

static state_machine_result_t handle_encoder_switch_pressed_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    traverse_to_display_state(hsm);
    return EVENT_HANDLED;
}

static state_machine_result_t handle_user_inactivity_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    send_changed_irrigation_plan_if_needed(hsm);
    traverse_to_display_state(hsm);
    return EVENT_HANDLED;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if ((event_id->id == ENCODER_ROTATION_LEFT_EVENT_ID) || (event_id->id == ENCODER_ROTATION_RIGHT_EVENT_ID))
    {
        return handle_encoder_rotated_event(pmachine);
    }
    else if (event_id->id == ENCODER_SWITCH_PRESSED_EVENT_ID)
    {
        return handle_encoder_switch_pressed_event(pmachine);
    }
    else if (event_id->id == USER_INACTIVITY_EVENT_ID)
    {
        return handle_user_inactivity_event(pmachine);
    }
    return EVENT_UN_HANDLED;
}

static state_machine_result_t exit_handler(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    em_timer_start(&hsm->inactivity_timer);
    return EVENT_HANDLED;
}

const state_t hsm_display_editing[] = {
    {event_handler, NULL, exit_handler, &hsm_display_displaying[0], NULL, 2},
};
