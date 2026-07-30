set(HAS_OS_EXTERNAL_LIB TRUE CACHE STRING "Target has vendor specific drivers." FORCE)

project(freertos)

set(FREERTOS_SOURCE_FILES 
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/portable/GCC/ARM_CM0/port.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/portable/MemMang/heap_4.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/croutine.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/event_groups.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/list.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/queue.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/stream_buffer.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/tasks.c
    ${CMAKE_CURRENT_LIST_DIR}/FreeRTOS-Kernel/timers.c)

add_library(${PROJECT_NAME} STATIC ${FREERTOS_SOURCE_FILES})

if (NOT FREERTOS_CONFIG_HEADER_PATH)
    message(SEND_ERROR "Please specify the FreeRTOS configuration header by setting FREERTOS_CONFIG_HEADER_PATH.")
endif()

target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC
    .
    FreeRTOS-Kernel/include 
    FreeRTOS-Kernel/portable/GCC/ARM_CM0
    ${FREERTOS_CONFIG_HEADER_PATH}
)
