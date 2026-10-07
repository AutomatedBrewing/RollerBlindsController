#include "flash.h"
#include "cmsis_os.h"
#include "stm32c0xx.h"
#include <string.h>
#include <stdbool.h>
#include <stdint.h>

#define PAGE_SIZE               2048U
#define WRITE_SIZE              8U

#define FLASH_FKEY1             0x45670123U
#define FLASH_FKEY2             0xCDEF89ABU

#define PAGE_ERASE_TIMEOUT      50U     /* ms */
#define PAGE_WRITE_TIMEOUT      1U      /* ms */
#define PAGE_UNLOCK_TIMEOUT     1U      /* ms */


/* -------------------------------------------------------------------------- */
/* Private functions                                                          */
/* -------------------------------------------------------------------------- */

static uint32_t flash_no_of_iterations_get(uint32_t size,
                                           uint32_t block_size)
{
    return (size + block_size - 1U) / block_size;
}


static bool flash_wait_until_ready(uint32_t timeout)
{
    uint32_t tickstart = osKernelGetTickCount();

    while ((READ_BIT(FLASH->SR, FLASH_SR_BSY1) != 0U) ||
           (READ_BIT(FLASH->SR, FLASH_SR_CFGBSY) != 0U))
    {
        if ((timeout == 0U) ||
            ((osKernelGetTickCount() - tickstart) > timeout))
        {
            return true;
        }
    }

    return false;
}


static void flash_clear_status_flags(void)
{
    /*
     * Clear EOP and all programming/erase error flags.
     *
     * On STM32C0 these flags are cleared by writing 1.
     */
    FLASH->SR = FLASH_SR_EOP   |
                FLASH_SR_OPERR |
                FLASH_SR_PROGERR |
                FLASH_SR_WRPERR |
                FLASH_SR_PGAERR |
                FLASH_SR_SIZERR |
                FLASH_SR_PGSERR |
                FLASH_SR_MISERR |
                FLASH_SR_FASTERR;
}


static bool flash_unlock(uint32_t timeout)
{
    if (flash_wait_until_ready(timeout))
    {
        return true;
    }

    if (READ_BIT(FLASH->CR, FLASH_CR_LOCK) != 0U)
    {
        WRITE_REG(FLASH->KEYR, FLASH_FKEY1);
        WRITE_REG(FLASH->KEYR, FLASH_FKEY2);
    }

    return (READ_BIT(FLASH->CR, FLASH_CR_LOCK) != 0U);
}


static void flash_lock(void)
{
    SET_BIT(FLASH->CR, FLASH_CR_LOCK);
}


/* -------------------------------------------------------------------------- */
/* Flash programming                                                          */
/* -------------------------------------------------------------------------- */

static bool flash_write(uint64_t data,
                        uint32_t addr,
                        uint32_t timeout)
{
    /*
     * STM32C0 can only program 64-bit double words.
     */
    if ((addr & 0x7U) != 0U)
    {
        return true;
    }

    if (flash_wait_until_ready(timeout))
    {
        return true;
    }

    flash_clear_status_flags();

    /*
     * Enable programming.
     */
    SET_BIT(FLASH->CR, FLASH_CR_PG);

    /*
     * STM32C0 requires two consecutive 32-bit writes.
     */
    *(__IO uint32_t *)addr =
        (uint32_t)(data & 0xFFFFFFFFULL);

    __ISB();

    *(__IO uint32_t *)(addr + 4U) =
        (uint32_t)(data >> 32);

    /*
     * Wait for completion.
     *
     * CFGBSY is the important flag for completion of the
     * programming sequence.
     */
    if (flash_wait_until_ready(timeout))
    {
        CLEAR_BIT(FLASH->CR, FLASH_CR_PG);
        return true;
    }

    /*
     * Check EOP.
     */
    if (READ_BIT(FLASH->SR, FLASH_SR_EOP) == 0U)
    {
        CLEAR_BIT(FLASH->CR, FLASH_CR_PG);
        return true;
    }

    /*
     * Clear EOP.
     */
    SET_BIT(FLASH->SR, FLASH_SR_EOP);

    /*
     * Disable programming.
     */
    CLEAR_BIT(FLASH->CR, FLASH_CR_PG);

    /*
     * Check for programming errors.
     */
    if ((FLASH->SR & (FLASH_SR_OPERR   |
                      FLASH_SR_PROGERR |
                      FLASH_SR_WRPERR  |
                      FLASH_SR_PGAERR  |
                      FLASH_SR_SIZERR  |
                      FLASH_SR_PGSERR  |
                      FLASH_SR_MISERR  |
                      FLASH_SR_FASTERR)) != 0U)
    {
        return true;
    }

    return false;
}


/* -------------------------------------------------------------------------- */
/* Flash page erase                                                           */
/* -------------------------------------------------------------------------- */

