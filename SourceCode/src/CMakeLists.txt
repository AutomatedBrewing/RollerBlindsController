cmake_minimum_required(VERSION 3.20)
project(common-lib C)

set(FW_LIBRARY_TARGET fw-lib)
add_library(${FW_LIBRARY_TARGET})


# Add sources
add_subdirectory(modules)
add_subdirectory(os)
add_subdirectory(platform_drivers)
add_subdirectory(external)

# Link necessary libraries

if(LOGS_ENABLED)
    target_compile_definitions(${FW_LIBRARY_TARGET} PUBLIC -DCONFIG_LOG_ENABLED)
endif()
 
target_link_libraries(${FW_LIBRARY_TARGET} PUBLIC hardware_pins)
if(HAS_VENDOR_DRIVERS)
    target_link_libraries(${FW_LIBRARY_TARGET} PRIVATE vendor_drivers)
endif()
if(HAS_OS_EXTERNAL_LIB)
    target_link_libraries(${FW_LIBRARY_TARGET} PRIVATE ${OS})
endif()
if(BUILD_INTEGRATION_TESTS)
    target_link_libraries(${FW_LIBRARY_TARGET} PRIVATE unity)
endif()
if(LOGS_ENABLED)
    target_link_libraries(${FW_LIBRARY_TARGET} PRIVATE segger_rtt)
endif()

include(${WARNINGS_FLAGS_FILE})
target_compile_options(${FW_LIBRARY_TARGET} PRIVATE ${WARNINGS})
