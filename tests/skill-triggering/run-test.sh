#!/usr/bin/env bash
# Skill triggering test framework
# Defines test scenarios to verify skill discovery and triggering
# Usage: Review prompts manually or run with OpenCode integration
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

echo "========================================"
echo " Skill Triggering Test Scenarios"
echo "========================================"
echo ""
echo "This framework defines test prompts to verify skill triggering."
echo ""

# List all available test scenarios
echo "Available test scenarios:"
for prompt_file in "$PROMPTS_DIR"/*.txt; do
    if [ -f "$prompt_file" ]; then
        basename "$prompt_file" .txt
    fi
done

echo ""
echo "Usage:"
echo "  1. Review prompt files in prompts/"
echo "  2. Use prompt with OpenCode Agent"
echo "  3. Verify correct skill is triggered"
echo ""
echo "Expected triggers:"
echo "  brainstorming.txt                -> sw-brainstorming"
echo "  test-driven-development.txt      -> sw-test-driven-dev"
echo "  systematic-debugging.txt         -> sw-systematic-debugging"
echo "  writing-specs.txt                -> sw-writing-specs"
echo "  subagent-development.txt         -> sw-subagent-development"
echo "  requesting-code-review.txt       -> sw-requesting-code-review"
echo "  receiving-code-review.txt        -> sw-receiving-code-review"
echo "  verification-before-completion.txt -> sw-verification-before-completion"
echo "  finishing-branch.txt             -> sw-finishing-branch"
echo "  executing-plans.txt              -> sw-executing-plans"
echo "  dispatching-parallel-agents.txt  -> sw-dispatching-parallel-agents"
echo "  using-git-worktrees.txt          -> sw-using-git-worktrees"
echo ""
