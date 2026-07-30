# Warning flags for C++
# -Wall - standard warnings
# -Wextra - extended warnings
set(CXX_WARNINGS "")

# Warning flags for C
set(WARNINGS   -Waddress
			   -Waggregate-return
			   -Wformat-nonliteral
			   -Wformat-security
			   -Wformat
			   -Winit-self
			   -Wconversion
			   -Wmissing-include-dirs
			   -Wmultichar
			   -Wparentheses
			   -Wtype-limits
			   -Wunused-parameter
			   -Wunreachable-code
			   -Wwrite-strings
			   -Wpointer-arith
			   -Wall
			   -Wextra
			   -Wpedantic
			   -Wcast-qual
			   -Wstack-usage=512
     		   -Werror
			   )