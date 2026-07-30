#ifndef LAYERS_H_
#define LAYERS_H_
/* Private includes ----------------------------------------------------------*/
#include "buf_lcd.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

extern const LCD_screen monday_screen;
extern const LCD_screen tuesday_screen;
extern const LCD_screen wednesday_screen;
extern const LCD_screen thursday_screen;
extern const LCD_screen friday_screen;
extern const LCD_screen saturday_screen;
extern const LCD_screen sunday_screen;
/* Private function prototypes -----------------------------------------------*/

/* WELCOME SCREEN ------------------------------------------------------------*/
void initialize_monday(void *context);
void initialize_tuesday(void *context);
void initialize_wednesday(void *context);
void initialize_thursday(void *context);
void initialize_friday(void *context);
void initialize_saturday(void *context);
void initialize_sunday(void *context);

#endif /* LAYERS_H_ */
