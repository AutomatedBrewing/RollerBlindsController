cmake_minimum_required(VERSION 3.20)
project(user_app C)

add_library(${PROJECT_NAME} STATIC app_init.c)
target_link_libraries(${PROJECT_NAME} PRIVATE fw-lib)

include(${WARNINGS_FLAGS_FILE})
target_compile_options(${PROJECT_NAME} PRIVATE ${WARNINGS})