/*
 * test_executor_1.c
 *
 *  Created on: 3 Oct 2022
 *      Author: dev
 */

/* Private includes ----------------------------------------------------------*/
#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>

#include <cmocka.h>

#include "cmsis_os.h"
#include "em_executor.h"
#include "em_system_events.h"

#include "cmsis_mock.h"

/* Included to test static functions. */
#include "em_executor.c"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static struct executor test_executor_1 = {0};
static struct executor test_executor_2 = {0};

struct test_event
{
    struct event super;
};
MESSAGE_TYPE(test_event, test_message);

static void fill_test_message(union test_message *message, void *id)
{
    message->event.super.id = id;
}

/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/

static void handle_shutdown_event(void)
{
    function_called();
}

static void expect_shutdown_event(void)
{
    expect_function_call(handle_shutdown_event);
}

static void handle_init_event(uint32_t flags)
{
    function_called();
    check_expected_any(flags);
}

static void expect_init_event(uint32_t flags)
{
    expect_function_call(handle_init_event);
    expect_value(handle_init_event, flags, flags);
}

static void handle_test_event(void *event)
{
    function_called();
    struct event *p_event = event;
    check_expected_any(p_event->id);
}

static void expect_handle_event(struct event *event)
{
    expect_function_call(handle_test_event);
    expect_value(handle_test_event, p_event->id, event);
}

static void test_create_executor(void **state)
{
    struct executor executor = {0};
    bool result;
    osThreadId_t expected_thread_id = (osThreadId_t)0x69;
    osMessageQueueId_t expected_queue_id = (osMessageQueueId_t)0x70;
    uint8_t enqueued_events = 4;

    expect_osThreadNew(&executor, NULL, expected_thread_id);
    expect_osMessageQueueNew(enqueued_events, EVENT_SIZE, NULL, expected_queue_id);
    result = em_create_executor(&executor, NULL, enqueued_events);
    assert_true(result);

    /* Thread creation returns NULL. */
    expect_osThreadNew(&executor, NULL, NULL);
    result = em_create_executor(&executor, NULL, enqueued_events);
    assert_false(result);

    /* Queue creation returns NULL. */
    expect_osThreadNew(&executor, NULL, expected_thread_id);
    expect_osMessageQueueNew(enqueued_events, EVENT_SIZE, NULL, NULL);
    result = em_create_executor(&executor, NULL, enqueued_events);
    assert_false(result);
}

static void test_create_executor_statically(void **state)
{
    struct executor executor = {0};
    bool result;
    osThreadId_t expected_thread_id = (osThreadId_t)0x69;
    osMessageQueueId_t expected_queue_id = (osMessageQueueId_t)0x70;
    uint8_t enqueued_events = 4;

    /* Create task with defined stack size*/
    const osThreadAttr_t thread1_attr = {
        .stack_size = 1024 // Create the thread stack with a size of 1024 bytes
    };
    expect_osThreadNew(&executor, &thread1_attr, expected_thread_id);
    expect_osMessageQueueNew(enqueued_events, EVENT_SIZE, NULL, expected_queue_id);
    result = em_create_executor(&executor, &thread1_attr, enqueued_events);
    assert_true(result);

    /* Create task with statically stack. */
    static uint64_t thread2_stack[64];
    const osThreadAttr_t thread2_attr = {.stack_mem = &thread2_stack[0], .stack_size = sizeof(thread2_stack)};
    expect_osThreadNew(&executor, &thread2_attr, expected_thread_id);
    expect_osMessageQueueNew(enqueued_events, EVENT_SIZE, NULL, expected_queue_id);
    result = em_create_executor(&executor, &thread2_attr, enqueued_events);
    assert_true(result);
}

