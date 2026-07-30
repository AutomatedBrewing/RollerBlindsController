target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/get_irrigation_schedule_event.c
    ${CMAKE_CURRENT_LIST_DIR}/get_irrigation_schedule_answer_event.c
    ${CMAKE_CURRENT_LIST_DIR}/set_irrigation_schedule_event.c)
