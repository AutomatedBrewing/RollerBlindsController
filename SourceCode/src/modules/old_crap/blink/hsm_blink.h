/*
 * blink.h
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

#ifndef SRC_BLINK_BLINK_H_
#define SRC_BLINK_BLINK_H_

/* Private includes ----------------------------------------------------------*/
/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct blink_context
{
    const struct gpio_pin *led_info;
    const struct gpio_pin *button_info;
    void *led_handle;
    void *button_handle;
};
/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
extern const struct subscriber blink_subscriber;
extern struct blink_context blink_context;
/* Public function prototypes ------------------------------------------------*/

#endif /* SRC_BLINK_BLINK_H_ */
