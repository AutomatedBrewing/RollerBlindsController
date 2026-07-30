target_include_directories(${FW_LIBRARY_TARGET} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}
    ${HSM_CONFIG_HEADER_PATH})

target_sources(${FW_LIBRARY_TARGET} PRIVATE 
    ${CMAKE_CURRENT_LIST_DIR}/hsm.c)

target_compile_definitions(${FW_LIBRARY_TARGET} PRIVATE HSM_CONFIG)

add_subdirectory(test)