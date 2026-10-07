target_sources(${FW_LIBRARY_TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/soft_queue.c
)


target_include_directories(${FW_LIBRARY_TARGET} SYSTEM PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
)
