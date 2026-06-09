cmake_minimum_required(VERSION 3.20)

project(ort_vuln_test_project
    VERSION 1.0.0
    LANGUAGES C ASM
    DESCRIPTION "Test project for ORT vulnerability analysis - STM32U5 embedded target"
)

# ---------------------------------------------------------------------------
# Toolchain / target
# ---------------------------------------------------------------------------
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Cross-compile pour STM32U5 (arm-none-eabi-gcc attendu dans le PATH)
set(MCU_FLAGS "-mcpu=cortex-m33 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${MCU_FLAGS} -Wall -Wextra -fdata-sections -ffunction-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${MCU_FLAGS} -Wl,--gc-sections -specs=nano.specs")

# ---------------------------------------------------------------------------
# Sources
# ---------------------------------------------------------------------------
add_executable(${PROJECT_NAME}
    src/main.c
)

# ---------------------------------------------------------------------------
# Dépendances (include paths – les sources réelles sont dans les sous-modules)
# ---------------------------------------------------------------------------

# 1. CMSIS-device-u5  v1.4.2
#    https://github.com/STMicroelectronics/cmsis-device-u5
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/cmsis-device-u5/Include
)

# 2. CMSIS-5  5.9.0
#    https://github.com/ARM-software/CMSIS_5
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/CMSIS_5/CMSIS/Core/Include
    deps/CMSIS_5/CMSIS/DSP/Include
)

# 3. stm32u5xx-hal-driver  v1.6.2
#    https://github.com/STMicroelectronics/stm32u5xx-hal-driver
file(GLOB HAL_SOURCES deps/stm32u5xx-hal-driver/Src/*.c)
target_sources(${PROJECT_NAME} PRIVATE ${HAL_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/stm32u5xx-hal-driver/Inc
)

# 4. CMSIS-FreeRTOS  v11.2.0
#    https://github.com/ARM-software/CMSIS-FreeRTOS
file(GLOB FREERTOS_SOURCES
    deps/CMSIS-FreeRTOS/Source/*.c
    deps/CMSIS-FreeRTOS/Source/portable/GCC/ARM_CM33_NTZ/non_secure/*.c
    deps/CMSIS-FreeRTOS/Source/portable/MemMang/heap_4.c
)
target_sources(${PROJECT_NAME} PRIVATE ${FREERTOS_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/CMSIS-FreeRTOS/Source/include
    deps/CMSIS-FreeRTOS/Source/portable/GCC/ARM_CM33_NTZ/non_secure
    include  # contient FreeRTOSConfig.h
)

# 5. BTstack  1.6.1
#    https://github.com/bluekitchen/btstack
file(GLOB BTSTACK_SOURCES deps/btstack/src/*.c)
target_sources(${PROJECT_NAME} PRIVATE ${BTSTACK_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/btstack/src
    deps/btstack/include
)

# 6. TinyUSB  commit 9c8c5c1
#    https://github.com/hathach/tinyusb
file(GLOB_RECURSE TINYUSB_SOURCES deps/tinyusb/src/*.c)
target_sources(${PROJECT_NAME} PRIVATE ${TINYUSB_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/tinyusb/src
    deps/tinyusb/hw
)

# 7. NNoM  commit 91e4b00
#    https://github.com/majianjia/nnom
file(GLOB NNOM_SOURCES deps/nnom/src/*.c)
target_sources(${PROJECT_NAME} PRIVATE ${NNOM_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE
    deps/nnom/inc
)

# ---------------------------------------------------------------------------
# Compile definitions
# ---------------------------------------------------------------------------
target_compile_definitions(${PROJECT_NAME} PRIVATE
    STM32U575xx
    USE_HAL_DRIVER
    HSE_VALUE=16000000U
)
