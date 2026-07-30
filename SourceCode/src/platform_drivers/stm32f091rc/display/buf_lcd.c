/*
 * buf_lcd.c
 *
 *  Created on: 04-02-2020
 *      Author: Kamil Lazowski
 */
/* Private includes ----------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// #include "Debug.h"
#include "FreeRTOS.h"
#include "buf_lcd.h"
#include "cmsis_os.h"
#include "display.h"
#include "hd_44780.h"
#include "layers.h"
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define DISPLAY_MAX_OBJ_CNT_ON_SCREEN 16

#define TRANSPARENT_CHAR '^'
#define MAX_BULLETS DISPLAY_MAX_OBJ_CNT_ON_SCREEN

/* Private macro -------------------------------------------------------------*/
#define AT(y, x) ((y * COLS) + x)

/* Private variables ---------------------------------------------------------*/

hd_volatile display_data = {
    /* Display properties */
    .disp_func = LCD_4BIT_MODE | LCD_2_LINE | LCD_5x8_DOTS,
    .disp_cntl = 0,
    .disp_mode = 0,
    .cfg_rows = 4,
    .cfg_cols = 20,
    .row_offsets = {0x00, 0x00, 0x00, 0x00},
};
hd44780_ctx lcd_ctx = {.data = &display_data};

uint8_t buf_y; /* holds y cursor position */
uint8_t buf_x; /* holds x cursor position */

char hd_buf[ROWS * COLS]; /* main LCD buffer */

char *active_buf = hd_buf; /* Pointer of the active buffer */

TWIN *barrel[MAX_BULLETS] = {0}; /* Holds layers */
struct current_cursor_position
{
    uint8_t x;
    uint8_t y;
};

