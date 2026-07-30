#Configuration of the paths for the device. 
set(HARDWARE emulated CACHE STRING "Used OS" FORCE)
set(APP blink CACHE STRING "Application name" FORCE)
set(OS posix CACHE STRING "OS used" FORCE)

# Include configuration files for hsm.
include(targets/${CONFIG}/config_hsm/config_hsm.cmake)