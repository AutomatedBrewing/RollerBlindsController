
target_sources(${FW_LIBRARY_TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/gpio_pins.c
)

target_include_directories(${FW_LIBRARY_TARGET} PUBLIC .)