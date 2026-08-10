/*
 * blink.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/

#include "cmsis_os.h"
#include <stdlib.h>
#include <string.h>

#include "em_event.h"
#include "hsm.h"

#include "hsm_controller.h"
#include "hsm_controller_states.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
//static struct hsm_controller_context controller = {0};

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void handle_init_event(uint32_t flags)
{
    (void)(flags);

}

static void handle_test_event(void *event)
{
    (void)(event);
    //machine.Event = event;
   // dispatch_event(machineList, 1);
}


static state_machine_result_t event_handler(state_machine_t *const pmachine)
{
    (void)(pmachine);
    //struct event *event_id = pmachine->Event;

    return EVENT_UN_HANDLED;
}

const struct subscriber controller_subscriber = {.init = handle_init_event, .handle_event = handle_test_event};

const state_t hsm_controller_root[] = {
    {event_handler, NULL, NULL, NULL, NULL, 0},
};
