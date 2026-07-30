#!/bin/bash

###############################################################################
# Setup script for Embedded Build System
# 
# This script installs all required dependencies for development:
# - CMake 3.20+
# - ARM GCC Toolchain (arm-none-eabi-gcc)
# - Build tools (make, git)
# - Code analysis tools (clang-format, clang-tidy, cppcheck)
# - Testing tools (CMocka, lcov)
#
# Usage: ./setup_repo.sh [options]
# Options:
#   -h, --help          Show this help message
#   --no-arm            Skip ARM toolchain installation (for host builds only)
#   --no-coverage       Skip coverage tools (lcov, genhtml)
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SKIP_ARM=false
SKIP_COVERAGE=false
OS_TYPE=$(uname -s)
DISTRO=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            grep '^#' "$0" | grep -v '#!/bin/bash' | sed 's/^# //g'
            exit 0
            ;;
        --no-arm)
            SKIP_ARM=true
            shift
            ;;
        --no-coverage)
            SKIP_COVERAGE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Detect Linux distribution
if [ "$OS_TYPE" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo -e "${RED}Cannot detect Linux distribution${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}========== Embedded Build System Setup ==========${NC}"
echo "OS Type: $OS_TYPE"
echo "Distro: $DISTRO"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if command_exists "$1"; then
        echo -e "${GREEN}✓${NC} $1 is installed ($(eval $1 --version | head -n1))"
        return 0
    else
        echo -e "${YELLOW}✗${NC} $1 is NOT installed"
        return 1
    fi
}

# Function to install package using apt
install_apt() {
    echo -e "${YELLOW}Installing $1...${NC}"
    sudo apt-get update > /dev/null
    sudo apt-get install -y "$1" > /dev/null
}

# Function to install package using dnf
install_dnf() {
    echo -e "${YELLOW}Installing $1...${NC}"
    sudo dnf install -y "$1" > /dev/null
}

# Detect package manager and install function
if command_exists apt-get; then
    INSTALL_CMD=install_apt
elif command_exists dnf; then
    INSTALL_CMD=install_dnf
else
    echo -e "${RED}Neither apt-get nor dnf found. Unsupported distribution.${NC}"
    echo "Please install dependencies manually. Required packages:"
    echo "  - cmake (3.20+)"
    echo "  - arm-none-eabi-* (gcc, g++, binutils, newlib)"
    echo "  - build-essential (or equivalent)"
    echo "  - git"
    echo "  - clang-format"
    echo "  - clang-tools (for clang-tidy)"
    echo "  - cmocka"
    echo "  - lcov"
    exit 1
fi

echo -e "${GREEN}=== Checking Required Tools ===${NC}"
echo ""

# Check and install CMake
if ! command_exists cmake || [ $(cmake --version | head -n1 | awk '{print $3}') \< "3.20" ]; then
    $INSTALL_CMD cmake
else
    print_status cmake
fi

# Check and install Make
if ! command_exists make; then
    if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
        $INSTALL_CMD build-essential
    elif [ "$DISTRO" = "fedora" ]; then
        $INSTALL_CMD make gcc
    fi
else
    print_status make
fi

# Check and install Git
if ! command_exists git; then
    $INSTALL_CMD git
else
    print_status git
fi

# Check and install ARM Toolchain
if [ "$SKIP_ARM" = false ]; then
    echo -e "${GREEN}=== ARM Embedded Toolchain ===${NC}"
    if ! command_exists arm-none-eabi-gcc; then
        if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
            $INSTALL_CMD gcc-arm-none-eabi
            $INSTALL_CMD binutils-arm-none-eabi
            $INSTALL_CMD arm-none-eabi-newlib
        elif [ "$DISTRO" = "fedora" ]; then
            $INSTALL_CMD arm-none-eabi-gcc-c++
            $INSTALL_CMD arm-none-eabi-newlib
        fi
    else
        print_status arm-none-eabi-gcc
    fi
    echo ""
fi

# Check and install Clang tools
echo -e "${GREEN}=== Code Analysis Tools ===${NC}"
if ! command_exists clang-format; then
    if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
        $INSTALL_CMD clang-format
    elif [ "$DISTRO" = "fedora" ]; then
        $INSTALL_CMD clang-tools-extra
    fi
else
    print_status clang-format
fi

if ! command_exists clang-tidy; then
    if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
        $INSTALL_CMD clang-tools
    elif [ "$DISTRO" = "fedora" ]; then
        $INSTALL_CMD clang-tools-extra
    fi
else
    print_status clang-tidy
fi

echo ""

# Check and install CMocka
echo -e "${GREEN}=== Testing Framework ===${NC}"
if ! command_exists pkg-config || ! pkg-config --exists cmocka 2>/dev/null; then
    if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then
        $INSTALL_CMD libcmocka-dev
    elif [ "$DISTRO" = "fedora" ]; then
        $INSTALL_CMD cmocka-devel
    fi
    echo -e "${GREEN}✓${NC} CMocka installed"
else
    echo -e "${GREEN}✓${NC} CMocka is installed"
fi

echo ""

# Check and install coverage tools
if [ "$SKIP_COVERAGE" = false ]; then
    echo -e "${GREEN}=== Code Coverage Tools ===${NC}"
    if ! command_exists lcov; then
        $INSTALL_CMD lcov
    else
        print_status lcov
    fi
    
    if ! command_exists genhtml; then
        # genhtml comes with lcov
        echo -e "${GREEN}✓${NC} genhtml (part of lcov)"
    else
        print_status genhtml
    fi
    echo ""
fi

# Verify critical installations
echo -e "${GREEN}=== Verification ===${NC}"
critical_tools=("cmake" "make" "git" "clang-format" "clang-tidy")

if [ "$SKIP_ARM" = false ]; then
    critical_tools+=("arm-none-eabi-gcc")
fi

all_installed=true
for tool in "${critical_tools[@]}"; do
    if ! command_exists "$tool"; then
        echo -e "${RED}✗${NC} $tool is still missing!"
        all_installed=false
    else
        echo -e "${GREEN}✓${NC} $tool"
    fi
done

echo ""

if [ "$all_installed" = true ]; then
    echo -e "${GREEN}========== Setup Complete! ==========${NC}"
    echo ""
    echo "You can now build the project:"
    echo "  ./build.sh -c blink_F072"
    echo ""
    echo "And format/lint the code:"
    echo "  ./format_all.sh"
    echo "  ./lint_all.sh"
    exit 0
else
    echo -e "${RED}========== Setup Failed! ==========${NC}"
    echo "Some dependencies are still missing. Please install them manually."
    exit 1
fi
