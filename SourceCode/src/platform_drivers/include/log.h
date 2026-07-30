/*
 * log.h
 *
 *  Created on: 30 Sep 2022
 *      Author: Kamil Lazowski
 */

#ifndef SRC_PLATFORM_DRIVERS_INCLUDE_LOG_H_
#define SRC_PLATFORM_DRIVERS_INCLUDE_LOG_H_

/* Private includes ----------------------------------------------------------*/
/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

/* @brief Initialize the log backend.
 * */
void log_initialize(void);

/* @brief Logs the string.
 * @par string String to log.
 * */
void log_string(const char *string);

/* @brief Logs the string in printf style.
 * @par string String to log.
 * */
void log_printf(const char *string, ...);

/* @brief Logs the single character.
 * @par c Char to log.
 * */
void log_putc(char c);

#endif /* SRC_PLATFORM_DRIVERS_INCLUDE_LOG_H_ */
