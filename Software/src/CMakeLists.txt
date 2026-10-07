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
set(LINKED_LIBS hardware_pins)
if(HAS_VENDOR_DRIVERS)
    list(APPEND LINKED_LIBS vendor_drivers)
endif()

if(HAS_OS_EXTERNAL_LIB)
    list(APPEND LINKED_LIBS ${OS})
endif()
 			
if(BUILD_INTEGRATION_TESTS)
    list(APPEND LINKED_LIBS cmocka)
endif()

if(LOGS_ENABLED)
    list(APPEND LINKED_LIBS segger_rtt)
    target_compile_definitions(${FW_LIBRARY_TARGET} PUBLIC -DCONFIG_LOG_ENABLED)
endif()


target_link_libraries(${FW_LIBRARY_TARGET} PUBLIC ${LINKED_LIBS} m)

include(${WARNINGS_FLAGS_FILE})
target_compile_options(${FW_LIBRARY_TARGET} PRIVATE ${WARNINGS})
