target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}
    ${BAREMETAL_CONFIG_HEADER_PATH})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/em_executor.c
    ${CMAKE_CURRENT_LIST_DIR}/em_timer.c
    ${CMAKE_CURRENT_LIST_DIR}/em_system_events.c
    ${CMAKE_CURRENT_LIST_DIR}/em_executor_memory.c)

add_subdirectory(test)
add_subdirectory(mocks)