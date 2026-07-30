/*
 * display.c
 *
 *  Created on: 23 Mar 2023
 *      Author: dev
 */
/* Private includes ----------------------------------------------------------*/
#include "hd_44780.h"
#include "cmsis_os.h"
#include "display.h"
#include "gpio.h"
#include "utils.h"
#include <stdlib.h>
/* Private define ------------------------------------------------------------*/

/* @brief Dimentions of the display rows x cols */
/* @brief Usage of RW pin.
 * 0 - connected to GND
 * 1 - connected to uC */
#define USE_RW 1

/* Commands */
#define LCD_CLEAR_DISPLAY 0x01
#define LCD_RETURN_HOME 0x02
#define LCD_ENTRY_MODE_SET 0x04
#define LCD_DISPLAY_CONTROL 0x08
#define LCD_CURSOR_SHIFT 0x10
#define LCD_FUNCTION_SET 0x20
#define LCD_SET_CGRAM_ADDR 0x40
#define LCD_SET_DDRAM_ADDR 0x80

/* Display entry mode */
#define LCD_ENTRY_RIGHT 0x00
#define LCD_ENTRY_LEFT 0x02
#define LCD_ENTRY_SHIFT_INCREMENT 0x01
#define LCD_ENTRY_SHIFT_DECREMENT 0x00

/* Display on/off control */
#define LCD_DISPLAY_ON 0x04
#define LCD_DISPLAY_OFF 0x00
#define LCD_CURSOR_ON 0x02
#define LCD_CURSOR_OFF 0x00
#define LCD_BLINK_ON 0x01
#define LCD_BLINK_OFF 0x00

/* Display/cursor shift */
#define LCD_DISPLAY_MOVE 0x08
#define LCD_CURSOR_MOVE 0x00
#define LCD_MOVE_RIGHT 0x04
#define LCD_MOVE_LEFT 0x00

#define BUSY_BIT (1 << 7) /* Busy bit position */

/* Private typedef -----------------------------------------------------------*/

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

/* Private function prototypes -----------------------------------------------*/
#define SET_RS(ctx) gpio_output_set(ctx->RS_pin_handle)
#define CLR_RS(ctx) gpio_output_clear(ctx->RS_pin_handle)

#define SET_RW(ctx) gpio_output_set(ctx->RW_pin_handle)
#define CLR_RW(ctx) gpio_output_clear(ctx->RW_pin_handle)

#define SET_E(ctx) gpio_output_set(ctx->E_pin_handle)
#define CLR_E(ctx) gpio_output_clear(ctx->E_pin_handle)
/* Private function bodies ---------------------------------------------------*/
#if USE_RW == 1
static uint8_t lcd_read_busy_flag(const hd44780_ctx *lcd_ctx);
#endif
/* Private function bodies ---------------------------------------------------*/
/**
 * @brief  Set rows offset
 * @param  lcd_ctx pointer to the lcd structure
 * @param  row0 address of row0
 * @param  row1 address of row1
 * @param  row2 address of row2
 * @param  row3 address of row3
 * @retval None
 */
static void lcd_set_row_offsets(const hd44780_ctx *context, int8_t row0, int8_t row1, int8_t row2, int8_t row3)
{
    context->data->row_offsets[0] = (uint8_t)row0;
    context->data->row_offsets[1] = (uint8_t)row1;
    context->data->row_offsets[2] = (uint8_t)row2;
    context->data->row_offsets[3] = (uint8_t)row3;
}

/**
 * @brief  Set all datalines as OUTPUT
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
static void lcd_data_dir_out(const hd44780_ctx *context)
{
    gpio_output_configure(context->D7_pin_handle, PIN_MODE_OUTPUT_PUSH_PULL);
    gpio_output_configure(context->D6_pin_handle, PIN_MODE_OUTPUT_PUSH_PULL);
    gpio_output_configure(context->D5_pin_handle, PIN_MODE_OUTPUT_PUSH_PULL);
    gpio_output_configure(context->D4_pin_handle, PIN_MODE_OUTPUT_PUSH_PULL);
}

#if USE_RW == 1
/**
 * @brief  Set all datalines as INPUT
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
static void lcd_data_dir_in(const hd44780_ctx *context)
{
    gpio_input_configure(context->D7_pin_handle, NULL, false);
    gpio_input_configure(context->D6_pin_handle, NULL, false);
    gpio_input_configure(context->D5_pin_handle, NULL, false);
    gpio_input_configure(context->D4_pin_handle, NULL, false);
}
#endif

/**
 * @brief  Send half of a byte on the lines (D4...D7)
 * @param  lcd_ctx pointer to the lcd structure
 * @param  data data to send
 * @retval None
 */
