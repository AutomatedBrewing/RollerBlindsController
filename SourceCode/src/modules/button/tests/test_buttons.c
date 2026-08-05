/*
 * test_blink.c
 *
 *  Created on: 3 Oct 2022
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <cmocka.h>

#include "hsm_button.h"
#include "hsm_button_internal.h"

#include "cmsis_mock.h"
#include "gpio_mock.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void test_init(void **state)
{
    const struct subscriber *test_subscriber = &button_subscriber;
    struct hsm_button_context *context = &buttons[0];
    test_subscriber->init(0);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_init),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
