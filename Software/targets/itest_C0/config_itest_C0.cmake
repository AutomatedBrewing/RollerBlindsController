set(BUILD_INTEGRATION_TESTS true CACHE STRING "Target has vendor specific drivers." FORCE)
set(HARDWARE rbcBoard CACHE STRING "Used hardware board" FORCE)
set(APP integration_tests CACHE STRING "Application name" FORCE)
set(OS baremetal CACHE STRING "Used OS" FORCE)
set(LOGS_ENABLED true CACHE STRING "Enalbes the logs" FORCE)

# Compilation and linking flags.
include(targets/${CONFIG}/flags/flags.cmake)
include(targets/${CONFIG}/linker/linker.cmake)
include(cmake/toolchain-arm-gcc.cmake)

# Include configuration files for OS, drivers and integration tests.
include(targets/${CONFIG}/config_drivers/config_drivers.cmake)
include(targets/${CONFIG}/config_os/config_os.cmake)
include(targets/${CONFIG}/config_it/config_it.cmake)
include(targets/${CONFIG}/config_hsm/config_hsm.cmake)
