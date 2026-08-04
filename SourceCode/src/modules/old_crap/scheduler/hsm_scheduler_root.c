/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/

#include "cmsis_os.h"
#include <stdlib.h>
#include <string.h>

#include "backup.h"
#include "em_event.h"
#include "encoder.h"
#include "gpio.h"
#include "gpio_pins.h"
#include "hsm_scheduler.h"
#include "hsm_scheduler_states.h"
#include "rtc.h"
#include "valves.h"

#include "encoder_rotation_left_event.h"
#include "encoder_rotation_right_event.h"
#include "get_irrigation_schedule_answer_event.h"
#include "get_irrigation_schedule_event.h"
#include "set_irrigation_schedule_event.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
const struct gpio_pin *valves_info[VALVES_COUNT] = {
    &gpio_pins[VALVE_1_PIN_ID],
    &gpio_pins[VALVE_2_PIN_ID],
    &gpio_pins[VALVE_3_PIN_ID],
    &gpio_pins[VALVE_4_PIN_ID],
};
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
struct scheduler_context scheduler;
static state_machine_t machine;
static state_machine_t *const machineList[] = {&machine};

static void initialize_all_valves(void)
{
    for (uint32_t valve = 0; valve < VALVES_COUNT; valve++)
    {
        valve_initialize(valves_info[valve], &scheduler.valves_handles[valve]);
    }
}

static void init_scheduler_hsm(void)
{
    machine.State = hsm_scheduler_waiting;
    traverse_state(&machine, hsm_scheduler_waiting);
}

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    initialize_all_valves();
    init_scheduler_hsm();
    encoder_init(&gpio_pins[ENCODER_CHANNEL_A], &gpio_pins[ENCODER_CHANNEL_B], ENCODER_ROTATION_LEFT_EVENT_ID,
                 ENCODER_ROTATION_RIGHT_EVENT_ID);
}

static void handle_test_event(void *event)
{
    machine.Event = event;
    dispatch_event(machineList, 1);
}

static state_machine_result_t handle_get_irrigation_schedule(void)
{
    union get_irrigation_schedule_answer_message message = {0};
    em_set_message_event(&message.event.super, GET_IRRIGATION_SCHEDULE_ANSWER_EVENT_ID);
    read_data_from_non_volatile_memory((uint8_t *)&scheduler.plan, sizeof(struct irrigation_week));
    memcpy(&message.event.irrigation_plan, &scheduler.plan, sizeof(struct irrigation_week));
    em_publish_message(&message);
    return EVENT_HANDLED;
}

static state_machine_result_t handle_set_irrigation_schedule(union set_irrigation_schedule_message *message)
{
    save_data_to_non_volatile_memory((uint8_t *)&message->event.irrigation_plan, sizeof(struct irrigation_week));
    memcpy(&scheduler.plan, &message->event.irrigation_plan, sizeof(struct irrigation_week));
    return EVENT_HANDLED;
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    struct event *event_id = pmachine->Event;
    if (event_id->id == GET_IRRIGATION_SCHEDULE_EVENT_ID)
    {
        return handle_get_irrigation_schedule();
    }
    else if (event_id->id == SET_IRRIGATION_SCHEDULE_EVENT_ID)
    {
        return handle_set_irrigation_schedule((union set_irrigation_schedule_message *)event_id);
    }
    return EVENT_UN_HANDLED;
}

const struct subscriber scheduler_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};

const state_t hsm_scheduler_root[] = {
    {event_handler, NULL, NULL, NULL, NULL, 0},
};
