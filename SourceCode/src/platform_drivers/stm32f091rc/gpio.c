
/* Includes ------------------------------------------------------------------*/
#include "gpio.h"

#include <stdbool.h>
#include <stddef.h>
#include <string.h>

#include "gpio_pins.h"
#include "stm32f0xx_ll_bus.h"
#include "stm32f0xx_ll_exti.h"
#include "stm32f0xx_ll_gpio.h"
#include "stm32f0xx_ll_system.h"

static bool is_initialized = false;
#define BIT(x) (1 << (x))
#define MAX_NUMBER_OF_SUPPORTED_PINS (16)

enum interrupt_pin_polarity
{
    INTERRUPT_PIN_POLARITY_HITOLO,
    INTERRUPT_PIN_POLARITY_LOTOHI,
    INTERRUPT_PIN_POLARITY_TOGGLE
};

enum interrupt_state
{
    INTERRUPT_INACTIVE,
    INTERRUPT_ACTIVE
};

struct exti_configuration
{
    uint32_t IRQ;
    uint32_t exti_line;
    uint32_t sysconf_exti_line;
    uint32_t sysconf_exti_port;
};

struct pin_context
{
    const struct gpio_pin *info;
    struct exti_configuration exti;
    void (*callback)(void *);
    void *callback_data;
    bool is_used;
};

static struct pin_context pin_context_list[MAX_NUMBER_OF_SUPPORTED_PINS];

static enum interrupt_pin_polarity interrupt_pin_polarity_from_activity(enum board_input_polarity polarity,
                                                                        enum interrupt_pin_activity activity)
{
    if (activity)
    {
        return polarity == ACTIVE_HIGH ? INTERRUPT_PIN_POLARITY_LOTOHI : INTERRUPT_PIN_POLARITY_HITOLO;
    }
    else
    {
        return polarity != ACTIVE_HIGH ? INTERRUPT_PIN_POLARITY_LOTOHI : INTERRUPT_PIN_POLARITY_HITOLO;
    }
}

static void find_context_and_call_callback(uint32_t exti_line)
{
    for (uint32_t pin = 0; pin < MAX_NUMBER_OF_SUPPORTED_PINS; pin++)
    {
        if (pin_context_list[pin].exti.exti_line == exti_line)
        {
            if (pin_context_list[pin].callback)
            {
                pin_context_list[pin].callback(pin_context_list[pin].callback_data);
            }

            break;
        }
    }
}

static bool any_interrupt_pending(void)
{
    return READ_REG(EXTI->PR) & LL_EXTI_LINE_ALL;
}

static uint32_t get_pending_interrupt_line(void)
{
    return (uint32_t)BIT(__builtin_ctz(EXTI->PR));
}

static void irq_handler(void)
{
    uint32_t active_exti_line;
    while (any_interrupt_pending())
    {
        active_exti_line = get_pending_interrupt_line();
        LL_EXTI_ClearFlag_0_31(active_exti_line);
        find_context_and_call_callback(active_exti_line);
    }
}
/**
 * @brief  This function handles external line 0_1 interrupt request.
 * @param  None
 * @retval None
 */
void EXTI0_1_IRQHandler(void)
{
    irq_handler();
}

/**
 * @brief  This function handles external line 2_3 interrupt request.
 * @param  None
 * @retval None
 */
void EXTI2_3_IRQHandler(void)
{
    irq_handler();
}

/**
 * @brief  This function handles external line 4_15 interrupt request.
 * @param  None
 * @retval None
 */
void EXTI4_15_IRQHandler(void)
{
    irq_handler();
}

static struct pin_context *find_free_entry_for_pin(void)
{
    for (uint8_t handle_idx = 0; handle_idx < MAX_NUMBER_OF_SUPPORTED_PINS; handle_idx++)
    {
        if (!pin_context_list[handle_idx].is_used)
        {
            return &pin_context_list[handle_idx];
        }
    }
    return NULL;
}

