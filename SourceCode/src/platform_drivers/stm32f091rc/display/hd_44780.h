/*
 * hd_44780.h
 *
 *  Created on: 31 Mar 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_STM32F091RC_DISPLAY_HD_44780_H_
#define SRC_PLATFORM_DRIVERS_STM32F091RC_DISPLAY_HD_44780_H_

#include <stdint.h>
#include "display.h"

/* Function set */
#define LCD_8BIT_MODE 0x10
#define LCD_4BIT_MODE 0x00
#define LCD_2_LINE 0x08
#define LCD_1_LINE 0x00

#define LCD_5x10_DOTS 0x04
#define LCD_5x8_DOTS 0x00

typedef struct
{
    uint8_t disp_func; /* Display Function */
    uint8_t disp_cntl; /* Display Control */
    uint8_t disp_mode; /* Display Mode */
    uint8_t cfg_rows;
    uint8_t cfg_cols;
    uint8_t row_offsets[4];
} hd_volatile;

typedef struct
{
    void *D7_pin_handle;
    void *D6_pin_handle;
    void *D5_pin_handle;
    void *D4_pin_handle;
    void *RS_pin_handle;
    void *RW_pin_handle;
    void *E_pin_handle;
    hd_volatile *data;
} hd44780_ctx;

void lcd_init(hd44780_ctx *context, struct lcd_pins *pins, uint8_t cols, uint8_t rows, uint8_t dotsize);
void lcd_char(const hd44780_ctx *context, char c);
void lcd_str(const hd44780_ctx *context, char *str);
void lcd_int(const hd44780_ctx *context, int val);
void lcd_hex(const hd44780_ctx *context, uint32_t val);
void lcd_defchar(const hd44780_ctx *context, uint8_t number, uint8_t *sign_def);
void lcd_set_cursor(const hd44780_ctx *context, uint8_t col, uint8_t row);
void lcd_clear(const hd44780_ctx *context);
void lcd_home(const hd44780_ctx *context);
void lcd_display_on(const hd44780_ctx *context);
void lcd_display_off(const hd44780_ctx *context);
void lcd_cursor_on(const hd44780_ctx *context);
void lcd_cursor_off(const hd44780_ctx *context);
void lcd_blink_on(const hd44780_ctx *context);
void lcd_blink_off(const hd44780_ctx *context);
void lcd_scroll_left(const hd44780_ctx *context);
void lcd_scroll_right(const hd44780_ctx *context);
void lcd_left_to_right(const hd44780_ctx *context);
void lcd_right_to_left(const hd44780_ctx *context);
void lcd_justify_right(const hd44780_ctx *context);
void lcd_justify_left(const hd44780_ctx *context);

#endif /* SRC_PLATFORM_DRIVERS_STM32F091RC_DISPLAY_HD_44780_H_ */
