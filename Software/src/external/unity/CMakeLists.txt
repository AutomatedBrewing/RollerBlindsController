add_library(unity
	Unity/src/unity.c
	Unity/extras/fixture/src/unity_fixture.c
	Unity/extras/memory/src/unity_memory.c)
	
target_include_directories(unity PUBLIC
	${INTEGRATION_TEST_CONFIG_HEADER_PATH}
	Unity/src
	Unity/extras/fixture/src
	Unity/extras/memory/src)

#Added define to enable support for external unity_config.h, which defines custom putchar function.
add_definitions(-DUNITY_INCLUDE_CONFIG_H)

#Linking fw library to enable using logs.
target_link_libraries(unity PRIVATE ${FW_LIBRARY_TARGET})
