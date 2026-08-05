/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "cmsis_os.h"
#include "gpio.h"
#include "gpio_pins.h"
#include <stdlib.h>

#include "em_event.h"
#include "em_timer.h"
#include "executors.h"

#include "button_pressed_event.h"
#include "button_released_event.h"

#include "hsm_button.h"
#include "hsm_button_states.h"

#include "configuration.h"
/* Private define ------------------------------------------------------------*/


/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
struct hsm_button_context buttons[NO_OF_SUPPORTED_BUTTONS] = {0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

void button_activity_handler(void *data)
{
    struct hsm_button_context *context = data;
    gpio_input_interrupt_disable(context->button_handle);
    em_timer_start(&context->timer);
}

static struct hsm_button_context *get_free_entry(void)
{
    for (uint32_t index = 0; index < NO_OF_SUPPORTED_BUTTONS; index++)
    {
        if (buttons[index].is_used == false)
        {
            buttons[index].is_used = true;
            return &buttons[index];
        }
    }
    return NULL;
}

static void add_button_to_buttons_list(struct button_configuration const * configuration)
{
    struct hsm_button_context *entry = get_free_entry();
    if (entry != NULL)
    {
        entry->button_info = find_gpio_pin_context(configuration->pin_id);
        entry->configuration = configuration;
    }
}

static void configure_button_exti(struct hsm_button_context *button)
{
    struct input_pin_config config = {
        .activity = INTERRUPT_PIN_ACTIVITY_TOGGLE,
        .callback = button_activity_handler,
        .callback_data = button,
    };
    gpio_input_configure(button->button_handle, &config, false);
}

static void fill_input_pin_config(struct hsm_button_context *button_entry, struct input_pin_config *cfg,
                                  bool wait_for_activity)
{
    cfg->callback = button_activity_handler;
    cfg->callback_data = (void *)button_entry;
    cfg->activity = wait_for_activity ? INTERRUPT_PIN_ACTIVITY_INACTIVE_TO_ACTIVE : INTERRUPT_PIN_ACTIVITY_ACTIVE_TO_INACTIVE;
}

void button_input_wait_for_event(struct hsm_button_context *button_entry, bool wait_for_activity)
{
    struct input_pin_config cfg;
    fill_input_pin_config(button_entry, &cfg, wait_for_activity);
    gpio_input_configure(button_entry->button_handle, &cfg, true);
}

static const state_t *button_state_to_hsm_initial_state(struct hsm_button_context *button)
{
    bool is_active = gpio_input_is_active(button->button_handle);
    if (is_active)
    {
        return hsm_button_pressed;
    }
    else
    {
        return hsm_button_released;
    }
}

static void init_buttons_hsm(struct hsm_button_context *button)
{
    const state_t *initial_state;
    button->state = BUTTON_RELEASED;
    initial_state = button_state_to_hsm_initial_state(button);
    button->machine.State = initial_state;
    traverse_state(&button->machine, initial_state);
}

static void create_timer_for_button(struct hsm_button_context *button)
{
    em_timer_create(&button->timer, NULL, false, button);
    em_timer_set_event_id(&button->timer, TIMER_DEBOUNCE_EVENT_EVENT_ID);
    em_timer_set_period(&button->timer, button->configuration->timings.debounce_time);
}

static void initialize_buttons_from_list(void)
{
    for (uint32_t button = 0; button < NO_OF_SUPPORTED_BUTTONS; button++)
    {
        gpio_pin_init(buttons[button].button_info, &buttons[button].button_handle);
        configure_button_exti(&buttons[button]);
        init_buttons_hsm(&buttons[button]);
        create_timer_for_button(&buttons[button]);
    }
}

static void handle_init_event(uint32_t flags)
{
    (void)(flags);
    uint8_t devices_count = 0;
    const struct device_configuration * list = get_list_of_devices_by_type(DEVICE_TYPE_BUTTON, &devices_count);

    if((list != NULL) && (devices_count > 0))
    {
        for(uint8_t device = 0; device < devices_count; device++)
        {
            const struct device_configuration * current_device = (const struct device_configuration * ) &list[device];
            add_button_to_buttons_list((const struct button_configuration *)current_device->config);
        }
    }

    initialize_buttons_from_list();
}

static void handle_incoming_event(void *event)
{
    struct event *event_id = event;
    if (event_id->id == TIMER_DEBOUNCE_EVENT_EVENT_ID)
    {
        struct timer_event *timer_event = event;
        struct hsm_button_context *button_context = timer_event->context;
        button_context->machine.Event = event;
        state_machine_t *const machineList[] = {&button_context->machine};
        dispatch_event(machineList, 1);
    }
}

const struct subscriber button_subscriber = {.init = handle_init_event, .handle_event = handle_incoming_event};
CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(main_executor_subscribers, main_executor, ADD_SUBSCRIBER(&button_subscriber))
CREATE_EVENT(TIMER_DEBOUNCE_EVENT, ADD_SUBSCRIBER(&main_executor_subscribers))

const state_t hsm_button_root[] = {
    {NULL, NULL, NULL, NULL, NULL, 0},
};
