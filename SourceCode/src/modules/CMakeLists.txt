#add_subdirectory(blink)
add_subdirectory(button)
add_subdirectory(display)
add_subdirectory(events)
add_subdirectory(executors)
add_subdirectory(scheduler)
add_subdirectory(libs)


if(BUILD_INTEGRATION_TESTS)
    add_subdirectory(integration_tests)
endif()