static struct pin_context *entry_add(const struct gpio_pin *info)
{
    struct pin_context *handle = find_free_entry_for_pin();
    if (handle != NULL)
    {
        handle->info = info;
        handle->callback = NULL;
        handle->callback_data = NULL;
        handle->is_used = true;
        return handle;
    }
    return NULL;
}

#define CASE_PIN(x)                                                                                                    \
    case LL_GPIO_PIN_##x:                                                                                              \
        handle->exti.exti_line = LL_EXTI_LINE_##x;                                                                     \
        handle->exti.sysconf_exti_line = LL_SYSCFG_EXTI_LINE##x;                                                       \
        break;

static void fill_exti_pin_configuration(struct pin_context *handle)
{
    switch (handle->info->pin)
    {
        CASE_PIN(0);
        CASE_PIN(1);
        CASE_PIN(2);
        CASE_PIN(3);
        CASE_PIN(4);
        CASE_PIN(5);
        CASE_PIN(6);
        CASE_PIN(7);
        CASE_PIN(8);
        CASE_PIN(9);
        CASE_PIN(10);
        CASE_PIN(11);
        CASE_PIN(12);
        CASE_PIN(13);
        CASE_PIN(14);
        CASE_PIN(15);
    }
}

static void fill_exti_port_configuration(struct pin_context *handle)
{
    if (handle->info->port == (uint32_t)GPIOA)
    {
        handle->exti.sysconf_exti_port = LL_SYSCFG_EXTI_PORTA;
    }
    else if (handle->info->port == (uint32_t)GPIOB)
    {
        handle->exti.sysconf_exti_port = LL_SYSCFG_EXTI_PORTB;
    }
    else if (handle->info->port == (uint32_t)GPIOC)
    {
        handle->exti.sysconf_exti_port = LL_SYSCFG_EXTI_PORTC;
    }
    else if (handle->info->port == (uint32_t)GPIOD)
    {
        handle->exti.sysconf_exti_port = LL_SYSCFG_EXTI_PORTD;
    }
}

static uint32_t find_IRQ_for_pin(uint32_t pin)
{
    if (pin <= LL_GPIO_PIN_1)
    {
        return EXTI0_1_IRQn;
    }
    else if (pin <= LL_GPIO_PIN_3)
    {
        return EXTI2_3_IRQn;
    }
    else
    {
        return EXTI4_15_IRQn;
    }
}

static void entry_update(struct pin_context *handle, struct input_pin_config *input_config)
{
    handle->callback = input_config->callback;
    handle->callback_data = input_config->callback_data;
    fill_exti_pin_configuration(handle);
    fill_exti_port_configuration(handle);
    handle->exti.IRQ = find_IRQ_for_pin(handle->info->pin);
}

// static void entry_remove(struct pin_context *handle)
//{
//     handle->info = NULL;
//     handle->callback = NULL;
//     handle->user_data = NULL;
//     handle->is_used = false;
// }

static struct pin_context *find_matching_entry_for_info(const struct gpio_pin *info)
{
    for (uint8_t handle_idx = 0; handle_idx < MAX_NUMBER_OF_SUPPORTED_PINS; handle_idx++)
    {
        if (info == pin_context_list[handle_idx].info)
        {
            return &pin_context_list[handle_idx];
        }
    }
    return NULL;
}

static enum gpio_pin_status find_or_create_pin_entry_if_not_existing(const struct gpio_pin *info, void **handle)
{
    struct pin_context *entry = find_matching_entry_for_info(info);
    if (entry == NULL)
    {
        entry = entry_add(info);
        if (entry == NULL)
        {
            *handle = NULL;
            return GPIO_NO_MEMORY;
        }
    }
    *handle = (void *)entry;
    return GPIO_OK;
}

static void initialize_gpio_peripheral(void)
{
    LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_GPIOA);
    LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_GPIOB);
    LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_GPIOC);
    is_initialized = true;
}

