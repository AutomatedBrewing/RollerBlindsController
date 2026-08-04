/*
 * valves.c
 *
 *  Created on: 14 Mar 2023
 *      Author: dev
 */
#include <stddef.h>

#include "gpio.h"
#include "valves.h"

#define MAX_NUMBER_OF_SUPPORTED_VALVES (4)

struct valve_context
{
    const struct gpio_pin *info;
    void *pin_handle;
    bool is_opened;
    bool is_used;
};

static struct valve_context valve_context_list[MAX_NUMBER_OF_SUPPORTED_VALVES];

static struct valve_context *find_free_entry_for_pin(void)
{
    for (uint8_t handle_idx = 0; handle_idx < MAX_NUMBER_OF_SUPPORTED_VALVES; handle_idx++)
    {
        if (!valve_context_list[handle_idx].is_used)
        {
            return &valve_context_list[handle_idx];
        }
    }
    return NULL;
}

static struct valve_context *entry_add(const struct gpio_pin *info)
{
    struct valve_context *handle = find_free_entry_for_pin();
    if (handle != NULL)
    {
        handle->info = info;
        handle->is_used = true;
        return handle;
    }
    return NULL;
}

static struct valve_context *find_matching_entry_for_info(const struct gpio_pin *info)
{
    for (uint8_t handle_idx = 0; handle_idx < MAX_NUMBER_OF_SUPPORTED_VALVES; handle_idx++)
    {
        if (info == valve_context_list[handle_idx].info)
        {
            return &valve_context_list[handle_idx];
        }
    }
    return NULL;
}

static enum valve_status find_or_create_pin_entry_if_not_existing(const struct gpio_pin *info, void **handle)
{
    struct valve_context *entry = find_matching_entry_for_info(info);
    if (entry == NULL)
    {
        entry = entry_add(info);
        if (entry == NULL)
        {
            *handle = NULL;
            return VALVE_NO_MEMORY;
        }
    }
    *handle = (void *)entry;
    return VALVE_OK;
}

void valve_initialize(const void *valve_info, void **valve_handle)
{
    find_or_create_pin_entry_if_not_existing(valve_info, valve_handle);
    if (*valve_handle)
    {
        struct valve_context *handle = *valve_handle;
        gpio_pin_init(valve_info, &handle->pin_handle);
    }
}

void valve_open(void *valve_handle)
{
    struct valve_context *handle = valve_handle;
    gpio_output_set(handle->pin_handle);
    handle->is_opened = true;
}

void valve_close(void *valve_handle)
{
    struct valve_context *handle = valve_handle;
    gpio_output_clear(handle->pin_handle);
    handle->is_opened = false;
}

bool valve_is_open(void *valve_handle)
{
    struct valve_context *handle = valve_handle;
    return handle->is_opened;
}
