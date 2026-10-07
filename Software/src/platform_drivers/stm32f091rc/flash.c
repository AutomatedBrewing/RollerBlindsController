/*
 * int_flash.c
 *
 *  Created on: 29.08.2019
 *      Author: Kamil �azowski
 */

/* Private includes ----------------------------------------------------------*/
// #include "main.h"
#include "flash.h"
#include "cmsis_os.h"
#include "stm32f0xx.h"
#include <string.h>

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define PAGE_SIZE (2048) /* Page size in bytes. */
#define WRITE_SIZE                                                                                                     \
    (sizeof(uint16_t))                     /* Defines how much data is written                                         \
                                              in one sequence (2 bytes). */
#define FLASH_FKEY1 ((uint32_t)0x45670123) /* Key used to unlock the flash memory. */
#define FLASH_FKEY2 ((uint32_t)0xCDEF89AB) /* Key used to unlock the flash memory. */

/* Timeout values */
#define PAGE_ERASE_TIMEOUT (100)  /* Timeout for erasing single page - value in us. */
#define PAGE_WRITE_TIMEOUT (100)  /* Timeout for writting flash memory - value in us. */
#define PAGE_UNLOCK_TIMEOUT (100) /* Timeout for unlocking flash memory - value in us. */
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/**
 * @brief  Calculates number of iterations needed to handle desired amount of data
 * @param  noOfBytesToHandle    - amount of data to handle
 * @param  dataBlockSize        - size of single block that process is  avaiable to handle
 * @retval number of iterations
 */
static uint32_t flash_no_of_iterations_get(uint32_t size, uint32_t block_size)
{
    uint32_t iterations = (size / block_size);

    if (size % block_size)
    {
        iterations++;
    }

    return iterations;
}

static bool flash_wait_until_ready(uint32_t timeout)
{
    uint32_t tickstart = osKernelGetTickCount();
    while (READ_BIT(FLASH->SR, FLASH_SR_BSY) != 0) /* (1) */
    {
        /* For robust implementation, add here time-out management */
        if ((timeout == 0U) || ((osKernelGetTickCount() - tickstart) > timeout))
        {
            return 1;
        }
    }

    return 0;
}

/**
 * @brief  Unlocks the internal flash memory for write operation.
 * @param  timeout Timeout in [us].
 * @retval 1 Operation timed out.
 *         0       Flash unclocked succesfully.
 */
static bool flash_unlock(uint32_t timeout)
{
    /* (1) Wait till no operation is on going */
    if (flash_wait_until_ready(timeout) != 0)
    {
        return 1;
    }

    /* (2) Check that the Flash is unlocked */
    if ((READ_BIT(FLASH->CR, FLASH_CR_LOCK)) != 0) /* (2) */
    {
        /* (3) Perform unlock sequence */
        WRITE_REG(FLASH->KEYR, FLASH_FKEY1);
        WRITE_REG(FLASH->KEYR, FLASH_FKEY2);
    }

    return 0;
}

/**
 * @brief  Locks the internal flash memory for write operation.
 * @param  None.
 * @retval None.
 */
static void flash_lock(void)
{
    /* Set the LOCK Bit to lock the FLASH Registers access */
    SET_BIT(FLASH->CR, FLASH_CR_LOCK);
}

/**
 * @brief  Writes data to the internal flash memory to a specified address.
 * @param  data    Data to write.
 * @param  addr    Address.
 * @param  timeout Timeout in ms.
 * @retval 1 Operation timed out.
 *         0       Erased with success.
 */
static bool flash_write(uint16_t data, uint32_t addr, uint32_t timeout)
{
    /* (1) Set the PG bit in the FLASH_CR register to enable programming */
    SET_BIT(FLASH->CR, FLASH_CR_PG);

    /* (2) Perform the data write (half-word) at the desired address */
    *(volatile uint16_t *)(addr) = data; /* (2) */

    /* (3) Wait until the BSY bit is reset in the FLASH_SR register */
    if (flash_wait_until_ready(timeout) != 0)
    {
        return 1;
    }

    /* (4) Check the EOP flag in the FLASH_SR register */
    if (READ_BIT(FLASH->SR, FLASH_SR_EOP) != 0) /* (4) */
    {
        /* (5) clear it by software by writing it at 1 */
        SET_BIT(FLASH->SR, FLASH_SR_EOP);
    }

    /* (6) Reset the PG Bit to disable programming */
    CLEAR_BIT(FLASH->CR, FLASH_CR_PG);
    return 0;
}

/**
 * @brief  Erases single page in Flash memory.
 * @param  page_addr Address of the page to erase.
 * @param  timeout   Timeout in us.
 * @retval 1 Operation timed out.
 *         0       Erased with success.
 */
