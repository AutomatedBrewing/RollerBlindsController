#!/bin/bash

echo "Running clang-tidy analysis..."
echo ""

# Directories to analyze
DIRECTORIES=(
    "src/modules/button"
)

# CMake build directory
BUILD_DIR="build/test"

# Check compilation database
if [ ! -f "$BUILD_DIR/compile_commands.json" ]; then
    echo "ERROR: Compilation database not found:"
    echo "  $BUILD_DIR/compile_commands.json"
    echo ""
    echo "Please build/configure the project first."
    exit 1
fi

ERRORS=0

while IFS= read -r -d '' file; do
    echo "Checking: $file"

    if ! clang-tidy -p "$BUILD_DIR" "$file"; then
        ERRORS=1
    fi

done < <(
    find "${DIRECTORIES[@]}" \
        -type f \
        -name "*.c" \
        -not -path "*/external/*" \
        -print0
)

echo ""

if [ "$ERRORS" -eq 0 ]; then
    echo "✓ No issues found!"
else
    echo "Linting complete. Found issues above."
fi

exit "$ERRORS"