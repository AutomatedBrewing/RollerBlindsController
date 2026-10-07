if(LOGS_ENABLED)
    add_subdirectory(segger_rtt)
endif()

if(BUILD_INTEGRATION_TESTS)
    add_subdirectory(unity)
endif()
