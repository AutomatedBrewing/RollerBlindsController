target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/em_executor.c
    ${CMAKE_CURRENT_LIST_DIR}/em_timer.c
    ${CMAKE_CURRENT_LIST_DIR}/em_system_events.c)

add_subdirectory(test)
