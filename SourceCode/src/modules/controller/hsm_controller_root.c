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

#include "em_event.h"
#include "executors.h"

#include "hsm.h"

#include "hsm_controller.h"
#include "hsm_controller_internal.h"
#include "hsm_controller_states.h"

#include "button_pressed_event.h"
#include "button_released_event.h"

#include "configuration.h"
#include "nvm.h"
#include "nvm_configuration.h"
#include "utils.h"

/* Private define ------------------------------------------------------------*/

/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
struct hsm_controller_context controller = {0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static void create_ui_timer(struct em_timer *timer, void *context)
{
    /* Debounce timer. */
    em_timer_create(timer, NULL, false, context);
    em_timer_set_event_id(timer, CONTROLLER_TIMER_EVENT_ID);
}

static void configure_nvm(const struct nvm_configuration *config)
{
    nvm_init(&config->configuration);
}

static void read_travel_time(struct hsm_controller_context *hsm, const struct nvm_configuration *config)
{
    enum nvm_result result = nvm_read(NVM_ID_TRAVEL_TIME, &hsm->movement_config);
    if (result != NVM_OK)
    {
        hsm->movement_config.time = config->default_time;
    }
}

static void configure_hsm(struct hsm_controller_context *hsm)
{
    hsm->currently_operating_button = INVALID_PIN_ID;

    hsm->machine.State = hsm_controller_idle;
    traverse_state(&hsm->machine, hsm_controller_idle);
}

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    struct hsm_controller_context *hsm = &controller;

    uint8_t devices_count = 0;
    const struct device_configuration *list = get_list_of_devices_by_type(DEVICE_TYPE_NVM, &devices_count);

    if ((list != NULL) && (devices_count == 1))
    {
        const struct device_configuration *current_device = (const struct device_configuration *)list;
        configure_nvm((const struct nvm_configuration *)current_device->config);
        read_travel_time(hsm, (const struct nvm_configuration *)current_device->config);
        create_ui_timer(&hsm->timer, hsm);
        configure_hsm(hsm);
    }
}

static void handle_test_event(void *event)
{
    (void)(event);
    controller.machine.Event = event;
    state_machine_t *const machineList[] = {&controller.machine};
    dispatch_event(machineList, 1);
}

static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);

    return EVENT_UN_HANDLED;
}

const struct subscriber controller_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};
CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&controller_subscriber))
CREATE_EVENT(CONTROLLER_TIMER_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))

const state_t hsm_controller_root[] = {
    {event_handler, NULL, NULL, NULL, NULL, 0},
};