static bool flash_page_erase(uint32_t page_addr, uint32_t timeout)
{

    /* (1) Set the PER bit in the FLASH_CR register to enable page erasing */
    SET_BIT(FLASH->CR, FLASH_CR_PER);

    /* (2) Program the FLASH_AR register to select a page to erase */
    WRITE_REG(FLASH->AR, page_addr);

    /* (3) Set the STRT bit in the FLASH_CR register to start the erasing */
    SET_BIT(FLASH->CR, FLASH_CR_STRT);

    /* (4) Wait until the BSY bit is reset in the FLASH_SR register */
    if (flash_wait_until_ready(timeout) != 0)
    {
        return 1;
    }

    /* (5) Check the EOP flag in the FLASH_SR register */
    if (READ_BIT(FLASH->SR, FLASH_SR_EOP) != 0) /* (5) */
    {
        /* (6) Clear EOP flag by software by writing EOP at 1 */
        SET_BIT(FLASH->SR, FLASH_SR_EOP);
    }
    else
    {
        /* Manage the error cases */
    }

    /* (7) Reset the PER Bit to disable the page erase */
    CLEAR_BIT(FLASH->CR, FLASH_CR_PER);
    return 0;
}

/* Public function prototypes ------------------------------------------------*/

bool flash_erase(uint32_t addr, uint32_t size)
{
    /* Unclock flash memory  */
    if (flash_unlock(PAGE_UNLOCK_TIMEOUT) != 0)
    {
        return 1;
    }

    /* Calculate how many pages we have to erase */
    size_t iterations = flash_no_of_iterations_get(size, PAGE_SIZE);

    /* Erase desired amount of pages */
    for (uint32_t i = 0; i < iterations; i++)
    {
        if (flash_page_erase(addr, PAGE_ERASE_TIMEOUT) != 0)
        {
            return 1;
        }
        /* Increment the address of page by one page size */
        addr += PAGE_SIZE;
    }

    return 0;
}

bool flash_program_and_verify(uint32_t addr, uint8_t *p_data, uint32_t size)
{
    /* Unclock flash memory  */
    if (flash_unlock(PAGE_UNLOCK_TIMEOUT) != 0)
    {
        return 1;
    }

    /* Calculate how many pages we have to write. */
    size_t iterations = flash_no_of_iterations_get(size, WRITE_SIZE);

    /* Write desired amount of data */
    size_t written_data = 0;
    uint16_t data = 0;

    for (uint32_t i = 0; i < iterations; i++)
    {
        /* Copy data from buffer */
        memcpy(&data, &p_data[written_data], WRITE_SIZE);

        /* Write data to Flash memory */
        if (flash_write(data, addr, PAGE_ERASE_TIMEOUT) != 0)
        {
            return 1;
        }

        /* Check if data was written with success */
        volatile uint16_t read = *(volatile uint16_t *)addr;

        if (read != data)
        {
            return 1;
        }
        /* Increment the address by one write size */
        written_data += WRITE_SIZE;
        addr += WRITE_SIZE;
    }

    /* Flash memory should be locked after the programming. */
    flash_lock();

    return 0;
}

bool flash_program(uint32_t addr, uint8_t *p_data, uint32_t size)
{
    /* Unclock flash memory  */
    if (flash_unlock(PAGE_UNLOCK_TIMEOUT) != 0)
    {
        return 1;
    }

    uint16_t *data = (uint16_t *)p_data;

    /* Calculate how many pages we have to write. */
    size_t iterations = flash_no_of_iterations_get(size, WRITE_SIZE);

    /* Write desired amount of data */
    for (uint32_t i = 0; i < iterations; i++)
    {
        /* Write data to Flash memory */
        if (flash_write(data[i], addr, PAGE_ERASE_TIMEOUT) != 0)
        {
            return 1;
        }

        /* Increment the address by one write size */
        addr += WRITE_SIZE;
    }

    /* Flash memory should be locked after the programming. */
    flash_lock();

    return 0;
}

bool flash_read(uint32_t addr, uint8_t *p_data, uint32_t size)
{

    size_t idx = 0;
    while (idx != size)
    {
        volatile uint16_t read = *(volatile uint16_t *)addr;

        if ((size - idx) > sizeof(uint8_t))
        {
            *p_data++ = (uint8_t)(read);
            *p_data++ = (uint8_t)(read >> 8);
            idx += WRITE_SIZE;
        }
        else
        {
            *p_data++ = (uint8_t)(read >> 8);
            idx++;
        }
        addr += WRITE_SIZE;
    }

    return 0;
}
