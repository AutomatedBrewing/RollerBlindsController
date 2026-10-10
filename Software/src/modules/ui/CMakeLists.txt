target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm_ui_root.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_ui_idle.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_ui_notifying.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_ui_active.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_ui_inactive.c)

add_subdirectory(buzzer)
add_subdirectory(tests)