static void lcd_sendHalf(const hd44780_ctx *context, uint8_t data)
{
    if (data & (1 << 0))
        gpio_output_set(context->D4_pin_handle);
    else
        gpio_output_clear(context->D4_pin_handle);
    if (data & (1 << 1))
        gpio_output_set(context->D5_pin_handle);
    else
        gpio_output_clear(context->D5_pin_handle);
    if (data & (1 << 2))
        gpio_output_set(context->D6_pin_handle);
    else
        gpio_output_clear(context->D6_pin_handle);
    if (data & (1 << 3))
        gpio_output_set(context->D7_pin_handle);
    else
        gpio_output_clear(context->D7_pin_handle);
}

#if USE_RW == 1
/**
 * @brief  Read half of a byte from the lines (D4...D7)
 * @param  lcd_ctx pointer to the lcd structure
 * @retval data read
 */
static uint8_t lcd_readHalf(const hd44780_ctx *context)
{
    uint8_t result = 0;

    if (gpio_input_is_active(context->D4_pin_handle))
    {
        result |= (1 << 0);
    }
    if (gpio_input_is_active(context->D5_pin_handle))
    {
        result |= (1 << 1);
    }
    if (gpio_input_is_active(context->D6_pin_handle))
    {
        result |= (1 << 2);
    }
    if (gpio_input_is_active(context->D7_pin_handle))
    {
        result |= (1 << 3);
    }

    return result;
}
#endif

/**
 * @brief  Write byte to the lcd
 * @param  lcd_ctx pointer to the lcd structure
 * @retval data read
 */
static void lcd_write_byte(const hd44780_ctx *context, unsigned char _data)
{
    /* Set pins as OUTPUT */
    lcd_data_dir_out(context);

#if USE_RW == 1
    CLR_RW(context);
#endif

    /* Sending older part of the byte D7...D4 */
    SET_E(context);
    lcd_sendHalf(context, _data >> 4);
    CLR_E(context);

    /* Sending younger part of the byte D3...D0 */
    SET_E(context);
    lcd_sendHalf(context, _data);
    CLR_E(context);

#if USE_RW == 1
    while ((lcd_read_busy_flag(context) & BUSY_BIT))
        ;
#else
    osDelay(1);
#endif
}

#if USE_RW == 1
/**
 * @brief  Read byte from the lcd
 * @param  lcd_ctx pointer to the lcd structure
 * @retval data read
 */
static uint8_t lcd_read_byte(const hd44780_ctx *context)
{
    uint8_t result = 0;
    lcd_data_dir_in(context);

    SET_RW(context);

    /* Reading older part of the byte D7...D4 */
    SET_E(context);
    result = (uint8_t)(lcd_readHalf(context) << 4);
    CLR_E(context);

    /* Reading younger part of the byte D7...D4 */
    SET_E(context);
    result |= lcd_readHalf(context);
    CLR_E(context);

    return result;
}
#endif

#if USE_RW == 1
/**
 * @brief  Check the BUSY flag of the lcd
 * @param  lcd_ctx pointer to the lcd structure
 * @retval data read
 */
static uint8_t lcd_read_busy_flag(const hd44780_ctx *context)
{
    CLR_RS(context);
    return lcd_read_byte(context);
}
#endif

/**
 * @brief  Send command to the lcd
 * @param  lcd_ctx pointer to the lcd structure
 * @param  cmd command to send
 * @retval None
 */
static void lcd_write_cmd(const hd44780_ctx *context, uint8_t cmd)
{
    CLR_RS(context);
    lcd_write_byte(context, cmd);
}

/**
 * @brief  Send data to the lcd
 * @param  lcd_ctx pointer to the lcd structure
 * @param  cmd command to send
 * @retval None
 */
static void lcd_write_data(const hd44780_ctx *context, uint8_t data)
{
    SET_RS(context);
    lcd_write_byte(context, data);
}

///**
// * @brief  Turn ON the lcd power
// * @param  lcd_ctx pointer to the lcd structure
// * @retval None
// */
// void lcd_turn_on(const hd44780_ctx * lcd_ctx) {
//    gpio_output_clear(lcd_ctx->VCC.Port, lcd_ctx->VCC.Pin);
//}
//
///**
// * @brief  Turn OFF the lcd power
// * @param  lcd_ctx pointer to the lcd structure
// * @retval None
// */
// void lcd_turn_off(const hd44780_ctx * lcd_ctx) {
//    gpio_output_set(lcd_ctx->VCC.Port, lcd_ctx->VCC.Pin);
//}