struct current_cursor_position cursor_position = {0, 0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/**
 * @brief  Create object
 * @param bf pointer to the context
 * @param x x coordinate of the layer
 * @param y y coordinate of the layer
 * @param width width of the layer
 * @param height height of the layer
 * @param visible states if the layer has to be visible (1) or not (0)
 * @param event pointer to the event function.
 * 		Value: NULL in case of typical layer (i.e object is A_TEMP)
 * 				specific function if layer has no object, but performs
 * 				specific things.
 * @retval number o the object in the object array
 */
int8_t LCD_BUF_create_obj(TWIN *bf, uint8_t x, uint8_t y, uint8_t width, uint8_t height, uint8_t visible,
                          uint8_t is_editable, void (*event)(void *layer), void *context)
{
    uint8_t i;
    for (i = 0; i < MAX_BULLETS; i++)
    {
        if (!barrel[i])
        {
            bf->x = (int8_t)x;
            bf->y = (int8_t)y;
            bf->width = width;
            bf->height = height;

            /* If event for that layer is unspecific - assign it.
             * Otherwise (if input is NULL) assign typical function
             *i.e to draw temperature */
            if (event)
            {
                bf->EVENT = event;
            }
            bf->context = context;
            bf->is_editable = is_editable;
            //			else {
            //				bf->EVENT = LCD_LAYER_assign_event(bf->obj->type);
            //			}

            bf->visible = visible;
            bf->buf = (char *)pvPortMalloc((size_t)(bf->width * bf->height));
            if (bf->buf == NULL)
            {
                /* Failed to allocate memory */
                return (-1);
            }
            active_buf = bf->buf;
            LCD_BUF_cls(bf->buf, (uint8_t)(bf->width * bf->height));
            break;
        }
    }
    if (MAX_BULLETS == i)
    {
        return -1;
    }
    //		i = -1;
    return (int8_t)i;
}

/**
 * @brief  Copies buffer to main buffer - verify this description
 * @param  w pointer to the buffer
 * @retval None
 */
static void LCD_BUF_copy_buf(TWIN *w)
{
    int8_t x, y;
    uint8_t ax, ay;
    active_buf = hd_buf;

    for (y = w->y, ay = 0; y < w->y + w->height; y++, ay++)
    {
        LCD_BUF_locate((uint8_t)y, (uint8_t)w->x);
        for (x = w->x, ax = 0; x < w->x + w->width; x++, ax++)
        {
            if (x < COLS && y < ROWS && x >= 0 && y >= 0)
            {
                if (w->buf[AT(ay, ax)] != TRANSPARENT_CHAR)
                    LCD_BUF_put_char(hd_buf, w->buf[AT(ay, ax)]);
                else
                    buf_x++;
            }
        }
    }
}

/**
 * @brief  Assign properties of the LCD screen from main display_screen context
 * @param  screen pointer to display screen context	(EXTERNAL - UPPER LAYER)
 * @param  lcd_screen pointer to lcd screen context (INTERNAL)
 * @retval None
 */
// static void LCD_BUF_assign_screen_properties(disp_screen * screen,
//		LCD_screen * lcd_screen) {
//	/* It is main menu screen */
//	for (uint8_t i = 0; i < screen->no_of_obj; i++) {
//		lcd_screen->layer_tab[i]->obj = screen->obj_tab[i];
//	}
// }

/**
 * @brief  Copies object from one layer to another
 * @param  layer_source leyer from object has to be copied out
 * @param  layer_dest leyer where object has to be copied in
 * @retval None
 */
// static void LCD_BUF_copy_obj(TWIN * layer_dest, TWIN * layer_source) {
//	layer_dest->obj = layer_source->obj;
// }

/**
 * @brief Check of the layer is visible
 * @param layer pointer to the layer
 * @retval 0 if not visible or 1 if visible
 */
static uint8_t LCD_BUF_is_visible(TWIN *layer)
{
    if (layer)
    {
        return layer->visible;
        //		/* If there is any object assigned - it has higher importance
        //		 * than interanal variable */
        //		if (layer->obj) {
        //			return layer->obj->visible;
        //		} else {
        //			return layer->visible;
        //		}
    }
    return 0;
}
/**
 * @brief  Updates main buffer by launching all events from the barrel.
 * @param None
 * @retval None
 */
static void LCD_BUF_update_buffer(void)
{
    uint8_t idx = 0;

    active_buf = hd_buf;
    LCD_BUF_cls(NULL, 0); /* Fill main buffer with spaces */
                          //	DEFCHAR_clear_buffer(); /* Clear buffer with custom chars */
    while (idx < MAX_BULLETS)
    { /* Check all buffers/layers one by one */
        if (barrel[idx])
        { /* If layer is in the array of the layers */
            if (LCD_BUF_is_visible(barrel[idx]))
            {
                if (barrel[idx]->EVENT)
                {
                    /* If there is an event assigned - do it now */
                    barrel[idx]->EVENT(barrel[idx]);

                    /* If the layer has to be visible - show it */
                    LCD_BUF_copy_buf(barrel[idx]);
                }
            }
        }
        idx++; /* Increase the layer count */
    }
}

/**
 * @brief Find proper LCD_screen context based on input screen
 * @param screen pointer to the screen context
 * @retval pointer to LCD screen or NULL in case of failure
 */
// static LCD_screen * LCD_BUF_get_screen_context(disp_screen * screen) {
//	if (memcmp(screen->name, "WELCOME SCREEN", sizeof("WELCOME SCREEN")) == 0) {
//		return &lcd_welcome_screen;
//	} else if (memcmp(screen->name, "MAIN SCREEN", sizeof("MAIN SCREEN"))
//			== 0) {
//		return &lcd_main_screen;
//	} else {
//		/* screen not found */
//		return (NULL);
//	}
// }

/**
 * @brief Load layers to the barrel
 * @param screen pointer to the screen context
 * @retval 0 in case of success or error in case of failure
 */
static int LCD_BUF_load_layers_to_barrel(const LCD_screen *screen)
{
    if (screen)
    {
        for (uint8_t i = 0; i < screen->layer_count; i++)
        {
            barrel[i] = screen->layer_tab[i];
        }
        return 0;
    }
    else
    {
        return (-1);
    }
}

/**
 * @brief Sends buffer to the LCD
 * @param None
 * @retval None
 */
static inline void LCD_BUF_send_buf_to_lcd(char *buff)
{
    register uint8_t y, x = 0;
    for (y = 0; y < ROWS; y++)
    {
        lcd_set_cursor(&lcd_ctx, 0, y);
        for (x = 0; x < COLS; x++)
            lcd_char(&lcd_ctx, buff[AT(y, x)]);
    }
    /* Restore previous cursor position. */
    lcd_set_cursor(&lcd_ctx, cursor_position.x, cursor_position.y);
}

static inline void LCD_BUF_anim_spawn_up_to_down(void)
{
    /* 1. Update content of the buffer */
    LCD_BUF_update_buffer();

    /* 2. Update chars in CGRAM on LCD */
    //	DEFCHAR_update_cgram();

    /* Create temporary buffer*/
    char tmp_buf[ROWS * COLS]; /* main LCD buffer */
    active_buf = tmp_buf;
    LCD_BUF_cls(active_buf, sizeof(tmp_buf));

    for (uint8_t i = 0; i < ROWS; i++)
    {
        memcpy(&active_buf[i * COLS], &hd_buf[i * COLS], COLS);
        LCD_BUF_send_buf_to_lcd(active_buf);
        osDelay(100);
    }
}

static inline void LCD_BUF_anim_scroll_right_to_left(void)
{
    /* 1. Update content of the buffer */
    LCD_BUF_update_buffer();

    /* 2. Update chars in CGRAM on LCD */
    //	DEFCHAR_update_cgram();

    char tmp_buf[ROWS * COLS] = {' '}; /* main LCD buffer */
    /* Create temporary layer*/
    TWIN tmp_layer = {.y = 0, .x = -COLS, .width = COLS, .height = ROWS, .visible = 1, .buf = tmp_buf, .EVENT = NULL};

    active_buf = tmp_buf;

    memcpy(active_buf, hd_buf, sizeof(hd_buf));
    LCD_BUF_cls(hd_buf, sizeof(hd_buf));

    for (uint8_t i = 0; i < COLS; i++)
    {
        LCD_BUF_copy_buf(&tmp_layer);
        tmp_layer.x++;
        LCD_BUF_send_buf_to_lcd(active_buf);
        osDelay(150);
    }
}

static inline void LCD_BUF_anim_scroll_left_to_right(void)
{
    /* 1. Update content of the buffer */
    LCD_BUF_update_buffer();

    /* 2. Update chars in CGRAM on LCD */
    //	DEFCHAR_update_cgram();

    char tmp_buf[ROWS * COLS] = {' '}; /* main LCD buffer */
                                       /* Create temporary layer*/
    TWIN tmp_layer = {.y = 0, .x = COLS, .width = COLS, .height = ROWS, .visible = 1, .buf = tmp_buf, .EVENT = NULL};

    active_buf = tmp_buf;

    memcpy(active_buf, hd_buf, sizeof(hd_buf));
    LCD_BUF_cls(hd_buf, sizeof(hd_buf));

    for (uint8_t i = 0; i < COLS; i++)
    {
        LCD_BUF_copy_buf(&tmp_layer);
        tmp_layer.x--;
        LCD_BUF_send_buf_to_lcd(active_buf);
        osDelay(150);
    }
}

static inline void LCD_BUF_anim_scroll_down_to_up(void)
{
    /* 1. Update content of the buffer */
    LCD_BUF_update_buffer();

    /* 2. Update chars in CGRAM on LCD */
    //	DEFCHAR_update_cgram();

    char tmp_buf[ROWS * COLS] = {' '}; /* main LCD buffer */
    /* Create temporary layer*/
    TWIN tmp_layer = {.y = ROWS, .x = 0, .width = COLS, .height = ROWS, .visible = 1, .buf = tmp_buf, .EVENT = NULL};

    active_buf = tmp_buf;

    memcpy(active_buf, hd_buf, sizeof(hd_buf));
    LCD_BUF_cls(hd_buf, sizeof(hd_buf));

    for (uint8_t i = 0; i < ROWS; i++)
    {
        LCD_BUF_copy_buf(&tmp_layer);
        tmp_layer.y--;
        LCD_BUF_send_buf_to_lcd(active_buf);
        osDelay(150);
    }
}

static inline void LCD_BUF_anim_scroll_up_to_down(void)
{
    /* 1. Update content of the buffer */
    LCD_BUF_update_buffer();

    /* 2. Update chars in CGRAM on LCD */
    //	DEFCHAR_update_cgram();

    char tmp_buf[ROWS * COLS] = {' '}; /* main LCD buffer */
    /* Create temporary layer*/
    TWIN tmp_layer = {.y = -ROWS, .x = 0, .width = COLS, .height = ROWS, .visible = 1, .buf = tmp_buf, .EVENT = NULL};

    active_buf = tmp_buf;

    memcpy(active_buf, hd_buf, sizeof(hd_buf));
    LCD_BUF_cls(hd_buf, sizeof(hd_buf));

    for (uint8_t i = 0; i < ROWS; i++)
    {
        LCD_BUF_copy_buf(&tmp_layer);
        tmp_layer.y++;
        LCD_BUF_send_buf_to_lcd(active_buf);
        osDelay(150);
    }
}

/* Public function bodies ----------------------------------------------------*/
/**
 * @brief  Initialise buffered LCD driver
 * @param  argument: Not used
 * @retval None
 */
void LCD_BUF_init(struct lcd_pins *pins)
{
    /* Initialise LCD driver */
    lcd_init(&lcd_ctx, pins, COLS, ROWS, 0);
    //	LCD_init(&lcd_ctx, COLS, ROWS, LCD_5x8_DOTS);
    //	LCD_LAYER_init();
    /* Clear buffer */
    LCD_BUF_cls(NULL, 0);
}

/**
 * @brief  Initialise screens of LCD driver
 * @param  screen pointer to the screen context
 * @retval None
 */
// int LCD_BUF_init_screen(LCD_screen * screen) {

//	int8_t ret = 0;
//	if (memcmp(screen->name, "WELCOME SCREEN", sizeof("WELCOME SCREEN")) == 0) {
//		LCD_BUF_assign_screen_properties(screen, &lcd_welcome_screen);
//		LCD_BUF_create_obj(lcd_welcome_screen.layer_tab[0],
//				0, 1, 11, 1, 1,
//				welcome_welcome_text);
//	} else if (memcmp(screen->name, "MAIN SCREEN", sizeof("MAIN SCREEN"))
//			== 0) {
//		LCD_BUF_assign_screen_properties(screen, &lcd_main_screen);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[MT_TEMP],
//				0, 1, 7, 1, 1,
//				NULL);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[MT_VOLUME],
//				0, 2, 7, 1, 1,
//				NULL);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[BT_TEMP],
//				12, 1, 7, 1, 1,
//				NULL);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[BT_VOLUME],
//				12, 2, 7, 1, 1,
//				NULL);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[STATUS],
//				0, 3, 9, 1, 1,
//				NULL);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[PROGRESS],
//				10, 3, 10, 1, 1,
//				NULL);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[MT_VOLUME_GRAPH],
//				7, 1, 2, 2, 1,
//				main_mt_volume_graph);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[BT_VOLUME_GRAPH],
//				10, 1, 2, 2, 1,
//				main_bt_volume_graph);
//
//		/* Layers that are just simple text or decors */
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[MT_NAME],
//				0, 0, 9, 1, 1,
//				main_mt_name);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[BT_NAME],
//				10, 0, 10, 1, 1,
//				main_bt_name);
//		LCD_BUF_create_obj(lcd_main_screen.layer_tab[VERTICAL_COLUMN],
//				9, 0, 1, 4, 1,
//				main_vertical_column);
//
//		/* Assign variables to the graphs */
//		LCD_BUF_copy_obj(lcd_main_screen.layer_tab[MT_VOLUME_GRAPH],
//				lcd_main_screen.layer_tab[MT_VOLUME]);
//		LCD_BUF_copy_obj(lcd_main_screen.layer_tab[BT_VOLUME_GRAPH],
//				lcd_main_screen.layer_tab[BT_VOLUME]);
//	} else {
//		/* Layer not found */
//		ret = -1;
//	}
//	return ret;
//}

/**
 * @brief Set desired screen
 * @param screen pointer to the screen context
 * @retval None
 */
int LCD_BUF_set_screen(const LCD_screen *screen, uint8_t anim_mode)
{
    /* Load all layers for desired screen to the barrel */
    if (screen)
    {
        if (LCD_BUF_load_layers_to_barrel(screen) != 0)
        {
            return (-1);
        }
    }
    else
    {
        return (-1);
    }

    /* Perform animation */
    switch (anim_mode)
    {
    case SPAWN_UP_TO_DOWN:
        LCD_BUF_anim_spawn_up_to_down();
        break;
    case DOWN_TO_UP:
        LCD_BUF_anim_scroll_down_to_up();
        break;
    case UP_TO_DOWN:
        LCD_BUF_anim_scroll_up_to_down();
        break;
    case LEFT_TO_RIGHT:
        LCD_BUF_anim_scroll_left_to_right();
        break;
    case RIGHT_TO_LEFT:
        LCD_BUF_anim_scroll_right_to_left();
        break;
    case RANDOM:
        break;
    case NONE:
        LCD_BUF_refresh();
        break;
    default:
        break;
    }

    return 0;
}

/**
 * @brief  Barrel event - responsible for displaying things on the LCD
 * @param all Number of layers to handle
 * @retval None
 */
void LCD_BUF_refresh(void)
{

    /* 1. Update content of the buffer */
    LCD_BUF_update_buffer();

    /* 2. Update chars in CGRAM on LCD */
    //	DEFCHAR_update_cgram();

    /* 3. Display on the screen the buffer from RAM */
    LCD_BUF_send_buf_to_lcd(hd_buf);
}

/**
 * @brief  Clears the buffer
 * @param None
 * @retval None
 */
void LCD_BUF_cls(char *buff, uint8_t size)
{
    if (buff)
    {
        memset(buff, ' ', size);
    }
    else
    {
        memset(active_buf, ' ', ROWS * COLS);
    }

    buf_y = 0;
    buf_x = 0;
}

/**
 * @brief  Sets cursor of the screen/buffer
 * @param y y position on the screen/buffer
 * @param x x position on the screen/buffer
 * @retval None
 */
void LCD_BUF_locate(uint8_t y, uint8_t x)
{
    if (y < ROWS)
        buf_y = y;
    else
        buf_y = 0;
    if (x < COLS)
        buf_x = x;
    else
        buf_x = 0;
}

uint8_t LCD_BUF_is_layer_editable(TWIN *layer)
{
    return layer->is_editable;
}

void LCD_BUF_locate_cursor_on_layer(TWIN *layer)
{
    cursor_position.x = (uint8_t)layer->x;
    cursor_position.y = (uint8_t)layer->y;
    lcd_set_cursor(&lcd_ctx, cursor_position.x, cursor_position.y);
    lcd_cursor_on(&lcd_ctx);
}
// static TWIN* get_first_editable_layer(LCD_screen *screen)
//{
//     for (uint8_t layer_index = 0; layer_index < screen->layer_count; layer_index++) {
//         if (screen->layer_tab[layer_index]->is_editable) {
//             return screen->layer_tab[layer_index];
//         }
//     }
//     return NULL;
// }
//
// void LCD_BUF_put_coursor_on_first_editable_layer(LCD_screen *screen)
//{
//     TWIN *layer_with_cursor = get_first_editable_layer(screen);
//     if (layer_with_cursor != NULL) {
//         cursor_position.x = (uint8_t)layer_with_cursor->x;
//         cursor_position.y = (uint8_t)layer_with_cursor->y;
//         lcd_set_cursor(&lcd_ctx, cursor_position.x, cursor_position.y);
//         lcd_cursor_on(&lcd_ctx);
//     }
// }
//
// static TWIN* get_next_editable_layer(LCD_screen *screen)
//{
//     for (uint8_t layer_index = 0; layer_index < screen->layer_count; layer_index++) {
//         if ((screen->layer_tab[layer_index]->is_editable) &&
//             (screen->layer_tab[layer_index]->x == cursor_position.x) &&
//             (screen->layer_tab[layer_index]->y == cursor_position.y)) {
//             /* Check till end of the layers*/
//             for (uint8_t layer = (uint8_t)(layer_index + 1); layer < screen->layer_count; layer++) {
//                 if (screen->layer_tab[layer]->is_editable) {
//                     return screen->layer_tab[layer];
//                 }
//             }
//             /* If not found, check from the beginning.*/
//             for (uint8_t layer = 0; layer < layer_index; layer++) {
//                 if (screen->layer_tab[layer]->is_editable) {
//                     return screen->layer_tab[layer];
//                 }
//             }
//         }
//     }
//     return NULL;
// }
//
// static TWIN* get_previous_editable_layer(LCD_screen *screen)
//{
//     for (uint8_t layer_index = 0; layer_index < screen->layer_count; layer_index++) {
//         if ((screen->layer_tab[layer_index]->is_editable) &&
//             (screen->layer_tab[layer_index]->x == cursor_position.x) &&
//             (screen->layer_tab[layer_index]->y == cursor_position.y)) {
//             /* If not found, check from the beginning.*/
//             for (int8_t layer = (int8_t)(layer_index - 1); layer >= 0; layer--) {
//                 if (screen->layer_tab[layer]->is_editable) {
//                     return screen->layer_tab[(uint8_t)layer];
//                 }
//             }
//             /* Check till end of the layers*/
//             for (uint8_t layer = screen->layer_count; layer > layer_index; layer--) {
//                 if (screen->layer_tab[layer]->is_editable) {
//                     return screen->layer_tab[layer];
//                 }
//             }
//
//         }
//     }
//     return NULL;
// }
//
// void LCD_BUF_move_cursor_to_next_editable_layer(LCD_screen *screen)
//{
//     TWIN *layer_with_cursor = get_next_editable_layer(screen);
//     if (layer_with_cursor != NULL) {
//         cursor_position.x = (uint8_t) layer_with_cursor->x;
//         cursor_position.y = (uint8_t) layer_with_cursor->y;
//         lcd_set_cursor(&lcd_ctx, cursor_position.x, cursor_position.y);
//         lcd_cursor_on(&lcd_ctx);
//     }
// }
//
// void LCD_BUF_move_cursor_to_previous_editable_layer(LCD_screen *screen)
//{
//     TWIN *layer_with_cursor = get_previous_editable_layer(screen);
//     if (layer_with_cursor != NULL) {
//         cursor_position.x = (uint8_t) layer_with_cursor->x;
//         cursor_position.y = (uint8_t) layer_with_cursor->y;
//         lcd_set_cursor(&lcd_ctx, cursor_position.x, cursor_position.y);
//         lcd_cursor_on(&lcd_ctx);
//     }
// }

/**
 * @brief  Fills the buffer/screen with desired sign
 * @param sign sign that will be used to fill the buffer/screen
 * @param len amount of sign used to fill the buffer
 * @retval None
 */
void LCD_BUF_fill(char sign, uint8_t len)
{
    uint8_t i;
    for (i = 0; i < len; i++)
        LCD_BUF_put_char(active_buf, sign);
}

/**
 * @brief Send single char to desired buffer
 * @param wbf buffer where sign has to be stored
 * @param z char to send
 * @retval None
 */
void LCD_BUF_put_char(char *wbf, char z)
{

    //    if ((buf_y >= (int8_t) 0) && (buf_y < (int8_t) ROWS) && (buf_x >= 0) && (buf_x < (int8_t) COLS)) {
    if ((buf_y < (int8_t)ROWS) && (buf_x < (int8_t)COLS))
    {
        wbf[AT(buf_y, buf_x)] = z;
        buf_x++;
    }
}

/**
 * @brief Send few chars to desired buffer
 * @param wbf buffer where sign has to be stored
 * @param z char to send
 * @retval None
 */
void LCD_BUF_put_str_ex(char *s, uint8_t len)
{
    while (len--)
        LCD_BUF_put_char(active_buf, *s++);
}

/**
 * @brief Send string from RAM memory to active buffer
 * @param wbf buffer where sign has to be stored
 * @param z char to send
 * @retval None
 */
void LCD_BUF_put_str(char *s)
{
    while (*s)
        LCD_BUF_put_char(active_buf, *s++);
}

/**
 * @brief Send HEX to the buffer
 * @param val value to send
 * @retval None
 */
void LCD_BUF_put_hex(int val)
{
    char bufor[17];
    LCD_BUF_put_str(itoa(val, bufor, 16));
}

/**
 * @brief Send decimal value to the buffer
 * @param val value to send
 * @retval None
 */
void LCD_BUF_put_int(int val)
{
    char bufor[17];
    LCD_BUF_put_str(itoa(val, bufor, 10));
}

/**
 * @brief Send decimal value with delimeter to the buffer.
 *  I.e val = 323, delimeter = 1, value displayed is 32,3
 * @param val value to send
 * @param delimeter How many digits the value is shifted.
 * @retval None
 */
void LCD_BUF_put_var(int val, uint8_t delimeter)
{
    char bufor[17];
    uint32_t mul = 1;

    /* Compute multiplier */
    for (uint8_t i = 0; i < delimeter; i++)
    {
        mul *= 10;
    }
    uint32_t high_val = (uint32_t)((uint32_t)val / mul);
    uint32_t low_val = (uint32_t)((uint32_t)val % mul);

    if (high_val < 10)
    {
        /* If value is lower than 10 - we should add
         * a space to right allign the digits */
        sprintf(bufor, " %d,%d", (int)high_val, (int)low_val);
    }
    else if (high_val > 99)
    {
        /* If value exceeds two digits, reduce accuracy
         * to three signs without delimeter */
        sprintf(bufor, " %d", (int)high_val);
    }
    else
    {
        sprintf(bufor, "%d,%d", (int)high_val, (int)low_val);
    }
    LCD_BUF_put_str(bufor);
}
