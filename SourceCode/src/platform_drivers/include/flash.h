/*
 * flash.h
 *
 *  Created on: 23 Jun 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_INCLUDE_FLASH_H_
#define SRC_PLATFORM_DRIVERS_INCLUDE_FLASH_H_

/* Private includes ----------------------------------------------------------*/
#include <stdbool.h>
#include <stdint.h>

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/**
 * @brief  Function erases desired amount of flash memory.
 * @param  addr Start address, from erasing will start.
 * @param  size Length of the erased area in bytes.
 * @retval HAL_ERROR_TIMEOUT Operation timed out.
 *         HAL_SUCCESS       Erased with success.
 */
bool flash_erase(uint32_t addr, uint32_t size);

/**
 * @brief  Function for programming and verifying written data in flash memory.
 * @warning Memory must erased before!
 * @param  addr   Start address, from programming will start.
 * @param  p_data Pointer to the data buffer.
 * @param  size   Length of the data to write.
 * @retval HAL_ERROR_TIMEOUT       Operation timed out.
 *         HAL_ERROR_INVALID_PARAM Data read mismath data written.
 *         HAL_SUCCESS             Data written with success.
 */
bool flash_program_and_verify(uint32_t addr, uint8_t *p_data, uint32_t size);

/**
 * @brief  Function for programming flash memory.
 * @warning Memory must erased before!
 * @param  addr   Start address, from programming will start.
 * @param  p_data Pointer to the data buffer.
 * @param  size   Length of the data to write.
 * @retval HAL_ERROR_TIMEOUT       Operation timed out.
 *         HAL_ERROR_INVALID_PARAM Data read mismath data written.
 *         HAL_SUCCESS             Data written with success.
 */
bool flash_program(uint32_t addr, uint8_t *p_data, uint32_t size);

/**
 * @brief  Function reads data from flash memory and copies them to the buffer.
 * @param  addr   Start address, from reading will start.
 * @param  p_data Pointer to the data buffer.
 * @param  size   Length of the data to read.
 * @retval HAL_SUCCESS             Data written with success.
 */
bool flash_read(uint32_t addr, uint8_t *p_data, uint32_t size);

#endif /* SRC_PLATFORM_DRIVERS_INCLUDE_FLASH_H_ */
