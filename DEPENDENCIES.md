# Project Dependencies

This document lists all dependencies required to develop, build, and test this Embedded Build System project.

## Overview

This project is an ARM embedded firmware development system with support for:
- **Targets**: STM32F0xx microcontrollers (F072, F091)
- **RTOS**: FreeRTOS
- **Testing**: CMocka with code coverage
- **Desktop build**: For testing and development

## Required Dependencies

### Build System

| Tool | Version | Purpose | Installed via |
|------|---------|---------|---|
| **CMake** | ≥ 3.20 | Build system generator | `apt: cmake` / `dnf: cmake` |
| **Make** | (any) | Build execution | `apt: build-essential` / `dnf: make` |

### Compilers & Toolchains

| Tool | Version | Purpose | Installed via |
|------|---------|---------|---|
| **ARM GCC Toolchain** | (latest) | Cross-compilation for STM32 | `apt: gcc-arm-none-eabi binutils-arm-none-eabi arm-none-eabi-newlib` / `dnf: arm-none-eabi-gcc-c++ arm-none-eabi-newlib` |

Tools included:
- `arm-none-eabi-gcc` - C compiler
- `arm-none-eabi-g++` - C++ compiler
- `arm-none-eabi-as` - Assembler
- `arm-none-eabi-ld` - Linker
- `arm-none-eabi-objdump` - Object file analyzer
- `arm-none-eabi-size` - Binary size analyzer

### Code Analysis & Formatting

| Tool | Version | Purpose | Installed via |
|------|---------|---------|---|
| **clang-format** | (latest) | Code formatting | `apt: clang-format` / `dnf: clang-tools-extra` |
| **clang-tidy** | (latest) | Static analysis & linting | `apt: clang-tools` / `dnf: clang-tools-extra` |

Configuration:
- `.clang-format` - Formatting rules
- `.clang-tidy` - Linting rules

### Testing Framework

| Tool | Version | Purpose | Installed via |
|------|---------|---------|---|
| **CMocka** | (latest) | Unit testing framework | `apt: libcmocka-dev` / `dnf: cmocka-devel` |
| **CTest** | (part of CMake) | Test runner | (included with CMake) |

### Code Coverage

| Tool | Version | Purpose | Installed via |
|------|---------|---------|---|
| **lcov** | (latest) | Coverage data collection | `apt: lcov` / `dnf: lcov` |

Included tools:
- `lcov` - Coverage data collection
- `genhtml` - HTML report generation

### Version Control

| Tool | Version | Purpose | Installed via |
|------|---------|---------|---|
| **Git** | (latest) | Version control | `apt: git` / `dnf: git` |
| **git-clang-format** | (with clang) | Format commit diffs | (included with clang-format) |

## Bundled Dependencies (Already in Repository)

These are included in the repository and don't need separate installation:

### Middleware

- **FreeRTOS** (`middleware/freertos/FreeRTOS-Kernel/`)
  - Real-time operating system for embedded devices
  - Configured via `targets/*/config_os/FreeRTOSConfig.h`

### Hardware Abstraction

- **STM32CubeF0** (`platform/stm32f0/STM32CubeF0/`)
  - ST Microelectronics HAL for STM32F0 series
  - Low-level drivers for F072 and F091

### Testing Framework

- **Unity** (`src/external/unity/`)
  - Unit testing framework (alternative to CMocka for embedded)

- **CMocka Headers** (available via system package)
  - Mocking library for unit tests

## Installation Instructions

### Automated Installation

The easiest way to install all dependencies is to run:

```bash
./setup_repo.sh
```

For host-only builds (no ARM toolchain):
```bash
./setup_repo.sh --no-arm
```

For skipping code coverage tools:
```bash
./setup_repo.sh --no-coverage
```

### Manual Installation

#### Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install -y \
    cmake \
    build-essential \
    git \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    arm-none-eabi-newlib \
    clang-format \
    clang-tools \
    libcmocka-dev \
    lcov
```

#### Fedora/RHEL

```bash
sudo dnf install -y \
    cmake \
    make \
    gcc \
    git \
    arm-none-eabi-gcc-c++ \
    arm-none-eabi-newlib \
    clang-tools-extra \
    cmocka-devel \
    lcov
```

## Verification

After installation, verify all dependencies:

```bash
# Check CMake
cmake --version

# Check ARM toolchain
arm-none-eabi-gcc --version

# Check clang tools
clang-format --version
clang-tidy --version

# Check CMocka
pkg-config --exists cmocka && echo "CMocka installed" || echo "CMocka missing"

# Check coverage tools
lcov --version
```

## Build Workflow

Once dependencies are installed, the typical workflow is:

```bash
# Clean and configure
./build.sh -c blink_F072

# Format code
./format_all.sh

# Run linting
./lint_all.sh

# Build with unit tests and coverage
./build.sh -c test -t
```

## Troubleshooting

### "CMake not found"
- Ubuntu: `sudo apt-get install cmake`
- Fedora: `sudo dnf install cmake`

### "arm-none-eabi-gcc not found"
- Ubuntu: `sudo apt-get install gcc-arm-none-eabi`
- Fedora: `sudo dnf install arm-none-eabi-gcc-c++`

### "CMocka not found by CMake"
- Ubuntu: `sudo apt-get install libcmocka-dev`
- Fedora: `sudo dnf install cmocka-devel`
- Verify: `pkg-config --exists cmocka && echo OK`

### "clang-tidy errors about compilation database"
- Ensure CMake was run: `./build.sh -c test`
- Check build directory: `ls build/test/compile_commands.json`

### "lcov/genhtml not found"
- Ubuntu: `sudo apt-get install lcov`
- Fedora: `sudo dnf install lcov`

## System Requirements

- **Minimum**: Any Linux distribution with package manager
- **Tested on**: Ubuntu 20.04+, Ubuntu 22.04+, Fedora 35+
- **RAM**: 2GB minimum (4GB recommended)
- **Disk**: 1GB for toolchain and dependencies
- **CMake**: Version 3.20 or higher

## Additional Resources

- FreeRTOS: https://www.freertos.org/
- STM32CubeF0: https://www.st.com/en/tools-software/stm32cubef0.html
- CMocka: https://cmocka.org/
- Clang Tools: https://clang.llvm.org/tools/
- LCOV: http://ltp.sourceforge.net/coverage/lcov.php
