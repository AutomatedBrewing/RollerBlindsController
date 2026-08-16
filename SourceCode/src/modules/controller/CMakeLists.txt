target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_root.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_idle.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_any_mode_candidate.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_auto_mode.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_manual_mode.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_config_mode.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_config_mode_time_counting.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_controller_internals.c)

#add_subdirectory(tests)