static uint32_t convert_pin_mode_to_driver_mode(enum board_pin_mode mode)
{
    switch (mode)
    {
    case PIN_MODE_INPUT:
        return LL_GPIO_MODE_INPUT;
    case PIN_MODE_OUTPUT_OPEN_DRAIN:
    case PIN_MODE_OUTPUT_PUSH_PULL:
        return LL_GPIO_MODE_OUTPUT;
    case PIN_MODE_ALTERNATE:
        return LL_GPIO_MODE_ALTERNATE;
    case PIN_MODE_ANALOG:
    default:
        return LL_GPIO_MODE_ANALOG;
    }
}

static uint32_t convert_pin_pull_to_driver_pull(enum board_input_pin_pull pull)
{
    switch (pull)
    {
    case PIN_PULLUP:
        return LL_GPIO_PULL_UP;
    case PIN_PULLDOWN:
        return LL_GPIO_PULL_DOWN;
    case PIN_NO_PULL:
    default:
        return LL_GPIO_PULL_NO;
    }
}

static uint32_t convert_pin_speed_to_driver_speed(enum board_input_pin_speed speed)
{
    switch (speed)
    {
    case PIN_SPEED_HIGH:
        return LL_GPIO_SPEED_HIGH;
    case PIN_SPEED_MEDIUM:
        return LL_GPIO_SPEED_MEDIUM;
    case PIN_SPEED_LOW:
    default:
        return LL_GPIO_SPEED_LOW;
    }
}

static uint32_t convert_pin_mode_to_driver_output_type(enum board_pin_mode mode)
{
    switch (mode)
    {
    case PIN_MODE_OUTPUT_PUSH_PULL:
        return LL_GPIO_OUTPUT_PUSHPULL;
    case PIN_MODE_OUTPUT_OPEN_DRAIN:
    default:
        return LL_GPIO_OUTPUT_OPENDRAIN;
    }
}

static void gpio_configure(const struct gpio_pin *pin_info)
{
    LL_GPIO_InitTypeDef GPIO_InitStruct = {0};
    GPIO_InitStruct.Pin = pin_info->pin;
    GPIO_InitStruct.Mode = convert_pin_mode_to_driver_mode(pin_info->mode);
    GPIO_InitStruct.Pull = convert_pin_pull_to_driver_pull(pin_info->pull);
    GPIO_InitStruct.Speed = convert_pin_speed_to_driver_speed(pin_info->speed);
    GPIO_InitStruct.OutputType = convert_pin_mode_to_driver_output_type(pin_info->mode);
    GPIO_InitStruct.Alternate = pin_info->alternate_function;
    LL_GPIO_Init((GPIO_TypeDef *)pin_info->port, &GPIO_InitStruct);
}

enum gpio_pin_status gpio_pin_init(const void *pin_info, void **pin_handle)
{
    if (!is_initialized)
    {
        initialize_gpio_peripheral();
    }

    const struct gpio_pin *info = pin_info;
    gpio_configure(info);
    return find_or_create_pin_entry_if_not_existing(info, pin_handle);
}

void gpio_output_configure(void *pin_handle, enum board_pin_mode mode)
{
    struct pin_context *handle = pin_handle;
    struct gpio_pin pin_info;
    memcpy(&pin_info, handle->info, sizeof(struct gpio_pin));
    pin_info.mode = mode;
    gpio_configure(&pin_info);
}

void gpio_output_toggle(void *pin_handle)
{
    struct pin_context *handle = pin_handle;
    GPIO_TypeDef *driver_port = (GPIO_TypeDef *)handle->info->port;
    LL_GPIO_TogglePin(driver_port, handle->info->pin);
}

void gpio_output_set(void *pin_handle)
{
    struct pin_context *handle = pin_handle;
    GPIO_TypeDef *driver_port = (GPIO_TypeDef *)handle->info->port;
    LL_GPIO_SetOutputPin(driver_port, handle->info->pin);
}

void gpio_output_clear(void *pin_handle)
{
    struct pin_context *handle = pin_handle;
    GPIO_TypeDef *driver_port = (GPIO_TypeDef *)handle->info->port;
    LL_GPIO_ResetOutputPin(driver_port, handle->info->pin);
}

