# Debug flag
set(CORE_FLAGS "${CORE_FLAGS} -g3")

# Compiler flags specific for C++ files
# -std - C++ standard: c++98, gnu++98, c++11, gnu++11, c++14, gnu++14
# -fno-rtti - disable virtual class information used by dynamic_cast and typeid
# -fno-exceptions - disable exception handling
# fverbose-asm - additional comments for generated assembler code
# -MMD - create dependency files
set(CXX_FLAGS "-std=gnu++14 -fno-rtti -fno-exceptions -fverbose-asm -MMD")

# Compiler flags specific for C files
# -std - C standard: c89, c99, gnu89,gnu99, iso9899:119409
# -O0 - optimization level: -O0, -O1, -O2, -O3, -Os
# fverbose-asm - additional comments for generated assembler code
# -MMD - create dependency files
set(C_FLAGS "-std=gnu11 -ffunction-sections -fdata-sections -fverbose-asm -MMD -Og ")
#set(C_FLAGS "-std=gnu11 -ffunction-sections -fdata-sections -fverbose-asm -Wstack-usage=512 -MMD -Og --specs=nano.specs ")

set(ASM_FLAGS "--specs=nano.specs -c -x assembler-with-cpp")

# Warning flags for C++
# -Wall - standard warnings
# -Wextra - extended warnings
set(CXX_WARNINGS "")

set(CMAKE_CXX_FLAGS "${CORE_FLAGS} ${CXX_FLAGS} ${CXX_WARNINGS}")
set(CMAKE_C_FLAGS "${CORE_FLAGS} ${C_FLAGS}")
set(CMAKE_ASM_FLAGS "${ASM_FLAGS} ${CORE_FLAGS} ${CXX_WARNINGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CORE_FLAGS}")