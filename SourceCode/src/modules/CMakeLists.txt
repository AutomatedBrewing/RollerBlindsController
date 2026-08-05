
add_subdirectory(config)
add_subdirectory(button)
#add_subdirectory(controller)
#add_subdirectory(motor)
#add_subdirectory(UI)

add_subdirectory(events)
add_subdirectory(executors)
add_subdirectory(libs)


if(BUILD_INTEGRATION_TESTS)
    add_subdirectory(integration_tests)
endif()
