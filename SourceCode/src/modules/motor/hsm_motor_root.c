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

#include "hsm_motor.h"
#include "hsm_motor_states.h"

#include "configuration.h"
#include "motor_configuration.h"

#include "utils.h"

/* Private define ------------------------------------------------------------*/


/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static struct hsm_motor_context motor = {0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
static void init_motor_hsm(struct hsm_motor_context *hsm)
{
    const state_t *initial_state;
    initial_state = hsm_motor_idle;
    hsm->machine.State = initial_state;
    traverse_state(&hsm->machine, initial_state);
}

static void create_safety_timer(struct em_timer * timer, void * context, uint32_t timeout)
{
    /* Debounce timer. */
    em_timer_create(timer, NULL, false, context);
    em_timer_set_event_id(timer, SAFETY_TIMER_EVENT_ID);
    em_timer_set_period(timer, timeout);
}

static void configure_gpio(struct motor * motor, const enum board_input_pin_id motor_pin_id)
{
    motor->gpio_info = find_gpio_pin_context(motor_pin_id);
    gpio_pin_init(motor->gpio_info, &motor->gpio_handle);
    gpio_output_configure(motor->gpio_handle, motor->gpio_info->mode);
    gpio_output_clear(motor->gpio_handle);
}

static void configure_motors(struct hsm_motor_context *hsm, const struct motor_configuration * config)
{
    configure_gpio(&hsm->motor_up, config->motor_up_pin_id);
    configure_gpio(&hsm->motor_down, config->motor_down_pin_id);
    create_safety_timer(&hsm->safety_timer, hsm, config->timeout);
}

/* Private function bodies ---------------------------------------------------*/

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    struct hsm_motor_context *hsm = &motor;
    uint8_t devices_count = 0;
    const struct device_configuration *list = get_list_of_devices_by_type(DEVICE_TYPE_MOTOR, &devices_count);

    if ((list != NULL) && (devices_count == 1))
    {
        const struct device_configuration *current_device = (const struct device_configuration *)list;
        configure_motors(hsm, (const struct motor_configuration *)current_device->config);
        init_motor_hsm(hsm);
    }
}

static void handle_test_event(void *event)
{
    (void)(event);
    motor.machine.Event = event;
    state_machine_t *const machineList[] = {&motor.machine};
    dispatch_event(machineList, 1);
}




static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    

    return EVENT_UN_HANDLED;
}

const struct subscriber motor_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};
CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&motor_subscriber))
CREATE_EVENT(SAFETY_TIMER_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))


const state_t hsm_motor_root[] = {
    {event_handler, NULL, NULL, NULL, NULL, 0},
};
