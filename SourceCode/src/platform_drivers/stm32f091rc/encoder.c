/*
 * encoder.c
 *
 *  Created on: 22 Mar 2023
 *      Author: dev
 */
/* Private includes ----------------------------------------------------------*/
#include "encoder.h"
#include "gpio.h"
#include "stm32f0xx_ll_bus.h"
#include "stm32f0xx_ll_gpio.h"
#include "stm32f0xx_ll_tim.h"

#include "em_event.h"
#include "encoder_rotation_left_event.h"
#include "encoder_rotation_right_event.h"
/* Private define ------------------------------------------------------------*/
#define TICKS_PER_ROTATION (20)

/* Private typedef -----------------------------------------------------------*/
struct encoder_context
{
    const void *channel_A_pin_info;
    const void *channel_B_pin_info;
    void *channel_A_handle;
    void *channel_B_handle;
    void *rotation_left_event;
    void *rotation_right_event;
};

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
struct encoder_context encoder = {0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void send_rotation_left_message(void)
{
    union encoder_rotation_left_message message = {0};
    em_set_message_event(&message.event.super, encoder.rotation_left_event);
    em_publish_message(&message);
}

static void send_rotation_right_message(void)
{
    union encoder_rotation_right_message message = {0};
    message.event.super.id = encoder.rotation_right_event;
    em_publish_message(&message);
}

static void find_direction_of_rotation_and_send_event(void)
{
    uint32_t direction = LL_TIM_GetDirection(TIM1);
    if (direction == LL_TIM_COUNTERDIRECTION_UP)
    {
        send_rotation_left_message();
    }
    else if (direction == LL_TIM_COUNTERDIRECTION_DOWN)
    {
        send_rotation_right_message();
    }
}

void TIM1_CC_IRQHandler(void)
{
    if (LL_TIM_IsActiveFlag_CC1(TIM1))
    {
        LL_TIM_ClearFlag_CC1(TIM1);
    }

    find_direction_of_rotation_and_send_event();
}

static void initialize_timer_in_encoder_mode(void)
{
    LL_TIM_InitTypeDef timer_init_structure = {0};
    LL_TIM_StructInit(&timer_init_structure);
    timer_init_structure.Autoreload = TICKS_PER_ROTATION;
    LL_TIM_Init(TIM1, &timer_init_structure);

    LL_TIM_ENCODER_InitTypeDef encoder_init_structure = {0};
    LL_TIM_ENCODER_StructInit(&encoder_init_structure);
    LL_TIM_ENCODER_Init(TIM1, &encoder_init_structure);
}

static void enable_irq_for_timer(void)
{
    NVIC_EnableIRQ(TIM1_CC_IRQn);
    NVIC_SetPriority(TIM1_CC_IRQn, 3);
}

static void enable_timer_compare_channel(void)
{
    LL_TIM_EnableIT_CC1(TIM1);
    LL_TIM_CC_EnableChannel(TIM1, LL_TIM_CHANNEL_CH1);
}

void encoder_init(const void *pin_info_channel_A, const void *pin_info_channel_B, void *event_rotation_left,
                  void *event_rotation_right)
{
    encoder.channel_A_pin_info = pin_info_channel_A;
    encoder.channel_B_pin_info = pin_info_channel_B;
    encoder.rotation_left_event = event_rotation_left;
    encoder.rotation_right_event = event_rotation_right;

    gpio_pin_init(encoder.channel_A_pin_info, &encoder.channel_A_handle);
    gpio_pin_init(encoder.channel_B_pin_info, &encoder.channel_B_handle);

    LL_APB1_GRP2_EnableClock(LL_APB1_GRP2_PERIPH_TIM1);
    initialize_timer_in_encoder_mode();
    enable_irq_for_timer();
    enable_timer_compare_channel();
    LL_TIM_EnableCounter(TIM1);
}
