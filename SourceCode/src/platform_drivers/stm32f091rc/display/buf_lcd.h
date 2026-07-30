/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef BUF_LCD_H_
#define BUF_LCD_H_
/* Private includes ----------------------------------------------------------*/
// #include "Common.h"
#include "display.h"

/* Private define ------------------------------------------------------------*/
#define ROWS 2  /* Defines how many rows has LCD */
#define COLS 16 /* Defines how many cols has LCD */
#define DISPLAY_MAX_OBJ_CNT_ON_SCREEN 16
enum
{
    DOWN_TO_UP,
    SPAWN_UP_TO_DOWN,
    UP_TO_DOWN,
    LEFT_TO_RIGHT,
    RIGHT_TO_LEFT,
    RANDOM,
    NONE
};
/* Private typedef -----------------------------------------------------------*/
typedef struct
{
    void *context;
    void (*EVENT)(void *layer);
    int8_t y;
    int8_t x;
    uint8_t width;
    uint8_t height;
    uint8_t visible;
    char *buf;
    uint8_t is_editable;

} TWIN;

typedef struct
{
    TWIN *layer_tab[DISPLAY_MAX_OBJ_CNT_ON_SCREEN];
    uint8_t layer_count;
} LCD_screen;

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
extern char hd_buf[ROWS * COLS];
extern char *active_buf;

/* Private function prototypes -----------------------------------------------*/
void LCD_BUF_init(struct lcd_pins *pins);
// int LCD_BUF_init_screen(LCD_screen * screen);
int8_t LCD_BUF_create_obj(TWIN *bf, uint8_t x, uint8_t y, uint8_t width, uint8_t height, uint8_t visible,
                          uint8_t is_editable, void (*event)(void *layer), void *context);
int LCD_BUF_set_screen(const LCD_screen *screen, uint8_t anim_mode);
void LCD_BUF_refresh(void);

void LCD_BUF_cls(char *buff, uint8_t size);
void LCD_BUF_fill(char znak, uint8_t len);
void LCD_BUF_locate(uint8_t y, uint8_t x);

uint8_t LCD_BUF_is_layer_editable(TWIN *layer);
void LCD_BUF_locate_cursor_on_layer(TWIN *layer);
// void LCD_BUF_put_coursor_on_first_editable_layer(LCD_screen * screen);
// void LCD_BUF_move_cursor_to_next_editable_layer(LCD_screen *screen);
// void LCD_BUF_move_cursor_to_previous_editable_layer(LCD_screen *screen);

void LCD_BUF_put_char(char *wbf, char z);
void LCD_BUF_put_str(char *s);
void LCD_BUF_put_str_ex(char *s, uint8_t len);
void LCD_BUF_put_hex(int val);
void LCD_BUF_put_int(int val);
void LCD_BUF_put_var(int val, uint8_t delimeter);

#endif /* BUF_LCD_H_ */
