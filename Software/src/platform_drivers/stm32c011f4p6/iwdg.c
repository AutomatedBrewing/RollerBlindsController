#include "iwdg.h"
#include <stdbool.h>

#include "stm32c0xx_ll_iwdg.h"

#define IWDG_LSI_FREQUENCY_HZ 32000U
#define IWDG_RELOAD_MAX 0x0FFFU
#define IWDG_UPDATE_WAIT_LIMIT 1000000U

struct iwdg_prescaler
{
    uint16_t divider;
    uint32_t value;
};

static const struct iwdg_prescaler prescalers[] = {{4U, LL_IWDG_PRESCALER_4},    {8U, LL_IWDG_PRESCALER_8},
                                                   {16U, LL_IWDG_PRESCALER_16},  {32U, LL_IWDG_PRESCALER_32},
                                                   {64U, LL_IWDG_PRESCALER_64},  {128U, LL_IWDG_PRESCALER_128},
                                                   {256U, LL_IWDG_PRESCALER_256}};

static enum iwdg_result calculate_configuration(uint32_t timeout_ms, uint32_t *prescaler, uint32_t *reload)
{
    if ((timeout_ms == 0U) || (prescaler == 0) || (reload == 0))
    {
        return IWDG_INVALID_ARGUMENT;
    }

    for (uint32_t i = 0U; i < (sizeof(prescalers) / sizeof(prescalers[0])); ++i)
    {
        uint64_t denominator = (uint64_t)prescalers[i].divider * 1000U;

        uint64_t ticks = ((uint64_t)timeout_ms * IWDG_LSI_FREQUENCY_HZ + denominator - 1U) / denominator;

        if ((ticks >= 1U) && (ticks <= ((uint64_t)IWDG_RELOAD_MAX + 1U)))
        {
            *prescaler = prescalers[i].value;
            *reload = (uint32_t)(ticks - 1U);

            return IWDG_OK;
        }
    }

    return IWDG_INVALID_ARGUMENT;
}

static bool wait_for_update(void)
{
    uint32_t remaining = IWDG_UPDATE_WAIT_LIMIT;

    while (LL_IWDG_IsReady(IWDG) == 0U)
    {
        if (remaining == 0U)
        {
            return false;
        }

        --remaining;
    }

    return true;
}

enum iwdg_result iwdg_init(uint32_t timeout_ms)
{
    uint32_t prescaler;
    uint32_t reload;

    enum iwdg_result result = calculate_configuration(timeout_ms, &prescaler, &reload);

    if (result != IWDG_OK)
    {
        return result;
    }

    LL_IWDG_Enable(IWDG);
    LL_IWDG_EnableWriteAccess(IWDG);

    LL_IWDG_SetPrescaler(IWDG, prescaler);
    LL_IWDG_SetReloadCounter(IWDG, reload);

    if (!wait_for_update())
    {
        return IWDG_TIMEOUT;
    }

    LL_IWDG_ReloadCounter(IWDG);

    return IWDG_OK;
}

void iwdg_refresh(void)
{
    LL_IWDG_ReloadCounter(IWDG);
}