static bool flash_page_erase(uint32_t page_addr,
                             uint32_t timeout)
{
    uint32_t page_number;

    if (flash_wait_until_ready(timeout))
    {
        return true;
    }

    /*
     * Convert address to page number.
     *
     * STM32C0 uses FLASH_CR.PNB instead of FLASH->AR.
     */
    page_number = (page_addr - FLASH_BASE) / PAGE_SIZE;

    /*
     * PNB occupies bits 9:3.
     */
    if (page_number > 0x7FU)
    {
        return true;
    }

    flash_clear_status_flags();

    /*
     * Select page erase.
     */
    SET_BIT(FLASH->CR, FLASH_CR_PER);

    MODIFY_REG(FLASH->CR,
               FLASH_CR_PNB,
               page_number << FLASH_CR_PNB_Pos);

    /*
     * Start erase.
     */
    SET_BIT(FLASH->CR, FLASH_CR_STRT);

    /*
     * Wait until erase/configuration operation is complete.
     */
    if (flash_wait_until_ready(timeout))
    {
        CLEAR_BIT(FLASH->CR, FLASH_CR_PER);
        return true;
    }

    /*
     * Check EOP.
     */
    if (READ_BIT(FLASH->SR, FLASH_SR_EOP) == 0U)
    {
        CLEAR_BIT(FLASH->CR, FLASH_CR_PER);
        return true;
    }

    /*
     * Clear EOP.
     */
    SET_BIT(FLASH->SR, FLASH_SR_EOP);

    /*
     * Disable page erase.
     */
    CLEAR_BIT(FLASH->CR, FLASH_CR_PER);

    /*
     * Check errors.
     */
    if ((FLASH->SR & (FLASH_SR_OPERR   |
                      FLASH_SR_PROGERR |
                      FLASH_SR_WRPERR  |
                      FLASH_SR_PGAERR  |
                      FLASH_SR_SIZERR  |
                      FLASH_SR_PGSERR  |
                      FLASH_SR_MISERR  |
                      FLASH_SR_FASTERR)) != 0U)
    {
        return true;
    }

    return false;
}


/* -------------------------------------------------------------------------- */
/* Public API                                                                 */
/* -------------------------------------------------------------------------- */

bool flash_erase(uint32_t addr, uint32_t size)
{
    if (size == 0U)
    {
        return false;
    }

    /*
     * Erase starts at a page boundary.
     */
    if ((addr - FLASH_BASE) % PAGE_SIZE != 0U)
    {
        return true;
    }

    if (flash_unlock(PAGE_UNLOCK_TIMEOUT))
    {
        return true;
    }

    uint32_t iterations =
        flash_no_of_iterations_get(size, PAGE_SIZE);

    for (uint32_t i = 0U; i < iterations; i++)
    {
        if (flash_page_erase(addr, PAGE_ERASE_TIMEOUT))
        {
            flash_lock();
            return true;
        }

        addr += PAGE_SIZE;
    }

    flash_lock();

    return false;
}


bool flash_program_and_verify(uint32_t addr,
                              uint8_t *p_data,
                              uint32_t size)
{
    if ((p_data == NULL) || (size == 0U))
    {
        return false;
    }

    /*
     * STM32C0 requires 64-bit aligned programming addresses.
     */
    if ((addr & 0x7U) != 0U)
    {
        return true;
    }

    if (flash_unlock(PAGE_UNLOCK_TIMEOUT))
    {
        return true;
    }

    uint32_t remaining = size;

    while (remaining > 0U)
    {
        uint64_t data = UINT64_MAX;
        uint32_t write_size =
            (remaining >= WRITE_SIZE) ? WRITE_SIZE : remaining;

        /*
         * Fill missing bytes with 0xFF.
         */
        memcpy(&data, p_data, write_size);

        if (flash_write(data, addr, PAGE_WRITE_TIMEOUT))
        {
            flash_lock();
            return true;
        }

        uint64_t read =
            *(__IO uint32_t *)addr;

        read |=
            ((uint64_t)*(__IO uint32_t *)(addr + 4U)) << 32;

        if (read != data)
        {
            flash_lock();
            return true;
        }

        p_data += write_size;
        addr += WRITE_SIZE;

        remaining -= write_size;
    }

    flash_lock();

    return false;
}


bool flash_program(uint32_t addr,
                   uint8_t *p_data,
                   uint32_t size)
{
    if ((p_data == NULL) || (size == 0U))
    {
        return false;
    }

    if ((addr & 0x7U) != 0U)
    {
        return true;
    }

    if (flash_unlock(PAGE_UNLOCK_TIMEOUT))
    {
        return true;
    }

    uint32_t remaining = size;

    while (remaining > 0U)
    {
        uint64_t data = UINT64_MAX;
        uint32_t write_size =
            (remaining >= WRITE_SIZE) ? WRITE_SIZE : remaining;

        /*
         * For a partial final double-word, remaining bytes stay 0xFF.
         */
        memcpy(&data, p_data, write_size);

        if (flash_write(data, addr, PAGE_WRITE_TIMEOUT))
        {
            flash_lock();
            return true;
        }

        p_data += write_size;
        addr += WRITE_SIZE;

        remaining -= write_size;
    }

    flash_lock();

    return false;
}


bool flash_read(uint32_t addr,
                uint8_t *p_data,
                uint32_t size)
{
    if ((p_data == NULL) || (size == 0U))
    {
        return false;
    }

    memcpy(p_data,
           (const void *)addr,
           size);

    return false;
}