/**
 * @brief  Send single char to the lcd as argument.
 *          8 custom defined chars are send using codes from 0x80 to 0x87
 *          instead of 0x00 to 0x07
 * @param  lcd_ctx pointer to the lcd structure
 * @param  c char to send
 * @retval None
 */
void lcd_char(const hd44780_ctx *context, char c)
{
    lcd_write_data(context, (c >= 0x80 && c <= 0x87) ? (c & 0x07) : c);
}

/**
 * @brief  Send string to the lcd as argument.
 * @param  lcd_ctx pointer to the lcd structure
 * @param  c char to send
 * @retval None
 */
void lcd_str(const hd44780_ctx *context, char *str)
{
    register char sign;
    while ((sign = *(str++)))
        lcd_char(context, sign);
}

/**
 * @brief  Send decimal value to the lcd as argument.
 * @param  lcd_ctx pointer to the lcd structure
 * @param  val value to send
 * @retval None
 */
void lcd_int(const hd44780_ctx *context, int val)
{
    char bufor[17];
    lcd_str(context, itoa(val, bufor, 10));
}

/**
 * @brief  Send hex value to the lcd as argument.
 * @param  lcd_ctx pointer to the lcd structure
 * @param  val value to send
 * @retval None
 */
void lcd_hex(const hd44780_ctx *context, uint32_t val)
{
    char bufor[17];
    lcd_str(context, itoa((int)val, bufor, 16));
}

/**
 * @brief  Defines custom sign in the lcd CGRAM memory
 * @param  lcd_ctx pointer to the lcd structure
 * @param  number number of the sign in CGRAM memory - from 0x80 to 0x87
 * @param  sign_def pointer to the array that contains 7 bytes defining the sign
 * @retval None
 */
void lcd_defchar(const hd44780_ctx *context, uint8_t number, uint8_t *sign_def)
{
    register uint8_t i, c;
    lcd_write_cmd(context, (uint8_t)((uint8_t)64U + (uint8_t)((number & 0x07) * 8U)));
    for (i = 0; i < 8; i++)
    {
        c = *(sign_def++);
        lcd_write_data(context, c);
    }
}

/**
 * @brief  Set cursor in desired Y (row) and  X(column) position.
 *          Y = from 0 to 3
 *          X = from 0 to n
 *          Function takes care of DDRAM addresses in
 *          different dipslays (basis on their row count)
 * @param  lcd_ctx pointer to the lcd structure
 * @param  row position in rows
 * @param  col position in cols
 * @retval None
 */
void lcd_set_cursor(const hd44780_ctx *context, uint8_t col, uint8_t row)
{

    uint8_t max_lines;

    max_lines = ARRAY_SIZE(context->data->row_offsets);
    if (row >= max_lines)
    {
        row = (uint8_t)(max_lines - 1); /* Count rows starting w/0 */
    }
    if (row >= context->data->cfg_rows)
    {
        row = (uint8_t)(context->data->cfg_rows - 1); /* Count rows starting w/0 */
    }
    lcd_write_cmd(context, (uint8_t)(LCD_SET_DDRAM_ADDR | (col + context->data->row_offsets[row])));
}

