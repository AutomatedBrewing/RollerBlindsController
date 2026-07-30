/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include <string.h>

#include "em_event.h"
#include "em_timer.h"

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
static void restart_inactivity_timer_if_needed(struct hsm_display_context *hsm)
{
    if (em_timer_is_running(&hsm->inactivity_timer))
    {
        em_timer_start(&hsm->inactivity_timer);
    }
}

static void save_layer_pointed_by_cursor(struct hsm_display_context *display_handle, TWIN *layer, uint32_t layer_index)
{
    display_handle->layer_pointed_by_cursor = layer;
    display_handle->index_of_layer_pointed_by_cursor = layer_index;
}

static void assign_first_editable_layer(struct hsm_display_context *display_handle, const LCD_screen *screen)
{
    for (uint32_t layer_index = 0; layer_index < screen->layer_count; layer_index++)
    {
        if (LCD_BUF_is_layer_editable(screen->layer_tab[layer_index]))
        {
            save_layer_pointed_by_cursor(display_handle, screen->layer_tab[layer_index], layer_index);
            return;
        }
    }
    save_layer_pointed_by_cursor(display_handle, NULL, 0);
}

static void assign_last_editable_layer(struct hsm_display_context *display_handle, const LCD_screen *screen)
{
    for (int32_t layer_index = (int32_t)screen->layer_count; layer_index >= 0; layer_index--)
    {
        if (LCD_BUF_is_layer_editable(screen->layer_tab[layer_index]))
        {
            save_layer_pointed_by_cursor(display_handle, screen->layer_tab[layer_index], (uint32_t)layer_index);
            return;
        }
    }
    save_layer_pointed_by_cursor(display_handle, NULL, 0);
}

static void assign_next_editable_layer(struct hsm_display_context *display_handle, const LCD_screen *screen)
{
    for (uint32_t layer_index = display_handle->index_of_layer_pointed_by_cursor + 1; layer_index < screen->layer_count;
         layer_index++)
    {
        if (LCD_BUF_is_layer_editable(screen->layer_tab[layer_index]))
        {
            save_layer_pointed_by_cursor(display_handle, screen->layer_tab[layer_index], layer_index);
            return;
        }
    }
    save_layer_pointed_by_cursor(display_handle, NULL, 0);
}

static void assign_previous_editable_layer(struct hsm_display_context *display_handle, const LCD_screen *screen)
{
    for (int32_t layer_index = (int32_t)display_handle->index_of_layer_pointed_by_cursor - 1; layer_index >= 0;
         layer_index--)
    {
        if (LCD_BUF_is_layer_editable(screen->layer_tab[layer_index]))
        {
            save_layer_pointed_by_cursor(display_handle, screen->layer_tab[layer_index], (uint32_t)layer_index);
            return;
        }
    }
    save_layer_pointed_by_cursor(display_handle, NULL, 0);
}

static void go_to_next_screen(struct hsm_display_context *display_handle)
{
    display_handle->currenct_screen_index++;
    if (display_handle->currenct_screen_index > ARRAY_SIZE(display_handle->screens) - 1)
    {
        display_handle->currenct_screen_index = 0;
    }
    const LCD_screen *screen_to_display = display_handle->screens[display_handle->currenct_screen_index];
    LCD_BUF_set_screen(screen_to_display, NONE);

    if (display_handle->layer_pointed_by_cursor)
    {
        LCD_BUF_locate_cursor_on_layer(display_handle->layer_pointed_by_cursor);
    }
    else
    {
        assign_first_editable_layer(display_handle, screen_to_display);
        LCD_BUF_locate_cursor_on_layer(display_handle->layer_pointed_by_cursor);
    }
}

static void go_to_previous_screen(struct hsm_display_context *display_handle)
{
    if (display_handle->currenct_screen_index > 0)
    {
        display_handle->currenct_screen_index--;
    }
    else
    {
        display_handle->currenct_screen_index = ARRAY_SIZE(display_handle->screens) - 1;
    }

    const LCD_screen *screen_to_display = display_handle->screens[display_handle->currenct_screen_index];
    LCD_BUF_set_screen(screen_to_display, NONE);
    assign_last_editable_layer(display_handle, screen_to_display);
    if (display_handle->layer_pointed_by_cursor)
    {
        LCD_BUF_locate_cursor_on_layer(display_handle->layer_pointed_by_cursor);
    }
}

/* Private function bodies ---------------------------------------------------*/
static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    struct hsm_display_context *display_handle = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    em_timer_start(&display_handle->refresh_timer);
    const LCD_screen *screen_to_display = display_handle->screens[display_handle->currenct_screen_index];
    LCD_BUF_set_screen(screen_to_display, NONE);

    if (display_handle->layer_pointed_by_cursor)
    {
        LCD_BUF_locate_cursor_on_layer(display_handle->layer_pointed_by_cursor);
    }
    else
    {
        assign_first_editable_layer(display_handle, screen_to_display);
        LCD_BUF_locate_cursor_on_layer(display_handle->layer_pointed_by_cursor);
    }
    return EVENT_HANDLED;
}

static state_machine_result_t handle_display_refresh_event(void)
{
    LCD_BUF_refresh();
    return EVENT_HANDLED;
}

static state_machine_result_t handle_encoder_rotated_left_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    const LCD_screen *screen_to_display = hsm->screens[hsm->currenct_screen_index];
    assign_previous_editable_layer(hsm, screen_to_display);
    if (hsm->layer_pointed_by_cursor)
    {
        LCD_BUF_locate_cursor_on_layer(hsm->layer_pointed_by_cursor);
    }
    else
    {
        go_to_previous_screen(hsm);
    }
    restart_inactivity_timer_if_needed(hsm);
    return EVENT_HANDLED;
}

static state_machine_result_t handle_encoder_rotated_right_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);

    const LCD_screen *screen_to_display = hsm->screens[hsm->currenct_screen_index];
    assign_next_editable_layer(hsm, screen_to_display);
    if (hsm->layer_pointed_by_cursor)
    {
        LCD_BUF_locate_cursor_on_layer(hsm->layer_pointed_by_cursor);
    }
    else
    {
        go_to_next_screen(hsm);
    }
    restart_inactivity_timer_if_needed(hsm);
    return EVENT_HANDLED;
}

static state_machine_result_t handle_encoder_switch_pressed_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    hsm->machine.State = hsm_display_editing;
    traverse_state(&hsm->machine, hsm_display_editing);
    return EVENT_HANDLED;
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

static state_machine_result_t handle_user_inactivity_event(state_machine_t *const pmachine)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    send_changed_irrigation_plan_if_needed(hsm);
    return EVENT_HANDLED;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == DISPLAY_REFRESH_EVENT_ID)
    {
        return handle_display_refresh_event();
    }
    else if (event_id->id == ENCODER_ROTATION_LEFT_EVENT_ID)
    {
        return handle_encoder_rotated_left_event(pmachine);
    }
    else if (event_id->id == ENCODER_ROTATION_RIGHT_EVENT_ID)
    {
        return handle_encoder_rotated_right_event(pmachine);
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

const state_t hsm_display_displaying[] = {
    {event_handler, entry_handler, NULL, &hsm_display_root[0], &hsm_display_editing[0], 1},
};
