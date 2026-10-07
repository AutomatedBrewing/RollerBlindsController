set(HAS_VENDOR_DRIVERS TRUE CACHE STRING "Target has vendor specific drivers." FORCE)

#Path to the STM Drivers
set(DRIVERS_DIR STM32CubeC0/Drivers/STM32C0xx_HAL_Driver)

#Path to the CMSIS
set(CMSIS_DIR STM32CubeC0/Drivers/CMSIS)

add_library(vendor_drivers STATIC
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_dma.c    
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_exti.c
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_gpio.c
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_pwr.c
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_rcc.c
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_tim.c
    ${DRIVERS_DIR}/Src/stm32c0xx_ll_utils.c
)

if (NOT DRIVERS_CONFIG_HEADER_PATH)
    message(SEND_ERROR "Please specify the STMC0 HAL driver configuration header by setting DRIVERS_CONFIG_HEADER_PATH.")
endif()

target_include_directories(vendor_drivers PUBLIC
    .
    ${DRIVERS_DIR}/Inc 
    ${CMSIS_DIR}/Device/ST/STM32C0xx/Include
    ${CMSIS_DIR}/Include
    ${DRIVERS_CONFIG_HEADER_PATH}
)

if (NOT DRIVERS_CONFIG_DEFINES)
    message(SEND_ERROR "Please specify the STMC0 drivers configuration defines by setting DRIVERS_CONFIG_DEFINES.")
endif()

target_compile_definitions(vendor_drivers PUBLIC
    ${DRIVERS_CONFIG_DEFINES} 
)
