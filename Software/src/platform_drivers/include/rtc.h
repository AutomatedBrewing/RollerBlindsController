/*
 * rtc.h
 *
 *  Created on: 16 Mar 2023
 *      Author: dev
 */

#ifndef SRC_PLATFORM_DRIVERS_INCLUDE_RTC_H_
#define SRC_PLATFORM_DRIVERS_INCLUDE_RTC_H_

#include <stdint.h>

enum rtc_weekday
{
    MONDAY,
    TUESDAY,
    WENDESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
};

enum rtc_month
{
    JANURAY,
    FEBURARY,
    MARCH,
    APRIL,
    MAY,
    JUNE,
    JULY,
    AUGUST,
    SEPTEMBER,
    OCTOBER,
    NOVEMBER,
    DECEMBER
};

struct rtc_data_time
{
    uint8_t year;
    enum rtc_month month;
    enum rtc_weekday week_day;
    uint8_t day;
    uint8_t hour;
    uint8_t minute;
    uint8_t second;
};

/**
 * Init the RTC
 */
void rtc_initialize(void);

/**
 * Read the current unix timestamp
 * @return  unix timestamp
 */
void rtc_read_time_and_date(struct rtc_data_time *data_time);

/**
 * Write the current unix timestamp
 * @param unix_timestamp: pointer from where to read the new information
 */
void rtc_write_time_and_date(struct rtc_data_time *data_time);

#endif /* SRC_PLATFORM_DRIVERS_INCLUDE_RTC_H_ */