static void set_pin_pullup_down(struct pin_context *handle, enum board_input_pin_pull pull)
{
    uint32_t driver_pull = convert_pin_pull_to_driver_pull(pull);
    GPIO_TypeDef *driver_port = (GPIO_TypeDef *)handle->info->port;
    LL_GPIO_SetPinPull(driver_port, handle->info->pin, driver_pull);
}

void gpio_configure_pullup_down(void *pin_handle, enum gpio_pin_pull pull)
{
    struct pin_context *handle = pin_handle;
    set_pin_pullup_down(handle, (enum board_input_pin_pull)pull);
}

void gpio_input_interrupt_enable(void *pin_handle)
{
    struct pin_context *handle = pin_handle;
    LL_EXTI_EnableIT_0_31(handle->exti.exti_line);
}

void gpio_input_interrupt_disable(void *pin_handle)
{
    struct pin_context *handle = pin_handle;
    LL_EXTI_DisableIT_0_31(handle->exti.exti_line);
}

static uint8_t pin_polarity_to_driver_edge_trigger(enum interrupt_pin_polarity polarity)
{
    switch (polarity)
    {
    case INTERRUPT_PIN_POLARITY_HITOLO:
        return LL_EXTI_TRIGGER_FALLING;
    case INTERRUPT_PIN_POLARITY_LOTOHI:
        return LL_EXTI_TRIGGER_RISING;
    case INTERRUPT_PIN_POLARITY_TOGGLE:
    default:
        return LL_EXTI_TRIGGER_RISING_FALLING;
    }
}

static void configure_exti(struct pin_context *handle, uint8_t edge_trigger)
{
    LL_SYSCFG_SetEXTISource(handle->exti.sysconf_exti_port, handle->exti.sysconf_exti_line);

    LL_EXTI_InitTypeDef EXTI_InitStruct = {0};
    EXTI_InitStruct.Line_0_31 = handle->exti.exti_line;
    EXTI_InitStruct.LineCommand = ENABLE;
    EXTI_InitStruct.Mode = LL_EXTI_MODE_IT;
    EXTI_InitStruct.Trigger = edge_trigger;
    LL_EXTI_Init(&EXTI_InitStruct);
}

static void configure_nvic(uint32_t IRQ)
{
    NVIC_EnableIRQ(IRQ);
    NVIC_SetPriority(IRQ, 0);
}

static uint8_t get_edge_trigger_from_pin_polarity_and_activity(struct pin_context *handle,
                                                               struct input_pin_config *input_config)
{
    enum interrupt_pin_polarity polarity =
        interrupt_pin_polarity_from_activity(handle->info->polarity, input_config->activity);
    uint8_t edge_trigger = pin_polarity_to_driver_edge_trigger(polarity);
    return edge_trigger;
}

static void configure_external_interrupt(struct pin_context *handle, struct input_pin_config *input_config,
                                         bool int_enabled)
{
    uint8_t edge_trigger;
    edge_trigger = get_edge_trigger_from_pin_polarity_and_activity(handle, input_config);
    configure_exti(handle, edge_trigger);
    configure_nvic(handle->exti.IRQ);

    if (int_enabled)
    {
        LL_EXTI_EnableIT_0_31(handle->exti.exti_line);
    }
}

void gpio_input_configure(void *pin_handle, struct input_pin_config *input_config, bool int_enabled)
{
    struct pin_context *handle = pin_handle;
    if (input_config)
    {
        entry_update(handle, input_config);
        set_pin_pullup_down(handle, handle->info->pull);
        configure_external_interrupt(handle, input_config, int_enabled);
    }
    else
    {
        struct gpio_pin pin_info;
        memcpy(&pin_info, handle->info, sizeof(struct gpio_pin));
        pin_info.mode = PIN_MODE_INPUT;
        gpio_configure(&pin_info);
    }
}

bool gpio_input_is_active(void *pin_handle)
{
    struct pin_context *handle = (struct pin_context *)pin_handle;
    bool level = LL_GPIO_IsInputPinSet((GPIO_TypeDef *)handle->info->port, handle->info->pin);
    return handle->info->polarity == ACTIVE_HIGH ? level : !level;
}
