
target_sources(${FW_LIBRARY_TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/clock.c
    ${CMAKE_CURRENT_LIST_DIR}/gpio.c
    ${CMAKE_CURRENT_LIST_DIR}/interrupt.c
    ${CMAKE_CURRENT_LIST_DIR}/syscalls.c
    ${CMAKE_CURRENT_LIST_DIR}/sysmem.c
    ${CMAKE_CURRENT_LIST_DIR}/system_stm32f0xx.c
)

target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR} )
