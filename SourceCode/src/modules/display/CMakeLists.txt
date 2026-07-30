target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm_display_root.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_display_displaying.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_display_editing.c)

add_subdirectory(display_layers)
