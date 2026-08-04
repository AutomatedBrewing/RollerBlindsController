target_include_directories(${FW_LIBRARY_TARGET} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
add_subdirectory(${CPU})
add_subdirectory(drivers_mocks)