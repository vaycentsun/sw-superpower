#!/usr/bin/env bash
# Test tool mapping completeness
# Verifies that reference tool mapping files exist and are complete
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FAILED=0

echo "Testing tool mapping..."

REFERENCES_DIR="$REPO_ROOT/sw-using-superpowers/references"

# Test 1: References directory exists
if [ -d "$REFERENCES_DIR" ]; then
    echo "  [PASS] References directory exists"
else
    echo "  [FAIL] References directory not found: sw-using-superpowers/references"
    FAILED=1
fi

# Test 2: Required mapping files exist
REQUIRED_FILES=(
    "copilot-tools.md"
    "codex-tools.md"
    "gemini-tools.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    filepath="$REFERENCES_DIR/$file"
    if [ -f "$filepath" ]; then
        echo "  [PASS] $file exists"
    else
        echo "  [FAIL] $file not found"
        FAILED=1
    fi
done

# Test 3: OpenCode tool mapping in using-superpowers SKILL.md
USING_SUPERPOWERS="$REPO_ROOT/sw-using-superpowers/SKILL.md"
if [ -f "$USING_SUPERPOWERS" ]; then
    # Check for table format
    if grep -q '| Claude Code 工具 | OpenCode 等效项 |' "$USING_SUPERPOWERS"; then
        echo "  [PASS] OpenCode tool mapping uses table format"
    else
        echo "  [FAIL] OpenCode tool mapping not in table format"
        FAILED=1
    fi

    # Check for key tools
    REQUIRED_TOOLS=("Read" "Write" "Edit" "Bash" "Grep" "Glob")
    MISSING_TOOLS=0
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! grep -q "\`$tool\`" "$USING_SUPERPOWERS"; then
            echo "  [FAIL] Missing tool mapping for: $tool"
            MISSING_TOOLS=1
            FAILED=1
        fi
    done
    if [ "$MISSING_TOOLS" -eq 0 ]; then
        echo "  [PASS] All required tools mapped"
    fi
else
    echo "  [FAIL] sw-using-superpowers/SKILL.md not found"
    FAILED=1
fi

# Test 4: References directory has no broken links
for file in "$REFERENCES_DIR"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Check if file has content
        if [ -s "$file" ]; then
            : # pass
        else
            echo "  [FAIL] $filename is empty"
            FAILED=1
        fi
    fi
done

if [ "$FAILED" -eq 0 ]; then
    echo ""
    echo "All tool mapping tests passed!"
    exit 0
else
    echo ""
    echo "Some tool mapping tests failed!"
    exit 1
fi
