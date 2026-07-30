#add_subdirectory(include)
add_subdirectory(${HARDWARE})

cmake_minimum_required(VERSION 3.20)
project(hardware_pins C)

add_library(${PROJECT_NAME} STATIC ${CMAKE_CURRENT_LIST_DIR}/${HARDWARE}/gpio_pins.c )
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)

if (CMAKE_CROSSCOMPILING)
target_link_libraries(${PROJECT_NAME} vendor_drivers)
endif()

