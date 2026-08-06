/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "button_test_vectors.h"

#include "configuration.h"
#include "button_configuration.h"

#include "button_released_event.h"
#include "button_pressed_event.h"
/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
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

const struct device_configuration four_button_list[] =
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
const struct device_configuration one_button_list[] =
{
    {
        .id = DEVICE_BUTTON_LOCAL_UP,
        .type = DEVICE_TYPE_BUTTON,
        .config = &button_local_up,
    },
};