#!/usr/bin/env bash
# Test plugin loading and directory structure
# Verifies that the plugin file exists and skills directory is properly structured
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FAILED=0

echo "Testing plugin loading..."

# Test 1: Plugin file exists
if [ -f "$REPO_ROOT/.opencode/plugins/superpowers.js" ]; then
    echo "  [PASS] Plugin file exists"
else
    echo "  [FAIL] Plugin file not found: .opencode/plugins/superpowers.js"
    FAILED=1
fi

# Test 2: Plugin file is readable
if [ -r "$REPO_ROOT/.opencode/plugins/superpowers.js" ]; then
    echo "  [PASS] Plugin file is readable"
else
    echo "  [FAIL] Plugin file is not readable"
    FAILED=1
fi

# Test 3: Plugin file has non-zero size
if [ -s "$REPO_ROOT/.opencode/plugins/superpowers.js" ]; then
    echo "  [PASS] Plugin file has content"
else
    echo "  [FAIL] Plugin file is empty"
    FAILED=1
fi

# Test 4: Skills directory exists
SKILL_COUNT=0
for dir in "$REPO_ROOT"/sw-*/; do
    if [ -d "$dir" ]; then
        SKILL_COUNT=$((SKILL_COUNT + 1))
    fi
done

if [ "$SKILL_COUNT" -gt 0 ]; then
    echo "  [PASS] Found $SKILL_COUNT skill directories"
else
    echo "  [FAIL] No skill directories found (expected sw-*)"
    FAILED=1
fi

# Test 5: Each skill directory has a SKILL.md
MISSING_SKILL_MD=0
for dir in "$REPO_ROOT"/sw-*/; do
    if [ -d "$dir" ]; then
        if [ ! -f "$dir/SKILL.md" ]; then
            echo "  [FAIL] Missing SKILL.md in $(basename "$dir")"
            MISSING_SKILL_MD=1
            FAILED=1
        fi
    fi
done

if [ "$MISSING_SKILL_MD" -eq 0 ] && [ "$SKILL_COUNT" -gt 0 ]; then
    echo "  [PASS] All skill directories have SKILL.md"
fi

# Test 6: Plugin references correct skills path
if grep -q "sw-" "$REPO_ROOT/.opencode/plugins/superpowers.js"; then
    echo "  [PASS] Plugin references sw-* skill directories"
else
    echo "  [WARN] Plugin may not reference sw-* directories"
fi

if [ "$FAILED" -eq 0 ]; then
    echo ""
    echo "All plugin loading tests passed!"
    exit 0
else
    echo ""
    echo "Some plugin loading tests failed!"
    exit 1
fi
