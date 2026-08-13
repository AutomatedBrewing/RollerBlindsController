/*
 * ui_notify_event.h
 *
 *  Created on: 11 Mar 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_EVENTS_UI_NOTIFY_EVENT_H_
#define SRC_MODULES_EVENTS_UI_NOTIFY_EVENT_H_

#include "em_event.h"

struct ui_notify_event
{
    struct event super;
};

MESSAGE_TYPE(ui_notify_event, ui_notify_message)

DECLARE_EVENT(UI_NOTIFY_EVENT)
#define UI_NOTIFY_EVENT_ID ID_OF(UI_NOTIFY_EVENT)

#endif /* SRC_MODULES_EVENTS_UI_NOTIFY_EVENT_H_ */
