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

#include "utils.h"

/* Private define ------------------------------------------------------------*/
#define BUTTON_TIMINGS_DEFAULT   \
{                                \
    .debounce_time = 20,         \
    .long_press_time = 500,      \
    .very_long_press_time = 5000 \
}

#define BUTTON_EVENTS_DEFAULT                   \
{                                               \
    .event_pressed = BUTTON_PRESSED_EVENT_ID,   \
    .event_released = BUTTON_RELEASED_EVENT_ID, \
}

/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static const struct button_configuration button_local_up =
{
    .pin_id = BUTTON_LOCAL_UP_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct button_configuration button_local_down =
{
    .pin_id = BUTTON_LOCAL_DOWN_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct button_configuration button_remote_up =
{
    .pin_id = BUTTON_REMOTE_UP_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct button_configuration button_remote_down =
{
    .pin_id = BUTTON_REMOTE_DOWN_PIN_ID,
    .timings = BUTTON_TIMINGS_DEFAULT,
    .events = BUTTON_EVENTS_DEFAULT,
};

static const struct device_configuration button_devices_list[] =
{
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
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

const struct device_configuration * get_list_of_devices_by_type(enum device_type type, uint8_t * devices_count)
{
    if(devices_count == NULL)
    {
        return NULL;
    }

    switch(type)
    {
        case DEVICE_TYPE_BUTTON:
            *devices_count = ARRAY_SIZE(button_devices_list);
            return button_devices_list;

        case DEVICE_TYPE_BUZZER:
            *devices_count = 0;
            return NULL;

        case DEVICE_TYPE_MOTOR:
            *devices_count = 0;
            return NULL;

        default:
            *devices_count = 0;
            return NULL;
    }
    
}