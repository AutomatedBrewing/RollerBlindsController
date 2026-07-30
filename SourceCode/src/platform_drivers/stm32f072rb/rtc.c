/*
 * rtc.c
 *
 *  Created on: 16 Mar 2023
 *      Author: dev
 */

#include "rtc.h"
#include <stdbool.h>

#include "stm32f0xx_ll_cortex.h"
#include "stm32f0xx_ll_pwr.h"
#include "stm32f0xx_ll_rcc.h"
#include "stm32f0xx_ll_rtc.h"

#define BIN2BCD(__VALUE__) (uint8_t)((((__VALUE__) / 10U) << 4U) | ((__VALUE__) % 10U))
#define BCD2BIN(__VALUE__)                                                                                             \
    (uint8_t)(((uint8_t)((__VALUE__) & (uint8_t)0xF0U) >> (uint8_t)0x4U) * (uint8_t)10U +                              \
              (uint8_t)((__VALUE__) & (uint8_t)0x0FU))

/* Defines related to Clock configuration */
#ifdef RTC_CLOCK_SOURCE_LSI
#define RTC_ASYNCH_PREDIV ((uint32_t)0x7F)
#define RTC_SYNCH_PREDIV ((uint32_t)0x137)
#endif

#ifdef RTC_CLOCK_SOURCE_LSE
#define RTC_ASYNCH_PREDIV ((uint32_t)0x7F)
#define RTC_SYNCH_PREDIV ((uint32_t)0x00FF)
#endif

#define RTC_BKP_DATE_TIME_UPDTATED ((uint32_t)0x32F2)

static void enter_rtc_initialization_mode(void)
{
    LL_RTC_DisableWriteProtection(RTC);
    LL_RTC_EnableInitMode(RTC);
    while (LL_RTC_IsActiveFlag_INIT(RTC) != 1)
    {
    }
}

static void wait_until_rtc_clock_is_synchronised(void)
{
    LL_RTC_ClearFlag_RS(RTC);

    while (LL_RTC_IsActiveFlag_RS(RTC) != 1)
    {
    }
}

void exit_rtc_initialization_mode(void)
{
    LL_RTC_DisableInitMode(RTC);
    wait_until_rtc_clock_is_synchronised();
    LL_RTC_EnableWriteProtection(RTC);
}

#ifdef RTC_CLOCK_SOURCE_LSI
void configure_rtc_for_internal_clock(void)
{
    LL_RCC_LSI_Enable();
    while (LL_RCC_LSI_IsReady() != 1)
    {
    }
    /* Reset backup domain only if LSI is not yet selected as RTC clock source */
    if (LL_RCC_GetRTCClockSource() != LL_RCC_RTC_CLKSOURCE_LSI)
    {
        LL_RCC_ForceBackupDomainReset();
        LL_RCC_ReleaseBackupDomainReset();
        LL_RCC_SetRTCClockSource(LL_RCC_RTC_CLKSOURCE_LSI);
    }
}
#endif // RTC_CLOCK_SOURCE_LSI

#ifdef RTC_CLOCK_SOURCE_LSE
void configure_rtc_for_external_clock(void)
{
    if (LL_RCC_LSE_IsReady() == 0)
    {
        LL_RCC_ForceBackupDomainReset();
        LL_RCC_ReleaseBackupDomainReset();
        LL_RCC_LSE_Enable();
        while (LL_RCC_LSE_IsReady() != 1)
        {
        }
        LL_RCC_SetRTCClockSource(LL_RCC_RTC_CLKSOURCE_LSE);
    }
}
#endif // RTC_CLOCK_SOURCE_LSE

void enable_rtc_clock(void)
{
    LL_PWR_EnableBkUpAccess();
#ifdef RTC_CLOCK_SOURCE_LSI
    configure_rtc_for_internal_clock();
#elif RTC_CLOCK_SOURCE_LSE
    configure_rtc_for_external_clock();
#endif
}

static void initialize_rtc_settings(void)
{
    LL_RTC_InitTypeDef RTC_InitStruct;
    RTC_InitStruct.HourFormat = LL_RTC_HOURFORMAT_24HOUR;
    RTC_InitStruct.AsynchPrescaler = RTC_ASYNCH_PREDIV;
    RTC_InitStruct.SynchPrescaler = RTC_SYNCH_PREDIV;
    LL_RTC_Init(RTC, &RTC_InitStruct);
}

static bool rtc_has_been_configured(void)
{
    return LL_RTC_BAK_GetRegister(RTC, LL_RTC_BKP_DR1) == RTC_BKP_DATE_TIME_UPDTATED;
}

static void rtc_reset_data_time_to_default(void)
{
    LL_RTC_DATE_Config(RTC, LL_RTC_WEEKDAY_MONDAY, BIN2BCD(3), LL_RTC_MONTH_JANUARY, BIN2BCD(22));
    LL_RTC_TIME_Config(RTC, LL_RTC_TIME_FORMAT_AM_OR_24, BIN2BCD(11), BIN2BCD(22), BIN2BCD(33));
    LL_RTC_BAK_SetRegister(RTC, LL_RTC_BKP_DR1, RTC_BKP_DATE_TIME_UPDTATED);
}

