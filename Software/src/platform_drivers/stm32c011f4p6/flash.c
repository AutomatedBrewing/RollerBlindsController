#include "flash.h"
#include "cmsis_os.h"
#include "stm32c0xx.h"

#include <stdbool.h>
#include <stdint.h>
#include <string.h>

/* -------------------------------------------------------------------------- */
/* Configuration                                                              */
/* -------------------------------------------------------------------------- */

#define FLASH_SIZE_BYTES        16384U
#define FLASH_PAGE_SIZE         2048U
#define FLASH_WRITE_SIZE        8U

#define FLASH_FKEY1             0x45670123U
#define FLASH_FKEY2             0xCDEF89ABU

#define FLASH_PAGE_ERASE_TIMEOUT_MS  50U
#define FLASH_PAGE_WRITE_TIMEOUT_MS  5U
#define FLASH_UNLOCK_TIMEOUT_MS      1U

#define FLASH_ERROR_FLAGS \
    (FLASH_SR_OPERR   | FLASH_SR_PROGERR | FLASH_SR_WRPERR | \
     FLASH_SR_PGAERR  | FLASH_SR_SIZERR | FLASH_SR_PGSERR | \
     FLASH_SR_MISERR  | FLASH_SR_FASTERR)

/* -------------------------------------------------------------------------- */
/* Timeout and status helpers                                                 */
/* -------------------------------------------------------------------------- */

/*
 * All public functions return:
 * false - success
 * true  - error
 */

static bool flash_wait_flag_clear(uint32_t flag, uint32_t timeout_ms)
{
    uint32_t start;
    uint32_t frequency;
    uint32_t timeout_ticks;

    frequency = osKernelGetTickFreq();

    if (frequency == 0U)
    {
        return true;
    }

    timeout_ticks = (uint32_t)
        ((((uint64_t)timeout_ms * frequency) + 999U) / 1000U);

    start = osKernelGetTickCount();

    while (READ_BIT(FLASH->SR, flag) != 0U)
    {
        if ((timeout_ticks == 0U) ||
            ((uint32_t)(osKernelGetTickCount() - start) >= timeout_ticks))
        {
            return true;
        }
    }

    return false;
}

/*
 * Before starting an operation:
 *
 * 1. Wait for BSY1 to clear.
 * 2. Clear previous EOP and programming error flags.
 * 3. Check CFGBSY.
 *
 * This ordering follows the standard programming/erase procedure.
 */
static bool flash_prepare_operation(uint32_t timeout_ms)
{
    if (flash_wait_flag_clear(FLASH_SR_BSY1, timeout_ms))
    {
        return true;
    }

    WRITE_REG(FLASH->SR, FLASH_SR_EOP | FLASH_ERROR_FLAGS);

    if (flash_wait_flag_clear(FLASH_SR_CFGBSY, timeout_ms))
    {
        return true;
    }

    return false;
}

static bool flash_address_range_valid(uint32_t addr, uint32_t size)
{
    const uint32_t flash_end = FLASH_BASE + FLASH_SIZE_BYTES;

    if ((size == 0U) ||
        (addr < FLASH_BASE) ||
        (addr >= flash_end))
    {
        return false;
    }

    return (size <= (flash_end - addr));
}

static bool flash_program_range_valid(uint32_t addr, uint32_t size)
{
    uint32_t padded_size;

    if (size == 0U)
    {
        return false;
    }

    if (size > (UINT32_MAX - (FLASH_WRITE_SIZE - 1U)))
    {
        return false;
    }

    padded_size = (size + FLASH_WRITE_SIZE - 1U) &
                  ~(FLASH_WRITE_SIZE - 1U);

    return flash_address_range_valid(addr, padded_size);
}