/**
 * @brief  Clears the screen
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_clear(const hd44780_ctx *context)
{
    lcd_write_cmd(context, LCD_CLEAR_DISPLAY);

#if USE_RW == 0
    osDelay(5);
#endif
}

/**
 * @brief  Moves cursor to the start position
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_home(const hd44780_ctx *context)
{
    lcd_write_cmd(context, LCD_RETURN_HOME);

#if USE_RW == 0
    osDelay(5);
#endif
}

/**
 * @brief  Turns on the Display
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_display_on(const hd44780_ctx *context)
{
    context->data->disp_cntl |= LCD_DISPLAY_ON;
    lcd_write_cmd(context, LCD_DISPLAY_CONTROL | context->data->disp_cntl);
}

/**
 * @brief  Turns on the Display
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_display_off(const hd44780_ctx *context)
{
    context->data->disp_cntl &= (uint8_t)~LCD_DISPLAY_ON;
    lcd_write_cmd(context, LCD_DISPLAY_CONTROL | context->data->disp_cntl);
}

/**
 * @brief  Turns on the cursor
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_cursor_on(const hd44780_ctx *context)
{

    context->data->disp_cntl |= LCD_CURSOR_ON;
    lcd_write_cmd(context, LCD_DISPLAY_CONTROL | context->data->disp_cntl);
}

/**
 * @brief  Turns off the cursor
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_cursor_off(const hd44780_ctx *context)
{
    context->data->disp_cntl &= (uint8_t)~LCD_CURSOR_ON;
    lcd_write_cmd(context, LCD_DISPLAY_CONTROL | context->data->disp_cntl);
}

/**
 * @brief  Turns on blinking cursor
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_blink_on(const hd44780_ctx *context)
{
    context->data->disp_cntl |= LCD_BLINK_ON;
    lcd_write_cmd(context, LCD_DISPLAY_CONTROL | context->data->disp_cntl);
}

/**
 * @brief  Turns off blinking cursor
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_blink_off(const hd44780_ctx *context)
{
    context->data->disp_cntl &= (uint8_t)~LCD_BLINK_ON;
    lcd_write_cmd(context, LCD_DISPLAY_CONTROL | context->data->disp_cntl);
}

/**
 * @brief  Scroll the display left without changing the RAM
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_scroll_left(const hd44780_ctx *context)
{
    lcd_write_cmd(context, LCD_CURSOR_SHIFT | LCD_DISPLAY_MOVE | LCD_MOVE_LEFT);
}

/**
 * @brief  Scroll the display right without changing the RAM
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_scroll_right(const hd44780_ctx *context)
{
    lcd_write_cmd(context, LCD_CURSOR_SHIFT | LCD_DISPLAY_MOVE | LCD_MOVE_RIGHT);
}

/**
 * @brief  Text that flows from left to right
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_left_to_right(const hd44780_ctx *context)
{
    context->data->disp_mode |= LCD_ENTRY_LEFT;
    lcd_write_cmd(context, LCD_ENTRY_MODE_SET | context->data->disp_cntl);
}

/**
 * @brief  Text that flows from left to right
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_right_to_left(const hd44780_ctx *context)
{
    context->data->disp_mode &= (uint8_t)~LCD_ENTRY_LEFT;
    lcd_write_cmd(context, LCD_ENTRY_MODE_SET | context->data->disp_cntl);
}

/**
 * @brief  Right justify text from the cursor location
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_justify_right(const hd44780_ctx *context)
{
    context->data->disp_mode |= LCD_ENTRY_SHIFT_INCREMENT;
    lcd_write_cmd(context, LCD_ENTRY_MODE_SET | context->data->disp_cntl);
}

/**
 * @brief  Left justify text from the cursor location
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_justify_left(const hd44780_ctx *context)
{
    context->data->disp_mode &= (uint8_t)~LCD_ENTRY_SHIFT_INCREMENT;
    lcd_write_cmd(context, LCD_ENTRY_MODE_SET | context->data->disp_cntl);
}

/**
// * @brief  Controls lcd's backlight.
// * @param  lcd_ctx pointer to the lcd structure
// * @param  state final state of the lcd. It could be ON or OFF.
// * @param  time time in [ms] consumed on change of the state. It should be multiple of 50[ms].
// *          Possible values: 0 for immediate change of the state
// *          >100 for smooth transition. Cannot be smaller than 100!
// * @retval None
// */
// void lcd_backlight(const hd44780_ctx * lcd_ctx, uint8_t state, uint16_t time) {
//     if (time > 0) {
//         /* Going to final state step by step */
//         uint8_t cnt = 0;
//         if (state == OFF) {
//             cnt = PWM_lcd_ON;
//         } else {
//             cnt = PWM_lcd_OFF;
//         }
//         uint16_t cnt1; /* How long delays should be */
//         uint16_t cnt2; /* How often should be additional increase
//          of the counter*/
//         uint16_t tmp_cnt = 0; /* Temporary counter */
//         if (time >= PWM_FREQUENCY) {
//             cnt1 = time / PWM_FREQUENCY;
//             if (time % PWM_FREQUENCY) {
//                 cnt2 = PWM_FREQUENCY / (time % PWM_FREQUENCY);
//             } else {
//                 cnt2 = 0;
//             }
//
//             while (time) {
//                 if (cnt2) {
//                     if ((++tmp_cnt % cnt2) == 0) {
//                         if (time - cnt1 < 0) {
//                             time = 0;
//                         } else {
//                             time--;
//                         }
//                     }
//                 }
//
//                 if (state == OFF) {
//                     if (cnt++ > PWM_lcd_OFF) {
//                         cnt = PWM_lcd_OFF;
//                     }
//                 } else {
//                     if (cnt-- == 0) {
//                         cnt = PWM_lcd_ON;
//                     }
//                 }
//                 PWM_set_dutyCycle(lcd_ctx->Backlight, cnt);
//                 osDelay(cnt1);
//                 if (time - cnt1 < 0) {
//                     time = 0;
//                 } else {
//                     time -= cnt1;
//                 }
//             }
//         }
//
//     } else {
//         /* Going to final state immediately */
//         if (state == ON) {
//             PWM_set_dutyCycle(lcd_ctx->Backlight, PWM_lcd_ON);
//         } else {
//             PWM_set_dutyCycle(lcd_ctx->Backlight, PWM_lcd_OFF);
//         }
//     }
// }

