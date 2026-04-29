#!/usr/bin/env bash
# Test skill file structure
# Verifies YAML frontmatter, naming conventions, and content requirements
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FAILED=0
SKILL_COUNT=0

echo "Testing skill structure..."

for skill_file in "$REPO_ROOT"/sw-*/SKILL.md; do
    if [ ! -f "$skill_file" ]; then
        continue
    fi

    SKILL_COUNT=$((SKILL_COUNT + 1))
    skill_dir=$(dirname "$skill_file")
    skill_name=$(basename "$skill_dir")

    # Test 1: YAML frontmatter exists (starts with ---)
    if head -1 "$skill_file" | grep -q '^---'; then
        : # pass silently
    else
        echo "  [FAIL] $skill_name: Missing YAML frontmarker (should start with ---)"
        FAILED=1
        continue
    fi

    # Test 2: Name field exists
    if grep -q '^name:' "$skill_file"; then
        : # pass
    else
        echo "  [FAIL] $skill_name: Missing 'name' field in frontmatter"
        FAILED=1
    fi

    # Test 3: Description field exists
    if grep -q '^description:' "$skill_file"; then
        : # pass
    else
        echo "  [FAIL] $skill_name: Missing 'description' field in frontmatter"
        FAILED=1
    fi

    # Test 4: Description starts with "Use when"
    desc=$(grep '^description:' "$skill_file" | head -1)
    if echo "$desc" | grep -q 'Use when'; then
        : # pass
    else
        echo "  [WARN] $skill_name: Description should start with 'Use when'"
    fi

    # Test 5: File size check (< 600 lines for main SKILL.md)
    line_count=$(wc -l < "$skill_file")
    if [ "$line_count" -lt 600 ]; then
        : # pass
    else
        echo "  [WARN] $skill_name: SKILL.md has $line_count lines (recommended < 600)"
    fi

    # Test 6: Has Red Flags section
    if grep -q '## 红旗' "$skill_file"; then
        : # pass
    else
        echo "  [FAIL] $skill_name: Missing '## 红旗' section"
        FAILED=1
    fi

    # Test 7: Has excuse table (常见借口 or 合理化借口)
    if grep -q '常见借口\|合理化借口' "$skill_file"; then
        : # pass
    else
        echo "  [FAIL] $skill_name: Missing excuse table (常见借口表 or 合理化借口表)"
        FAILED=1
    fi

    # Test 8: Has table-format Red Flags (| 想法 | 现实 |)
    if grep -q '| 想法 | 现实 |' "$skill_file"; then
        : # pass
    else
        echo "  [WARN] $skill_name: Red Flags not in table format (| 想法 | 现实 |)"
    fi

done

echo "  [INFO] Checked $SKILL_COUNT skill files"

if [ "$FAILED" -eq 0 ]; then
    echo ""
    echo "All skill structure tests passed!"
    exit 0
else
    echo ""
    echo "Some skill structure tests failed!"
    exit 1
fi
