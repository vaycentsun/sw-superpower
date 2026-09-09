#!/usr/bin/env bash
# Verify the sw-agiledevelopment ZCode plugin structure.
# Usage: bash scripts/verify-zcode.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0

echo "Verifying ZCode plugin..."

manifest="$REPO_ROOT/.zcode-plugin/plugin.json"
if [ ! -f "$manifest" ]; then
    echo "  [FAIL] Missing ZCode plugin manifest: $manifest"
    FAILED=1
else
    echo "  [PASS] ZCode plugin manifest exists"
fi

# The manifest version must match the VERSION file (the single source of truth).
if [ -f "$manifest" ] && [ -f "$REPO_ROOT/VERSION" ] && command -v python3 >/dev/null 2>&1; then
    manifest_version=$(python3 -c "import json;print(json.load(open('$manifest'))['version'])" 2>/dev/null || echo "")
    repo_version=$(tr -d '[:space:]' < "$REPO_ROOT/VERSION")
    if [ -n "$manifest_version" ] && [ "$manifest_version" = "$repo_version" ]; then
        echo "  [PASS] plugin.json version matches VERSION ($repo_version)"
    else
        echo "  [FAIL] plugin.json version '$manifest_version' does not match VERSION '$repo_version'"
        FAILED=1
    fi
fi

# The manifest must declare the hooks file — without it the SessionStart hook
# is not loaded when the plugin is installed from a marketplace.
if [ -f "$manifest" ] && command -v python3 >/dev/null 2>&1; then
    if python3 -c "import json,sys; sys.exit(0 if json.load(open('$manifest')).get('hooks') else 1)" 2>/dev/null; then
        echo "  [PASS] plugin.json declares a hooks entry"
    else
        echo "  [FAIL] plugin.json does not declare hooks (add \"hooks\": \".zcode-plugin/hooks/hooks.json\")"
        FAILED=1
    fi
fi

# Root marketplace.json lets others add this repo as a ZCode marketplace.
marketplace_json="$REPO_ROOT/marketplace.json"
if [ ! -f "$marketplace_json" ]; then
    echo "  [FAIL] Missing marketplace.json at repository root"
    FAILED=1
elif command -v python3 >/dev/null 2>&1 && ! python3 -c "import json;json.load(open('$marketplace_json'))" 2>/dev/null; then
    echo "  [FAIL] marketplace.json is not valid JSON"
    FAILED=1
else
    echo "  [PASS] marketplace.json exists and is valid JSON"
fi

hooks_json="$REPO_ROOT/.zcode-plugin/hooks/hooks.json"
if [ ! -f "$hooks_json" ]; then
    echo "  [FAIL] Missing hooks.json: $hooks_json"
    FAILED=1
else
    echo "  [PASS] hooks.json exists"
fi

session_start="$REPO_ROOT/.zcode-plugin/hooks/session-start"
if [ ! -f "$session_start" ]; then
    echo "  [FAIL] Missing session-start hook: $session_start"
    FAILED=1
else
    echo "  [PASS] session-start hook exists"
fi

if [ -x "$session_start" ]; then
    echo "  [PASS] session-start hook is executable"
else
    echo "  [FAIL] session-start hook is not executable"
    FAILED=1
fi

if [ -d "$REPO_ROOT/skills" ]; then
    echo "  [PASS] skills/ directory exists"
else
    echo "  [FAIL] skills/ directory missing"
    FAILED=1
fi

for skill_dir in "$REPO_ROOT"/sw-*/; do
    skill_name=$(basename "$skill_dir")
    symlink="$REPO_ROOT/skills/$skill_name"
    if [ ! -L "$symlink" ]; then
        echo "  [FAIL] skills/$skill_name is not a symlink"
        FAILED=1
    fi
done

if command -v bash >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
    if "$session_start" | python3 -m json.tool >/dev/null 2>&1; then
        echo "  [PASS] session-start hook emits valid JSON"
    else
        echo "  [FAIL] session-start hook does not emit valid JSON"
        FAILED=1
    fi
else
    echo "  [SKIP] bash/python3 not available, skipping hook JSON validation"
fi

if [ "$FAILED" -eq 0 ]; then
    echo ""
    echo "ZCode plugin verification passed!"
    exit 0
else
    echo ""
    echo "ZCode plugin verification failed!"
    exit 1
fi
