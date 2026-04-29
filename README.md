<div align="right">
  <strong>🇺🇸 English</strong> | <a href="./README.zh.md">🇨🇳 中文</a> | <a href="./README.ja.md">🇯🇵 日本語</a> | <a href="./README.es.md">🇪🇸 Español</a> | <a href="./README.fr.md">🇫🇷 Français</a>
</div>

# sw-superpower 🦸

> A Superpowers-style skill set for AI coding agents — structured software engineering workflows from brainstorming to code review.

A complete set of software engineering workflow skills that help AI coding agents complete every step from requirements analysis to code review in a systematic, reproducible way.

---

## 📦 Overview

`sw-superpower` is a Superpowers-style skill set designed for [OpenCode](https://opencode.ai) and other AI coding agents. It encapsulates mature software engineering practices (TDD, code review, systematic debugging) into structured, reusable agent skills.

This is a Chinese-localized adaptation of the [obra/superpowers](https://github.com/obra/superpowers) framework, preserving its complete methodology while adapting content for Chinese-speaking developers.

### Core Principles

- **Process-Driven**: Each skill defines clear trigger conditions and execution workflows
- **Rules First**: Non-negotiable rules are placed at the forefront
- **Stress-Tested**: Skills are created and validated through TDD
- **Incremental Delivery**: Complete workflow from brainstorming to code delivery

---

## 🗂️ Project Structure

```
sw-superpower/
├── sw-brainstorming/              # Brainstorming & requirements analysis
├── sw-writing-specs/              # Writing implementation plans
├── sw-subagent-development/       # Subagent-driven development
├── sw-test-driven-dev/            # Test-driven development
├── sw-requesting-code-review/     # Requesting code review
├── sw-receiving-code-review/      # Receiving code review feedback
├── sw-systematic-debugging/       # Systematic debugging
├── sw-verification-before-completion/  # Pre-completion verification
├── sw-finishing-branch/           # Finishing development branch
├── sw-using-git-worktrees/        # Git worktree management
├── sw-dispatching-parallel-agents/# Parallel agent dispatch
├── sw-executing-plans/            # Executing plans (same session)
├── sw-using-superpowers/          # Skill system bootstrap (core entry)
└── sw-writing-skills/             # Writing new skills (meta skill)
```

---

## 🚀 Core Workflow

The complete software development workflow executes in the following order:

```
Start New Feature
    ↓
sw-brainstorming (Brainstorming & Design)
    ↓ Output: docs/superpowers/specs/YYYY-MM-DD--feature-design.md
sw-writing-specs (Writing Implementation Plan)
    ↓ Output: docs/superpowers/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (Subagent-Driven Development)
    ├── sw-test-driven-dev (TDD for each task)
    ├── sw-requesting-code-review (Review after tasks)
    └── sw-receiving-code-review (Handle review feedback)
    ↓
sw-verification-before-completion (Pre-Completion Verification)
    ↓
sw-finishing-branch (Finishing Branch)
```

**Alternative paths:**
- `sw-executing-plans` — Execute plans in the same session without subagents
- `sw-dispatching-parallel-agents` — Dispatch multiple agents in parallel for independent tasks

---

## 📋 Skills Overview

| Skill | Purpose | Trigger Condition |
|-------|---------|-------------------|
| **sw-brainstorming** | Transform ideas into complete design and specs | Starting new feature development |
| **sw-writing-specs** | Create detailed implementation plans | Design approved, need execution plan |
| **sw-subagent-development** | Execute plans using subagents | Have implementation plan, tasks are independent |
| **sw-executing-plans** | Batch execute plans in same session | Have plan, not using subagents |
| **sw-test-driven-dev** | Enforce RED-GREEN-REFACTOR cycle | Implementing any feature or fixing bugs |
| **sw-requesting-code-review** | Dispatch code reviewer subagent | After task, before merge |
| **sw-receiving-code-review** | Handle external review feedback | Receiving code review comments |
| **sw-systematic-debugging** | Systematic bug investigation | Bugs found or tests failing |
| **sw-dispatching-parallel-agents** | Concurrent subagent workflows | 2+ independent tasks |
| **sw-verification-before-completion** | Pre-completion verification | Ready to mark task as complete |
| **sw-finishing-branch** | Verify, decide, and clean up branch | All tasks completed |
| **sw-using-git-worktrees** | Create isolated workspaces | Starting new feature, need parallel development |
| **sw-writing-skills** | Create and validate new skills | Need to create a new skill |
| **sw-using-superpowers** | Skill system bootstrap | Every conversation start |

---

## 🎯 Quick Start

### Installation

**OpenCode Plugin (Recommended):**

Add to your `~/.config/opencode/opencode.json`:

```json
{
  "plugin": [
    "sw-superpower@git+http://192.168.1.100:53000/vaycent/sw-superpower.git#main"
  ],
  "permission": {
    "skill": {
      "*": "allow"
    }
  }
}
```

Restart OpenCode. The plugin will be auto-installed via Bun.

**Git Submodule:**

```bash
cd <your-project>/skills/
git submodule add https://github.com/vaycentsun/sw-superpower.git
git submodule update --init --recursive
```

Restart OpenCode or reload skills.

### Usage Example

When you start a new feature, the agent automatically recognizes and applies the appropriate skill:

```
User: I want to develop a user authentication feature

Agent: [Automatically applies sw-brainstorming Skill]
      1. Explore project context...
      2. Ask clarifying questions...
      3. Propose 2-3 approaches...
      4. Present design in sections...
      5. Write spec document → docs/superpowers/specs/2026-04-18--user-auth-design.md
      6. Invoke sw-writing-specs to create implementation plan...
```

---

## 🏗️ Skill Structure

Each skill is a self-contained directory following a unified structure:

```
sw-<skill-name>/
├── SKILL.md                    # Main skill file (required)
├── subagent-prompts/           # Subagent prompts (optional)
│   └── <name>-prompt.md
├── templates/                  # Template files (optional)
│   └── <template>.md
└── scripts/                    # Scripts (optional)
    └── <script>.sh
```

### SKILL.md Format

```markdown
---
name: skill-name
description: "Use when [specific trigger condition]"
---

# Skill Name

## Iron Rules
Key rules that must not be violated

## Process
Flowchart and detailed steps

## Red Flags - Stop Immediately
List of violation signs

## Common Excuses Table
| Excuse | Reality |
|--------|---------|

## Integration
Prerequisite and subsequent skills

## Output Example
Expected output format
```

---

## 🔑 Key Principles

### YAGNI Principle

> You Aren't Gonna Need It

- Don't add features not required by the spec
- Don't over-engineer
- Don't assume future requirements

### Subagent Development Principles

- Use a fresh subagent for each task
- Subagents should not inherit session context
- Provide complete task text and context

### Review Principles

- **Objective**: Based on standards, not personal preferences
- **Constructive**: Provide specific improvement suggestions
- **Prioritized**: Focus on critical issues

---

## 🧪 Testing Strategy

This project develops skills using TDD:

1. **Test First, Skill Second** - No exceptions
2. **Create Stress Scenarios** - 3+ pressure combination tests
3. **Document Baseline Failures** - Observe failure behavior without skill
4. **Write Skill to Address Failures** - Target observed failures
5. **Verify Compliance** - Re-test with skill
6. **Close Loopholes** - Find new excuses, add countermeasures

---

## 🤝 Contributing

### Creating a New Skill

1. Use `sw-writing-skills` skill to guide the creation process
2. Follow TDD approach: test first, then write
3. Create 3+ stress scenario tests
4. Document baseline failure behavior
5. Write skill to address specific failures
6. Verify compliance, close loopholes

### Commit Convention

```bash
# Create new skill
feat: add sw-<skill-name> for <purpose>

# Update existing skill
fix: resolve <issue> in sw-<skill-name>

docs: update <section> in sw-<skill-name>
```

---

## 📄 License

[MIT](./LICENSE)

---

## 🙏 Acknowledgements

- Based on the [Superpowers](https://github.com/obra/superpowers) skill format by Jesse Vincent
- Inspired by mature software engineering practices
- Chinese localization by sw-superpower contributors

---

<div align="center">

**Making AI programming more systematic, predictable, and high-quality** 🚀

</div>
