/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os.h"
#include "utils.h"
#include <stdlib.h>
#include <string.h>

#include "em_event.h"
#include "em_timer.h"
#include "executors.h"

#include "hsm_display.h"
#include "hsm_display_states.h"

#include "buf_lcd.h"
#include "layers.h"

#include "get_irrigation_schedule_answer_event.h"
#include "get_irrigation_schedule_event.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
struct hsm_display_context display_hsm = {0};

struct day_display_context context_of_monday_display[] = {
    {.p_hsm = &display_hsm, .day = MONDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = MONDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = MONDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = MONDAY, .section = 3},
};

struct day_display_context context_of_tuesday_display[] = {
    {.p_hsm = &display_hsm, .day = TUESDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = TUESDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = TUESDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = TUESDAY, .section = 3},
};

struct day_display_context context_of_wednesday_display[] = {
    {.p_hsm = &display_hsm, .day = WENDESDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = WENDESDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = WENDESDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = WENDESDAY, .section = 3},
};

struct day_display_context context_of_thursday_display[] = {
    {.p_hsm = &display_hsm, .day = THURSDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = THURSDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = THURSDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = THURSDAY, .section = 3},
};

struct day_display_context context_of_friday_display[] = {
    {.p_hsm = &display_hsm, .day = FRIDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = FRIDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = FRIDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = FRIDAY, .section = 3},
};

struct day_display_context context_of_saturday_display[] = {
    {.p_hsm = &display_hsm, .day = SATURDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = SATURDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = SATURDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = SATURDAY, .section = 3},
};

struct day_display_context context_of_sunday_display[] = {
    {.p_hsm = &display_hsm, .day = SUNDAY, .section = 0},
    {.p_hsm = &display_hsm, .day = SUNDAY, .section = 1},
    {.p_hsm = &display_hsm, .day = SUNDAY, .section = 2},
    {.p_hsm = &display_hsm, .day = SUNDAY, .section = 3},
};
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void init_display_hsm(struct hsm_display_context *hsm)
{
    hsm->machine.State = hsm_display_root;
    traverse_state(&hsm->machine, hsm_display_root);
}

static void initialize_screens(struct hsm_display_context *hsm)
{
    hsm->screens[0] = &monday_screen;
    hsm->screens[1] = &tuesday_screen;
    hsm->screens[2] = &wednesday_screen;
    hsm->screens[3] = &thursday_screen;
    hsm->screens[4] = &friday_screen;
    hsm->screens[5] = &saturday_screen;
    hsm->screens[6] = &sunday_screen;
    hsm->currenct_screen_index = 0;
}

static void initialize_display(struct hsm_display_context *hsm)
{
    struct lcd_pins lcd_display_pins = {
        &gpio_pins[DISPLAY_D7], &gpio_pins[DISPLAY_D6], &gpio_pins[DISPLAY_D5], &gpio_pins[DISPLAY_D4],
        &gpio_pins[DISPLAY_RS], &gpio_pins[DISPLAY_RW], &gpio_pins[DISPLAY_E],
    };
    LCD_BUF_init(&lcd_display_pins);
    initialize_monday(context_of_monday_display);
    initialize_tuesday(context_of_tuesday_display);
    initialize_wednesday(context_of_wednesday_display);
    initialize_thursday(context_of_thursday_display);
    initialize_friday(context_of_friday_display);
    initialize_saturday(context_of_saturday_display);
    initialize_sunday(context_of_sunday_display);
    initialize_screens(hsm);
}

static void allocate_and_initialize_timers(struct hsm_display_context *hsm)
{
    em_timer_create(&hsm->refresh_timer, true, NULL);
    em_timer_set_event_id(&hsm->refresh_timer, DISPLAY_REFRESH_EVENT_ID);
    em_timer_set_period(&hsm->refresh_timer, 500);

    em_timer_create(&hsm->inactivity_timer, false, NULL);
    em_timer_set_event_id(&hsm->inactivity_timer, USER_INACTIVITY_EVENT_ID);
    em_timer_set_period(&hsm->inactivity_timer, 5000);
}

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    initialize_display(&display_hsm);
    allocate_and_initialize_timers(&display_hsm);
    init_display_hsm(&display_hsm);
}

static void handle_test_event(void *event)
{
    display_hsm.machine.Event = event;
    state_machine_t *const machineList[] = {&display_hsm.machine};
    dispatch_event(machineList, 1);
}

static void handle_get_irrigation_schedule_answer(state_machine_t *const pmachine,
                                                  union get_irrigation_schedule_answer_message *message)
{
    struct hsm_display_context *hsm = CONTAINER_OF(pmachine, struct hsm_display_context, machine);
    memcpy(&hsm->irrigation_plan, &message->event.irrigation_plan, sizeof(struct irrigation_week));
    memcpy(&hsm->irrigation_plan_cache, &message->event.irrigation_plan, sizeof(struct irrigation_week));

    hsm->machine.State = hsm_display_displaying;
    traverse_state(&hsm->machine, hsm_display_displaying);
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == GET_IRRIGATION_SCHEDULE_ANSWER_EVENT_ID)
    {
        handle_get_irrigation_schedule_answer(pmachine, (union get_irrigation_schedule_answer_message *)event_id);
        return EVENT_HANDLED;
    }
    return EVENT_UN_HANDLED;
}

static state_machine_result_t entry_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    union get_irrigation_schedule_message message = {0};
    em_set_message_event(&message.event.super, GET_IRRIGATION_SCHEDULE_EVENT_ID);
    em_publish_message(&message);
    return EVENT_HANDLED;
}

const struct subscriber display_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};
CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&display_subscriber))
CREATE_EVENT(DISPLAY_REFRESH_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))
CREATE_EVENT(USER_INACTIVITY_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))

const state_t hsm_display_root[] = {
    {event_handler, entry_handler, NULL, NULL, &hsm_display_displaying[0], 0},
};
