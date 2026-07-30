target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm_scheduler_root.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_scheduler_waiting.c
    ${CMAKE_CURRENT_LIST_DIR}/hsm_scheduler_active.c)

add_subdirectory(valves)
add_subdirectory(backup)