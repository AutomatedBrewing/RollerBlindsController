#set(LD_SCRIPT ${CMAKE_CURRENT_LIST_DIR}/linker.ld)

# Linker flags
# -Wl, -Map - map file to be created
# -T - file with linker script
# -g - debug flag
# -Wl,--gc-sections - unused function removal
set(LD_FLAGS "-Wl,--start-group -lc -lm -Wl,--end-group")

set(CMAKE_EXE_LINKER_FLAGS "${LD_FLAGS}")