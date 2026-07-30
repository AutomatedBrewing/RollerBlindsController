
target_sources(${FW_LIBRARY_TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/clock.c
    ${CMAKE_CURRENT_LIST_DIR}/encoder.c
    ${CMAKE_CURRENT_LIST_DIR}/flash.c
    ${CMAKE_CURRENT_LIST_DIR}/gpio.c
    ${CMAKE_CURRENT_LIST_DIR}/interrupt.c
    ${CMAKE_CURRENT_LIST_DIR}/log.c
    ${CMAKE_CURRENT_LIST_DIR}/rtc.c
    ${CMAKE_CURRENT_LIST_DIR}/syscalls.c
    ${CMAKE_CURRENT_LIST_DIR}/sysmem.c
    ${CMAKE_CURRENT_LIST_DIR}/system_stm32f0xx.c
)

add_subdirectory(display)

target_include_directories(${FW_LIBRARY_TARGET} PUBLIC . )
include(${WARNINGS_FLAGS_FILE})
