/*
 * int_flash.c
 *
 *  Created on: 29.08.2019
 *      Author: Kamil �azowski
 */

/* Private includes ----------------------------------------------------------*/
// #include "main.h"
#include "flash.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

bool flash_erase(uint32_t addr, uint32_t size)
{
    (void)(addr);
    (void)(size);
    return 0;
}

bool flash_program(uint32_t addr, const uint8_t *p_data, uint32_t size)
{
    (void)(addr);
    (void)(p_data);
    (void)(size);
    return 0;
}

bool flash_read(uint32_t addr, uint8_t *p_data, uint32_t size)
{
    (void)(addr);
    (void)(p_data);
    (void)(size);
    return false;
}
