/*
 * configuration.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "configuration.h"
#include "button_pressed_event.h"
#include "button_released_event.h"

#include "nvm.h"
#include "flash.h"

#include "utils.h"

/* Private define ------------------------------------------------------------*/
#define MOTOR_SAFETY_TIMER_TIMEOUT (MINUTES(2))

#define BUTTON_TIMINGS_DEFAULT                                                                                         \
    {                                                                                                                  \
        .debounce_time = 20, .long_press_time = 200, .very_long_press_time = 5000                                      \
    }

#define BUTTON_EVENTS_DEFAULT                                                                                          \
    {                                                                                                                  \
        .event_pressed = BUTTON_PRESSED_EVENT_ID, .event_released = BUTTON_RELEASED_EVENT_ID,                          \
    }

//#define DEFAULT_TRAVEL_TIME MINUTES(1)
#define DEFAULT_TRAVEL_TIME (5000)
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/*-------------------   BUTTONS */
static const struct button_configuration button_local_up = {
    .pin_id = BUTTON_LOCAL_UP_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct button_configuration button_local_down = {
    .pin_id = BUTTON_LOCAL_DOWN_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};


static const struct button_configuration button_remote_up = {
    .pin_id = BUTTON_REMOTE_UP_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct button_configuration button_remote_down = {
    .pin_id = BUTTON_REMOTE_DOWN_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct device_configuration button_devices_list[] = {
    {
        .id = DEVICE_BUTTON_LOCAL_UP,
        .type = DEVICE_TYPE_BUTTON,
        .config = &button_local_up,
    },
    
    {
        .id = DEVICE_BUTTON_LOCAL_DOWN,
        .type = DEVICE_TYPE_BUTTON,
        .config = &button_local_down,
    },

    {
        .id = DEVICE_BUTTON_REMOTE_UP,
        .type = DEVICE_TYPE_BUTTON,
        .config = &button_remote_up,
    },
    {
        .id = DEVICE_BUTTON_REMOTE_DOWN,
        .type = DEVICE_TYPE_BUTTON,
        .config = &button_remote_down,
    },
};

/*-------------------   MOTOR */
static const struct motor_configuration motor_config = {
    .motor_up_pin_id = MOTOR_UP_PIN_ID,
    .motor_down_pin_id = MOTOR_DOWN_PIN_ID,
    .timeout = MOTOR_SAFETY_TIMER_TIMEOUT,
};

static const struct device_configuration motor_devices_list[] = {
    {
        .id = DEVICE_MOTOR,
        .type = DEVICE_TYPE_MOTOR,
        .config = &motor_config,
    },
};

/*-------------------   BUZZER */
static const struct buzzer_configuration buzzer_config = {
    .pin_id = BUZZER_PIN_ID,
    .timings =
        {
            .on_time = 100,
            .off_time = 100,
            .repetitions = 2,
        },
};

static const struct device_configuration ui_devices_list[] = {
    {
        .id = DEVICE_BUZZER,
        .type = DEVICE_TYPE_BUZZER,
        .config = &buzzer_config,
    },
};


/*-------------------   NVM */
static const struct nvm_object nvm_objects[] = {
    {
        .id = NVM_ID_TRAVEL_TIME,
        .size = sizeof(struct travel_time)
    },
};


static const struct nvm_backend nvm_backend = {
    .size = 2048U,
    .erase_size = 256U,
/*
    .read = flash_read,
    .write = flash_program,
    .erase = flash_erase
    */
};


static const struct nvm_configuration nvm_config =
{
    .configuration = 
    {    
        .backend = &nvm_backend,
        .objects = nvm_objects,
        .object_count =
        sizeof(nvm_objects) / sizeof(nvm_objects[0])
    },
    .default_time = DEFAULT_TRAVEL_TIME,
};

static const struct device_configuration nvm_devices_list[] = {
    {
        .id = DEVICE_NVM,
        .type = DEVICE_TYPE_NVM,
        .config = &nvm_config,
    },
};
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

const struct device_configuration *get_list_of_devices_by_type(enum device_type type, uint8_t *devices_count)
{
    if (devices_count == NULL)
    {
        return NULL;
    }

    switch (type)
    {
    case DEVICE_TYPE_BUTTON:
        *devices_count = ARRAY_SIZE(button_devices_list);
        return button_devices_list;

    case DEVICE_TYPE_BUZZER:
        *devices_count = ARRAY_SIZE(ui_devices_list);
        return ui_devices_list;

    case DEVICE_TYPE_MOTOR:
        *devices_count = ARRAY_SIZE(motor_devices_list);
        return motor_devices_list;

    case DEVICE_TYPE_NVM:
        *devices_count = ARRAY_SIZE(nvm_devices_list);
        return nvm_devices_list;

    default:
        *devices_count = 0;
        return NULL;
    }
}