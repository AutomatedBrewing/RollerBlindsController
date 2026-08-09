target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_root.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_released.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_pressed.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_pressed_short.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_pressed_long.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_pressed_very_long.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_button_internal.c)

add_subdirectory(tests)