target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm_motor_root.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_motor_idle.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_motor_moves_up.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_motor_moves_down.c)

add_subdirectory(tests)