/**
 * @brief  Initialise lcd display
 * @param  lcd_ctx pointer to the lcd structure
 * @retval None
 */
void lcd_init(hd44780_ctx *context, struct lcd_pins *pins, uint8_t cols, uint8_t rows, uint8_t dotsize)
{

    /* GPIO configure */
    gpio_pin_init(pins->D7, &(context->D7_pin_handle));
    gpio_pin_init(pins->D6, &(context->D6_pin_handle));
    gpio_pin_init(pins->D5, &(context->D5_pin_handle));
    gpio_pin_init(pins->D4, &(context->D4_pin_handle));
    gpio_pin_init(pins->RS, &(context->RS_pin_handle));
    gpio_pin_init(pins->RW, &(context->RW_pin_handle));
    gpio_pin_init(pins->E, &(context->E_pin_handle));

    /* Turn ON the lcd voltage */
    //    lcd_turn_on(lcd_ctx);

    SET_RS(context);
    SET_E(context);

#if USE_RW == 1
    SET_RW(context);
#else
    CLR_RW(context);
#endif

    //    PWM_init(lcd_ctx->Backlight);

    //    PWM_set_dutyCycle(lcd_ctx->Backlight, 20);

    if (rows > 1)
    {
        context->data->disp_func |= LCD_2_LINE;
    }
    context->data->cfg_rows = rows;
    context->data->cfg_cols = cols;

    lcd_set_row_offsets(context, 0x00, 0x40, (int8_t)(0x00 + cols), (int8_t)(0x40 + cols));

    /* For 1 line displays, a 10 pixel high font looks OK */
    if ((dotsize != LCD_5x8_DOTS) && (rows == 1U))
    {
        context->data->disp_func |= LCD_5x10_DOTS;
    }

    /* SEE PAGE 45/46 FOR INITIALIZATION SPECIFICATION!
     * according to datasheet, we need at least 40ms after power rises
     * above 2.7V before sending commands. Arduino can turn on way
     * before 4.5V so we'll wait 50
     */
    osDelay(50);
    CLR_E(context);
    CLR_RS(context);

#if USE_RW == 1
    CLR_RW(context);
#endif

    /* We are unable to use busy flag now */
    /* Set 4bit interface */
    /* 1st try */
    SET_E(context);
    lcd_sendHalf(context, 0x03);
    CLR_E(context);
    osDelay(5);

    /* 2nd try */
    SET_E(context);
    lcd_sendHalf(context, 0x03);
    CLR_E(context);
    osDelay(1);

    /* 3rd try */
    SET_E(context);
    lcd_sendHalf(context, 0x03);
    CLR_E(context);
    osDelay(1);

    /* Set 4bit interface */
    SET_E(context);
    lcd_sendHalf(context, 0x02);
    CLR_E(context);
    osDelay(1);

    /* finally, set # lines, font size, etc. */
    lcd_write_cmd(context, (LCD_FUNCTION_SET | context->data->disp_func));

    /* turn the display on with no cursor or blinking default */
    context->data->disp_cntl = LCD_DISPLAY_ON | LCD_CURSOR_OFF;
    lcd_display_on(context);

    /* Initialize to default text direction */
    context->data->disp_mode = LCD_ENTRY_LEFT;

    /* set the entry mode */
    lcd_write_cmd(context, LCD_ENTRY_MODE_SET | context->data->disp_mode);

    /* clear it off */
    lcd_clear(context);
    //    char tmp[] = "dupa";
    //    lcd_str(context, tmp);
    /* Display is ready. We can now turn on the backlight */
    //    PWM_enable(lcd_ctx->Backlight);
}
