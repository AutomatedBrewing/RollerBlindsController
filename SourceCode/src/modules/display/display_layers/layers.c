/*
 * warstwy.c
 *
 *  Created on: 28-02-2012
 *      Author: Miros�aw Karda�
 */
/* Private includes ----------------------------------------------------------*/
#include <stdio.h>
#include <string.h>

#include "buf_lcd.h"
#include "hsm_display.h"
#include "layers.h"
#include "rtc.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
TWIN monday_sections[5] = {0};
TWIN tuesday_sections[5] = {0};
TWIN wednesday_sections[5] = {0};
TWIN thursday_sections[5] = {0};
TWIN friday_sections[5] = {0};
TWIN saturday_sections[5] = {0};
TWIN sunday_sections[5] = {0};

const LCD_screen monday_screen = {
    .layer_tab = {&monday_sections[0], &monday_sections[1], &monday_sections[2], &monday_sections[3],
                  &monday_sections[4]},
    .layer_count = 5,
};
const LCD_screen tuesday_screen = {
    .layer_tab = {&tuesday_sections[0], &tuesday_sections[1], &tuesday_sections[2], &tuesday_sections[3],
                  &tuesday_sections[4]},
    .layer_count = 5,
};
const LCD_screen wednesday_screen = {
    .layer_tab = {&wednesday_sections[0], &wednesday_sections[1], &wednesday_sections[2], &wednesday_sections[3],
                  &wednesday_sections[4]},
    .layer_count = 5,
};
const LCD_screen thursday_screen = {
    .layer_tab = {&thursday_sections[0], &thursday_sections[1], &thursday_sections[2], &thursday_sections[3],
                  &thursday_sections[4]},
    .layer_count = 5,
};
const LCD_screen friday_screen = {
    .layer_tab = {&friday_sections[0], &friday_sections[1], &friday_sections[2], &friday_sections[3],
                  &friday_sections[4]},
    .layer_count = 5,
};
const LCD_screen saturday_screen = {
    .layer_tab = {&saturday_sections[0], &saturday_sections[1], &saturday_sections[2], &saturday_sections[3],
                  &saturday_sections[4]},
    .layer_count = 5,
};
const LCD_screen sunday_screen = {
    .layer_tab = {&sunday_sections[0], &sunday_sections[1], &sunday_sections[2], &sunday_sections[3],
                  &sunday_sections[4]},
    .layer_count = 5,
};

char monday_name[] = "Monday";
char tuesday_name[] = "Tuesday";
char wednesday_name[] = "Wednesday";
char thursday_name[] = "Thursday";
char friday_name[] = "Friday";
char saturday_name[] = "Saturday";
char sunday_name[] = "Sunday";

static void print_section_names(void)
{
    LCD_BUF_locate(0, 9);
    char sections[] = "1 2 3 4";
    LCD_BUF_put_str(sections);
}

static char *get_day_name(enum rtc_weekday day)
{
    switch (day)
    {
    case MONDAY:
        return monday_name;
    case TUESDAY:
        return tuesday_name;
    case WENDESDAY:
        return wednesday_name;
    case THURSDAY:
        return thursday_name;
    case FRIDAY:
        return friday_name;
    case SATURDAY:
        return saturday_name;
    default:
    case SUNDAY:
        return sunday_name;
    }
}

static void print_day_name(void *layer)
{
    TWIN *lay = layer;
    active_buf = lay->buf;
    LCD_BUF_cls(active_buf, (uint8_t)(lay->height * lay->width));
    LCD_BUF_locate(0, 0);
    struct day_display_context *context = lay->context;
    char *day_name = get_day_name(context->day);
    LCD_BUF_put_str(day_name);
    print_section_names();
}

static void print_section(void *layer)
{
    TWIN *current_layer = layer;
    active_buf = current_layer->buf;
    LCD_BUF_cls(active_buf, (uint8_t)(current_layer->height * current_layer->width));
    LCD_BUF_locate(0, 0);

    struct day_display_context *context = current_layer->context;
    bool is_valve_active = context->p_hsm->irrigation_plan_cache.week[context->day].valves[context->section];
    char layer_content = is_valve_active ? 'x' : '-';
    LCD_BUF_put_str(&layer_content);
}

/* WELCOME SCREEN */
static void initialize_day(const LCD_screen *screen, struct day_display_context *context_array)
{
    LCD_BUF_create_obj(screen->layer_tab[0], 0, 0, 16, 1, 1, false, print_day_name, &context_array[0]);
    LCD_BUF_create_obj(screen->layer_tab[1], 9, 1, 1, 1, 1, true, print_section, &context_array[0]);
    LCD_BUF_create_obj(screen->layer_tab[2], 11, 1, 1, 1, 1, true, print_section, &context_array[1]);
    LCD_BUF_create_obj(screen->layer_tab[3], 13, 1, 1, 1, 1, true, print_section, &context_array[2]);
    LCD_BUF_create_obj(screen->layer_tab[4], 15, 1, 1, 1, 1, true, print_section, &context_array[3]);
}

void initialize_monday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&monday_screen, context_array);
}

void initialize_tuesday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&tuesday_screen, context_array);
}

void initialize_wednesday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&wednesday_screen, context_array);
}

void initialize_thursday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&thursday_screen, context_array);
}

void initialize_friday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&friday_screen, context_array);
}

void initialize_saturday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&saturday_screen, context_array);
}

void initialize_sunday(void *context)
{
    struct day_display_context *context_array = context;
    initialize_day(&sunday_screen, context_array);
}
