target_sources(${FW_LIBRARY_TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/cmsis_os2.c
)

add_subdirectory(timer)
add_subdirectory(queue)

target_include_directories(${FW_LIBRARY_TARGET} SYSTEM PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
)