static void test_dispatch_one_event(void **state)
{
    static const struct subscriber test_subscriber = {.handle_event = handle_test_event};

    CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(test_executor_1_subscribers, test_executor_1,
                                           ADD_SUBSCRIBER(&test_subscriber))
    CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(test_executor_2_subscribers, test_executor_2,
                                           ADD_SUBSCRIBER(&test_subscriber))
    CREATE_EVENT(test_event, ADD_SUBSCRIBER(&test_executor_1_subscribers, &test_executor_2_subscribers))

    union test_message msg;
    fill_test_message(&msg, (struct event *)test_event_executors_list);

    expect_handle_event((struct event *)test_event_executors_list);
    dispatch_event(&test_executor_1, (struct event *)&msg);

    expect_handle_event((struct event *)test_event_executors_list);
    dispatch_event(&test_executor_2, (struct event *)&msg);
}

static void test_dispatch_event_without_valid_executors(void **state)
{
    static const struct subscriber test_subscriber = {.handle_event = handle_test_event};

    CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(test_executor_1_subscribers, test_executor_1,
                                           ADD_SUBSCRIBER(&test_subscriber))
    CREATE_EVENT(test_event, ADD_SUBSCRIBER(&test_executor_1_subscribers))

    union test_message msg;
    fill_test_message(&msg, (struct event *)test_event_executors_list);

    dispatch_event(&test_executor_2, (struct event *)&msg);
}

static void test_executor_init_the_subscribers(void **state)
{
    static const struct subscriber test_subscriber_1 = {
        .init_flags = 0x69, .init = handle_init_event, .handle_event = handle_test_event};
    static const struct subscriber test_subscriber_2 = {
        .init_flags = 0x70, .init = handle_init_event, .handle_event = handle_test_event};
    CREATE_EXECUTOR_WITH_SUPPORTED_SUBSCRIBERS(test_executor_4, ADD_SUBSCRIBER(&test_subscriber_1, &test_subscriber_2))

    expect_init_event(0x69);
    expect_init_event(0x70);
    initialize_all_subscribers(&test_executor_4);
}

static void test_executor_shutdown_the_subscribers(void **state)
{
    static const struct subscriber test_subscriber_1 = {.shutdown = handle_shutdown_event};
    static const struct subscriber test_subscriber_2 = {.shutdown = handle_shutdown_event};
    static const struct subscriber test_subscriber_3 = {};
    CREATE_EXECUTOR_WITH_SUPPORTED_SUBSCRIBERS(
        test_executor, ADD_SUBSCRIBER(&test_subscriber_1, &test_subscriber_2, &test_subscriber_3))

    expect_shutdown_event();
    expect_shutdown_event();
    dispatch_event(&test_executor, SHUTDOWN_EVENT_ID);
}

static void test_publish_message(void **state)
{
    static const struct subscriber test_subscriber = {.handle_event = handle_test_event};
    CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(test_executor_1_subscribers, test_executor_1,
                                           ADD_SUBSCRIBER(&test_subscriber))
    CREATE_LIST_OF_SUBSCRIBERS_IN_EXECUTOR(test_executor_2_subscribers, test_executor_2,
                                           ADD_SUBSCRIBER(&test_subscriber))
    CREATE_EVENT(test_event, ADD_SUBSCRIBER(&test_executor_1_subscribers, &test_executor_2_subscribers))

    union test_message msg;
    fill_test_message(&msg, (struct event *)test_event_executors_list);

    expect_osMessageQueuePut(test_executor_1.queue, &msg, sizeof(union test_message), 0, osOK);
    expect_osMessageQueuePut(test_executor_1.queue, &msg, sizeof(union test_message), 0, osOK);
    em_publish_message(&msg);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_create_executor),
        cmocka_unit_test(test_create_executor_statically),
        cmocka_unit_test(test_dispatch_one_event),
        cmocka_unit_test(test_dispatch_event_without_valid_executors),
        cmocka_unit_test(test_executor_init_the_subscribers),
        cmocka_unit_test(test_executor_shutdown_the_subscribers),
        cmocka_unit_test(test_publish_message),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}
