/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/

#include "cmsis_os.h"
#include "gpio.h"
#include "gpio_pins.h"
#include <stdlib.h>

#include "blink_event.h"
#include "em_event.h"
#include "em_executor.h"
#include "em_timer.h"
#include "hsm_blink.h"

#include "hsm_blink_states.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

struct blink_context blink_context;
struct em_timer blink_timer;
state_machine_t machine;
state_machine_t *const machineList[] = {&machine};

static void init_blink_hsm(void)
{
    machine.State = hsm_blink_off;
    traverse_state(&machine, hsm_blink_off);
}

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    blink_context.led_info = &gpio_pins[LED_PIN_ID];
    gpio_pin_init(blink_context.led_info, &blink_context.led_handle);

    init_blink_hsm();

    em_timer_create(&blink_timer, true, NULL);
    em_timer_set_event_id(&blink_timer, BLINK_EVENT_ID);
    em_timer_set_period(&blink_timer, 500);
    //    em_timer_start(&blink_timer);
}

static void handle_test_event(void *event)
{
    machine.Event = event;
    dispatch_event(machineList, 1);
}

const struct subscriber blink_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};

const state_t hsm_blink_root[] = {
    {NULL, NULL, NULL, NULL, NULL, 0},
};
