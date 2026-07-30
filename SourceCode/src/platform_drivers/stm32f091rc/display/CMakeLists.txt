target_sources(${FW_LIBRARY_TARGET} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/hd_44780.c
    ${CMAKE_CURRENT_LIST_DIR}/buf_lcd.c
)

target_include_directories(${FW_LIBRARY_TARGET} PUBLIC . )