void rtc_initialize(void)
{
    enable_rtc_clock();
    LL_RCC_EnableRTC();

    enter_rtc_initialization_mode();
    initialize_rtc_settings();
    if (!rtc_has_been_configured())
    {
        rtc_reset_data_time_to_default();
    }
    exit_rtc_initialization_mode();
}

static enum rtc_month drivers_month_to_month(uint32_t month)
{
    switch (month)
    {
    case LL_RTC_MONTH_FEBRUARY:
        return FEBURARY;
    case LL_RTC_MONTH_MARCH:
        return MARCH;
    case LL_RTC_MONTH_APRIL:
        return APRIL;
    case LL_RTC_MONTH_MAY:
        return MAY;
    case LL_RTC_MONTH_JUNE:
        return JUNE;
    case LL_RTC_MONTH_JULY:
        return JULY;
    case LL_RTC_MONTH_AUGUST:
        return AUGUST;
    case LL_RTC_MONTH_SEPTEMBER:
        return SEPTEMBER;
    case LL_RTC_MONTH_OCTOBER:
        return OCTOBER;
    case LL_RTC_MONTH_NOVEMBER:
        return NOVEMBER;
    case LL_RTC_MONTH_DECEMBER:
        return DECEMBER;
    case LL_RTC_MONTH_JANUARY:
    default:
        return JANURAY;
    }
}

static uint32_t month_to_drivers_month(enum rtc_month month)
{
    switch (month)
    {
    case FEBURARY:
        return LL_RTC_MONTH_FEBRUARY;
    case MARCH:
        return LL_RTC_MONTH_MARCH;
    case APRIL:
        return LL_RTC_MONTH_APRIL;
    case MAY:
        return LL_RTC_MONTH_MAY;
    case JUNE:
        return LL_RTC_MONTH_JUNE;
    case JULY:
        return LL_RTC_MONTH_JULY;
    case AUGUST:
        return LL_RTC_MONTH_AUGUST;
    case SEPTEMBER:
        return LL_RTC_MONTH_SEPTEMBER;
    case OCTOBER:
        return LL_RTC_MONTH_OCTOBER;
    case NOVEMBER:
        return LL_RTC_MONTH_NOVEMBER;
    case DECEMBER:
        return LL_RTC_MONTH_DECEMBER;
    case JANURAY:
    default:
        return LL_RTC_MONTH_JANUARY;
    }
}

static enum rtc_weekday drivers_weekday_to_weekday(uint32_t weekday)
{
    switch (weekday)
    {
    case LL_RTC_WEEKDAY_TUESDAY:
        return TUESDAY;
    case LL_RTC_WEEKDAY_WEDNESDAY:
        return WENDESDAY;
    case LL_RTC_WEEKDAY_THURSDAY:
        return THURSDAY;
    case LL_RTC_WEEKDAY_FRIDAY:
        return FRIDAY;
    case LL_RTC_WEEKDAY_SATURDAY:
        return SATURDAY;
    case LL_RTC_WEEKDAY_SUNDAY:
        return SUNDAY;
    case LL_RTC_WEEKDAY_MONDAY:
    default:
        return MONDAY;
    }
}

static uint32_t weekday_to_drivers_weekday(enum rtc_weekday weekday)
{
    switch (weekday)
    {
    case TUESDAY:
        return LL_RTC_WEEKDAY_TUESDAY;
    case WENDESDAY:
        return LL_RTC_WEEKDAY_WEDNESDAY;
    case THURSDAY:
        return LL_RTC_WEEKDAY_THURSDAY;
    case FRIDAY:
        return LL_RTC_WEEKDAY_FRIDAY;
    case SATURDAY:
        return LL_RTC_WEEKDAY_SATURDAY;
    case SUNDAY:
        return LL_RTC_WEEKDAY_SUNDAY;
    case MONDAY:
    default:
        return LL_RTC_WEEKDAY_MONDAY;
    }
}

void rtc_read_time_and_date(struct rtc_data_time *data_time)
{
    data_time->hour = BCD2BIN(LL_RTC_TIME_GetHour(RTC));
    data_time->minute = BCD2BIN(LL_RTC_TIME_GetMinute(RTC));
    data_time->second = BCD2BIN(LL_RTC_TIME_GetSecond(RTC));

    data_time->year = BCD2BIN(LL_RTC_DATE_GetYear(RTC));
    uint32_t month = LL_RTC_DATE_GetMonth(RTC);
    data_time->month = drivers_month_to_month(month);
    data_time->day = BCD2BIN(LL_RTC_DATE_GetDay(RTC));
    uint32_t weekday = LL_RTC_DATE_GetWeekDay(RTC);
    data_time->week_day = drivers_weekday_to_weekday(weekday);
}

void rtc_write_time_and_date(struct rtc_data_time *data_time)
{
    enter_rtc_initialization_mode();

    uint32_t month = month_to_drivers_month(data_time->month);
    uint32_t weekday = weekday_to_drivers_weekday(data_time->week_day);

    LL_RTC_DATE_Config(RTC, weekday, BIN2BCD(data_time->day), month, BIN2BCD(data_time->year));
    LL_RTC_TIME_Config(RTC, LL_RTC_TIME_FORMAT_AM_OR_24, BIN2BCD(data_time->hour), BIN2BCD(data_time->minute),
                       BIN2BCD(data_time->second));

    exit_rtc_initialization_mode();
}
