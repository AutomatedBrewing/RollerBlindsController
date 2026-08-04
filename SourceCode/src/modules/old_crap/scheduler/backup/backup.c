/*
 * backup.c
 *
 *  Created on: 23 Jun 2023
 *      Author: dev
 */
/* Private includes ----------------------------------------------------------*/
#include "backup.h"
#include "flash.h"

#define BKP_FLASH_INTERNAL_PAGE_ALIGN                                                                                  \
    (2048) /* Alignment of the                                                                                         \
              internal Flash memory. */
#define BKP_FLASH_INTERNAL_SIZE                                                                                        \
    (BKP_FLASH_INTERNAL_PAGE_ALIGN) /* Size of internal backup                                                         \
                                       flash memory. */
/* Reserve memory region that is page aligned. User can use whole this memory for backup (2k).
 * This code must be placed in the linker file.
 * .bkp :
 * {
 *   . = ALIGN(2048);
 *   __BKP_START__ = .;
 *   KEEP(*(.bkp));
 *   __BKP_END__ = .;
 *   . = ALIGN(2048);
 * } >FLASH
 */
__attribute__((__section__(".bkp"))) const uint8_t bkp_internal_flash[BKP_FLASH_INTERNAL_SIZE] = {0};

extern char __BKP_START__; /* This variable points to the start of the internal backup flash memory. */
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

bool save_data_to_non_volatile_memory(uint8_t *data, uint32_t size)
{
    bool result;
    result = flash_erase((uint32_t)&__BKP_START__, BKP_FLASH_INTERNAL_SIZE);
    if (result != 0)
    {
        return result;
    }

    result = flash_program_and_verify((uint32_t)&__BKP_START__, data, size);
    return result;
}

bool read_data_from_non_volatile_memory(uint8_t *data, uint32_t size)
{
    return flash_read((uint32_t)&__BKP_START__, data, size);
}
