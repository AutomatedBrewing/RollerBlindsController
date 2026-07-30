#!/bin/bash

echo "Running clang-tidy analysis..."
echo ""

# Temporary file for collecting errors
TEMP_FILE=$(mktemp)

# Run clang-tidy and capture only real warnings/errors
find src -regex '.*\.[c]$' -not -path "*/external/*" | sort | while read file; do
    clang-tidy "$file" 2>&1
done | grep -E "warning:|error:|^[^ ].*\[[a-zA-Z0-9-]+\]" | grep -v "error: '" | grep -v "Could not auto-detect" > "$TEMP_FILE"

# Display results if there are any
if [ -s "$TEMP_FILE" ]; then
    cat "$TEMP_FILE"
    rm "$TEMP_FILE"
    echo ""
    echo "Linting complete. Found issues above."
    exit 0
else
    echo "✓ No issues found!"
    rm "$TEMP_FILE"
    exit 0
fi