static bool flash_unlock(uint32_t timeout_ms)
{
    if (flash_wait_flag_clear(FLASH_SR_BSY1, timeout_ms))
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

static bool flash_status_has_error(void)
{
    return (READ_BIT(FLASH->SR, FLASH_ERROR_FLAGS) != 0U);
}

/*
 * Wait for the operation to finish.
 *
 * IMPORTANT:
 * If a timeout occurs, do not clear PG/PER while the Flash interface
 * is busy. Wait for the hardware operation to finish before modifying CR.
 * The function reports an error even if the operation later completes.
 */
static bool flash_finish_operation(uint32_t operation_bit,
                                   uint32_t timeout_ms)
{
    bool timed_out = false;
    bool failed;

    if (flash_wait_flag_clear(FLASH_SR_CFGBSY, timeout_ms))
    {
        timed_out = true;

        /*
         * Nie zmieniaj FLASH_CR, dopóki operacja trwa.
         */
        while (READ_BIT(FLASH->SR, FLASH_SR_CFGBSY) != 0U)
        {
        }
    }

    if (flash_wait_flag_clear(FLASH_SR_BSY1, timeout_ms))
    {
        timed_out = true;

        while (READ_BIT(FLASH->SR, FLASH_SR_BSY1) != 0U)
        {
        }
    }

    /*
     * Sukces określają flagi błędów.
     * EOP nie jest wymagane jako warunek sukcesu.
     */
    failed = flash_status_has_error();

    CLEAR_BIT(FLASH->CR, operation_bit);

    WRITE_REG(FLASH->SR, FLASH_SR_EOP | FLASH_ERROR_FLAGS);

    return (timed_out || failed);
}

/* -------------------------------------------------------------------------- */
/* Double-word programming                                                    */
/* -------------------------------------------------------------------------- */

static bool flash_write(uint64_t data, uint32_t addr, uint32_t timeout_ms)
{
    if ((addr & (FLASH_WRITE_SIZE - 1U)) != 0U)
    {
        return true;
    }

    if (!flash_address_range_valid(addr, FLASH_WRITE_SIZE))
    {
        return true;
    }

    if (flash_prepare_operation(timeout_ms))
    {
        return true;
    }

    SET_BIT(FLASH->CR, FLASH_CR_PG);

    /*
     * Standard STM32C0 programming sequence:
     * two consecutive 32-bit writes to one aligned double word.
     */
    *(__IO uint32_t *)addr = (uint32_t)data;
    *(__IO uint32_t *)(addr + 4U) = (uint32_t)(data >> 32);

    return flash_finish_operation(FLASH_CR_PG, timeout_ms);
}

/* -------------------------------------------------------------------------- */
/* Page erase                                                                 */
/* -------------------------------------------------------------------------- */

static bool flash_page_erase(uint32_t page_addr, uint32_t timeout_ms)
{
    uint32_t page_number;

    if (!flash_address_range_valid(page_addr, FLASH_PAGE_SIZE))
    {
        return true;
    }

    if (((page_addr - FLASH_BASE) % FLASH_PAGE_SIZE) != 0U)
    {
        return true;
    }

    page_number = (page_addr - FLASH_BASE) / FLASH_PAGE_SIZE;

    if (page_number >= (FLASH_SIZE_BYTES / FLASH_PAGE_SIZE))
    {
        return true;
    }

    if (flash_prepare_operation(timeout_ms))
    {
        return true;
    }

    /*
     * Select page erase and page number.
     */
    MODIFY_REG(FLASH->CR,
               FLASH_CR_PNB,
               page_number << FLASH_CR_PNB_Pos);

    SET_BIT(FLASH->CR, FLASH_CR_PER);
    SET_BIT(FLASH->CR, FLASH_CR_STRT);

    return flash_finish_operation(FLASH_CR_PER, timeout_ms);
}

/* -------------------------------------------------------------------------- */
/* Shared programming implementation                                          */
/* -------------------------------------------------------------------------- */

static bool flash_program_internal(uint32_t addr,
                                   const uint8_t *p_data,
                                   uint32_t size,
                                   bool verify)
{
    uint32_t remaining;
    uint32_t write_size;
    uint64_t data;
    uint64_t read_data;

    if ((p_data == NULL) ||
        ((addr & (FLASH_WRITE_SIZE - 1U)) != 0U) ||
        !flash_program_range_valid(addr, size))
    {
        return true;
    }

    if (flash_unlock(FLASH_UNLOCK_TIMEOUT_MS))
    {
        return true;
    }

    remaining = size;

    while (remaining > 0U)
    {
        data = UINT64_MAX;

        write_size = (remaining >= FLASH_WRITE_SIZE)
                         ? FLASH_WRITE_SIZE
                         : remaining;

        memcpy(&data, p_data, write_size);

        if (flash_write(data, addr, FLASH_PAGE_WRITE_TIMEOUT_MS))
        {
            flash_lock();
            return true;
        }

        if (verify)
        {
            read_data = (uint64_t)(*(__IO uint32_t *)addr);
            read_data |=
                ((uint64_t)(*(__IO uint32_t *)(addr + 4U))) << 32;

            if (read_data != data)
            {
                flash_lock();
                return true;
            }
        }

        p_data += write_size;
        addr += FLASH_WRITE_SIZE;
        remaining -= write_size;
    }

    flash_lock();

    return false;
}

/* -------------------------------------------------------------------------- */
/* Public API                                                                 */
/* -------------------------------------------------------------------------- */

bool flash_erase(uint32_t addr, uint32_t size)
{
    uint32_t pages;
    uint32_t remaining_flash;

    if ((size == 0U) ||
        (addr < FLASH_BASE) ||
        (addr >= (FLASH_BASE + FLASH_SIZE_BYTES)))
    {
        return true;
    }

    if (((addr - FLASH_BASE) % FLASH_PAGE_SIZE) != 0U)
    {
        return true;
    }

    remaining_flash = (FLASH_BASE + FLASH_SIZE_BYTES) - addr;

    if (size > remaining_flash)
    {
        return true;
    }

    pages = size / FLASH_PAGE_SIZE;

    if ((size % FLASH_PAGE_SIZE) != 0U)
    {
        pages++;
    }

    if (pages > (remaining_flash / FLASH_PAGE_SIZE))
    {
        return true;
    }

    if (flash_unlock(FLASH_UNLOCK_TIMEOUT_MS))
    {
        return true;
    }

    for (uint32_t i = 0U; i < pages; i++)
    {
        if (flash_page_erase(addr, FLASH_PAGE_ERASE_TIMEOUT_MS))
        {
            flash_lock();
            return true;
        }

        addr += FLASH_PAGE_SIZE;
    }

    flash_lock();

    return false;
}

bool flash_program_and_verify(uint32_t addr,
                              uint8_t *p_data,
                              uint32_t size)
{
    return flash_program_internal(addr, p_data, size, true);
}

bool flash_program(uint32_t addr,
                   const uint8_t *p_data,
                   uint32_t size)
{
    return flash_program_internal(addr, p_data, size, false);
}

bool flash_read(uint32_t addr, uint8_t *p_data, uint32_t size)
{
    if ((p_data == NULL) ||
        !flash_address_range_valid(addr, size))
    {
        return true;
    }

    memcpy(p_data, (const void *)addr, size);

    return false;
}