/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/

#include "gpio.h"
#include "gpio_pins.h"

#include "em_event.h"
#include "em_timer.h"
#include "executors.h"

#include "em_event.h"
#include "hsm.h"

#include "hsm_ui.h"
#include "hsm_ui_states.h"
#include "hsm_ui_internal.h"

#include "configuration.h"
#include "ui_configuration.h"

#include "utils.h"

/* Private define ------------------------------------------------------------*/


/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
struct hsm_ui_context ui = {0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static void init_ui_hsm(struct hsm_ui_context *hsm)
{
    const state_t *initial_state;
    initial_state = hsm_ui_idle;
    hsm->machine.State = initial_state;
    traverse_state(&hsm->machine, initial_state);
}

static void create_ui_timer(struct em_timer * timer, void * context)
{
    /* Debounce timer. */
    em_timer_create(timer, NULL, false, context);
    em_timer_set_event_id(timer, UI_TIMER_EVENT_ID);
}

static void configure_gpio(struct buzzer * buzzer, const enum board_input_pin_id buzzer_pin_id)
{
    buzzer->gpio_info = find_gpio_pin_context(buzzer_pin_id);
    gpio_pin_init(buzzer->gpio_info, &buzzer->gpio_handle);
    gpio_output_configure(buzzer->gpio_handle, buzzer->gpio_info->mode);
    gpio_output_clear(buzzer->gpio_handle);
}

static void configure_buzzers(struct hsm_ui_context *hsm, const struct buzzer_configuration * config)
{
    hsm->configuration = config;
    configure_gpio(&hsm->buzzer, config->pin_id);
    create_ui_timer(&hsm->timer, hsm);
}

/* Private function bodies ---------------------------------------------------*/

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    struct hsm_ui_context *hsm = &ui;
    uint8_t devices_count = 0;
    const struct device_configuration *list = get_list_of_devices_by_type(DEVICE_TYPE_BUZZER, &devices_count);

    if ((list != NULL) && (devices_count == 1))
    {
        const struct device_configuration *current_device = (const struct device_configuration *)list;
        configure_buzzers(hsm, (const struct buzzer_configuration *)current_device->config);
        init_ui_hsm(hsm);
    }
}

static void handle_test_event(void *event)
{
    ui.machine.Event = event;
    state_machine_t *const machineList[] = {&ui.machine};
    dispatch_event(machineList, 1);
}




static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    

    return EVENT_UN_HANDLED;
}

const struct subscriber ui_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};
CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&ui_subscriber))
CREATE_EVENT(UI_TIMER_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))


const state_t hsm_ui_root[] = {
    {event_handler, NULL, NULL, NULL, NULL, 0},
};
