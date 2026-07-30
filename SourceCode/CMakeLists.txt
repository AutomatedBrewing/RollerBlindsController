cmake_minimum_required(VERSION 3.20)

# Enable compile_commands.json generation for clang-tidy
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(ROOT_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE PATH "Root Directory" FORCE)
set(APP_DIR ${ROOT_DIR}/src/apps CACHE PATH "Application Directory" FORCE)
set(MAIN_APP_DIR ${ROOT_DIR}/src/common CACHE PATH "Main application directory" FORCE)

    
#Location of cmake scripts.
set(CMAKE_SCRIPTS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(WARNINGS_FLAGS_FILE ${CMAKE_SCRIPTS_DIR}/compiler_flags.cmake)

include(${CMAKE_CURRENT_LIST_DIR}/targets/${CONFIG}/config_${CONFIG}.cmake)
include(${CMAKE_SCRIPTS_DIR}/cmocka.cmake)




project(example_app VERSION 0.0.1 LANGUAGES C ASM)

set(AUTOBREWING_FIRMWARE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(AUTOBREWING_FIRMWARE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(AUTOBREWING_FIRMWARE_VERSION_REVISION ${PROJECT_VERSION_PATCH})

if (NOT CMAKE_CROSSCOMPILING)
    enable_testing()
    SET(CMAKE_CXX_FLAGS "-g -O0 -fprofile-arcs -ftest-coverage")
    SET(CMAKE_C_FLAGS "-g -O0 -fprofile-arcs -ftest-coverage")
endif()

if(NOT CONFIG)
    message(SEND_ERROR "The CONFIG varaible must be defined, You probably forgot to pass it to Cmake")
else()
    add_subdirectory(hardware)
    add_subdirectory(hardware/arch/${ARCH})
    add_subdirectory(platform)
    add_subdirectory(middleware)
    add_subdirectory(src)
    include_directories(${MAIN_APP_DIR})
    add_subdirectory(${APP_DIR}/${APP})

    set(SOURCE_FILES ${MAIN_APP_DIR}/app.c)
    
    if (NOT CMAKE_CROSSCOMPILING)
        add_executable(${PROJECT_NAME} ${SOURCE_FILES})
        target_link_libraries(${PROJECT_NAME} PRIVATE user_app)
    else()
        list(APPEND SOURCE_FILES targets/${CONFIG}/startup.s)
        add_arm_executable(${CONFIG} ${SOURCE_FILES})
        arm_link_libraries(${CONFIG} user_app)
    endif()
endif()
