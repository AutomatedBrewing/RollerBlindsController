/*
 * pwm_stm32c0.c
 *
 * PWM driver for STM32C011F4P6.
 * Supported output: PC15 / TIM3_CH3 / AF3.
 */

#include "pwm.h"

#include <stddef.h>
#include <stdint.h>

#include "stm32c0xx.h"
#include "stm32c0xx_ll_bus.h"
#include "stm32c0xx_ll_gpio.h"
#include "stm32c0xx_ll_tim.h"

#include "gpio.h"

/*
 * Must match the actual TIM3 input clock configured by the application.
 * Change this value if the clock tree uses a different frequency.
 */
#ifndef PWM_TIM3_CLOCK_HZ
#define PWM_TIM3_CLOCK_HZ 48000000UL
#endif

#define PWM_DUTY_CYCLE_PERCENT 50U

struct pwm_instance {
    bool allocated;
    bool running;
    enum board_input_pin_id pin_id;
    uint32_t frequency_hz;
};

static struct pwm_instance pwm_instance;

/*
 * This implementation supports only PC15 / TIM3_CH3.
 */
static bool pwm_pin_supported(enum board_input_pin_id pin_id)
{
    const struct gpio_pin *pin = find_gpio_pin_context(pin_id);

    if (pin == NULL) {
        return false;
    }

    return pin_id == BUZZER_PIN_ID
        && pin->port == (uint32_t)GPIOC
        && pin->pin == LL_GPIO_PIN_15
        && pin->alternate_function == LL_GPIO_AF_3;
}

static bool pwm_configure_gpio(enum board_input_pin_id pin_id)
{
    const struct gpio_pin *pin = find_gpio_pin_context(pin_id);

    if (pin == NULL) {
        return false;
    }
    void * handle;
    enum gpio_pin_status status = gpio_pin_init(pin, &handle);

    if (status != GPIO_OK || handle == NULL) {
        return false;
    }

    return true;
}

static bool pwm_configure_timer(uint32_t frequency_hz)
{
    uint32_t period_ticks;

    if (frequency_hz == 0U ||
        frequency_hz > PWM_TIM3_CLOCK_HZ) {
        return false;
    }

    /*
     * Use prescaler = 0 and derive ARR from the timer clock.
     * For frequencies requiring more than 16-bit ARR, use a prescaler.
     */
    period_ticks = PWM_TIM3_CLOCK_HZ / frequency_hz;

    if (period_ticks == 0U || period_ticks > 65536U) {
        return false;
    }

    LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_TIM3);

    LL_TIM_DisableCounter(TIM3);

    LL_TIM_SetPrescaler(TIM3, 0U);
    LL_TIM_SetCounterMode(TIM3, LL_TIM_COUNTERMODE_UP);
    LL_TIM_SetAutoReload(TIM3, period_ticks - 1U);
    LL_TIM_SetCounter(TIM3, 0U);

    LL_TIM_OC_SetMode(TIM3, LL_TIM_CHANNEL_CH3,
                      LL_TIM_OCMODE_PWM1);
    LL_TIM_OC_SetPolarity(TIM3, LL_TIM_CHANNEL_CH3,
                           LL_TIM_OCPOLARITY_HIGH);
    LL_TIM_OC_SetCompareCH3(
        TIM3,
        (period_ticks * PWM_DUTY_CYCLE_PERCENT) / 100U
    );

    LL_TIM_OC_EnablePreload(TIM3, LL_TIM_CHANNEL_CH3);
    LL_TIM_EnableARRPreload(TIM3);

    LL_TIM_GenerateEvent_UPDATE(TIM3);
    LL_TIM_ClearFlag_UPDATE(TIM3);

    return true;
}

pwm_handle_t pwm_init(enum board_input_pin_id pin_id,
                      uint32_t frequency_hz)
{
    if (pwm_instance.allocated ||
        !pwm_pin_supported(pin_id) ||
        frequency_hz == 0U) {
        return NULL;
    }

    pwm_instance.allocated = true;
    pwm_instance.running = false;
    pwm_instance.pin_id = pin_id;
    pwm_instance.frequency_hz = frequency_hz;

    if (!pwm_configure_gpio(pin_id) ||
        !pwm_configure_timer(frequency_hz)) {
        pwm_instance.allocated = false;
        return NULL;
    }

    /*
     * Keep the channel disabled until pwm_start().
     */
    LL_TIM_CC_DisableChannel(TIM3, LL_TIM_CHANNEL_CH3);

    return &pwm_instance;
}

bool pwm_start(pwm_handle_t handle)
{
    struct pwm_instance *instance = handle;

    if (instance == NULL ||
        instance != &pwm_instance ||
        !instance->allocated) {
        return false;
    }

    LL_TIM_CC_EnableChannel(TIM3, LL_TIM_CHANNEL_CH3);
    LL_TIM_EnableCounter(TIM3);

    instance->running = true;
    return true;
}

bool pwm_stop(pwm_handle_t handle)
{
    struct pwm_instance *instance = handle;

    if (instance == NULL ||
        instance != &pwm_instance ||
        !instance->allocated) {
        return false;
    }

    LL_TIM_CC_DisableChannel(TIM3, LL_TIM_CHANNEL_CH3);
    LL_TIM_DisableCounter(TIM3);

    instance->running = false;
    return true;
}

bool pwm_set_frequency(pwm_handle_t handle,
                       uint32_t frequency_hz)
{
    struct pwm_instance *instance = handle;

    if (instance == NULL ||
        instance != &pwm_instance ||
        !instance->allocated ||
        frequency_hz == 0U) {
        return false;
    }

    if (!pwm_configure_timer(frequency_hz)) {
        return false;
    }

    instance->frequency_hz = frequency_hz;
    return true;
}