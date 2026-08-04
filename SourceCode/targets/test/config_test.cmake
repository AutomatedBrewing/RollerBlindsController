#Configuration of the paths for the device. 
set(HARDWARE emulated CACHE STRING "Used HW" FORCE)
set(APP shutterController CACHE STRING "Used Application" FORCE)
set(OS posix CACHE STRING "Used OS" FORCE)

# Include configuration files for hsm.
include(targets/${CONFIG}/config_hsm/config_hsm.cmake)