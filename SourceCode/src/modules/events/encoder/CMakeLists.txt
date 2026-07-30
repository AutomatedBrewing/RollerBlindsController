target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/encoder_rotation_left_event.c
    ${CMAKE_CURRENT_LIST_DIR}/encoder_rotation_right_event.c
    ${CMAKE_CURRENT_LIST_DIR}/encoder_switch_pressed_event.c)
