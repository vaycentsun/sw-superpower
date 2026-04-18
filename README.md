<div align="right">
  <strong>🇺🇸 English</strong> | <a href="./README.zh.md">🇨🇳 中文</a> | <a href="./README.ja.md">🇯🇵 日本語</a> | <a href="./README.es.md">🇪🇸 Español</a> | <a href="./README.fr.md">🇫🇷 Français</a>
</div>

# sw-superpower 🦸

> A Superpowers-style skill set for AI coding agents — structured software engineering workflows from brainstorming to code review.

A complete set of software engineering workflow skills that help AI coding agents complete every step from requirements analysis to code review in a systematic, reproducible way.

---

## 📦 Overview

`sw-superpower` is a Superpowers-style skill set designed for [Kimi Code CLI](https://github.com/MoonshotAI/kimi-code). It encapsulates mature software engineering practices (TDD, code review, systematic debugging) into structured, reusable agent skills.

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
├── sw-code-review/                # Code review
├── sw-systematic-debugging/       # Systematic debugging
├── sw-verification-before-completion/  # Pre-completion verification
├── sw-finishing-branch/           # Finishing development branch
├── sw-using-git-worktrees/        # Git worktree management
└── sw-writing-skills/             # Writing new skills (meta skill)
```

---

## 🚀 Core Workflow

The complete software development workflow executes in the following order:

```
Start New Feature
    ↓
sw-brainstorming (Brainstorming & Design)
    ↓ Output: dev/specs/YYYY-MM-DD--feature.md
sw-writing-specs (Writing Implementation Plan)
    ↓ Output: dev/specs/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (Subagent-Driven Development)
    ├── sw-test-driven-dev (TDD for each task)
    └── sw-code-review (Two-phase review)
    ↓
sw-verification-before-completion (Pre-Completion Verification)
    ↓
sw-finishing-branch (Finishing Branch)
```

---

## 📋 Skills Overview

| Skill | Purpose | Trigger Condition |
|-------|---------|-------------------|
| **sw-brainstorming** | Transform ideas into complete design and specs | Starting new feature development |
| **sw-writing-specs** | Create detailed implementation plans | Design approved, need execution plan |
| **sw-subagent-development** | Execute plans using subagents | Have implementation plan, tasks are independent |
| **sw-test-driven-dev** | Enforce RED-GREEN-REFACTOR cycle | Implementing any feature or fixing bugs |
| **sw-code-review** | Two-phase code review | After completing task or feature |
| **sw-systematic-debugging** | Systematic bug investigation | Bugs found or tests failing |
| **sw-verification-before-completion** | Pre-completion verification | Ready to mark task as complete |
| **sw-finishing-branch** | Verify, decide, and clean up branch | All tasks completed |
| **sw-using-git-worktrees** | Create isolated workspaces | Starting new feature, need parallel development |
| **sw-writing-skills** | Create and validate new skills | Need to create a new skill |

---

## 🎯 Quick Start

### Installation

1. Clone the repository to your Kimi Code CLI skills directory:

```bash
# Assuming Kimi Code CLI skills directory is ~/.kimi/skills/
cd ~/.kimi/skills/
git clone https://github.com/your-username/sw-superpower.git
```

2. Restart Kimi Code CLI or reload skills.

### Usage Example

When you start a new feature, the agent automatically recognizes and applies the appropriate skill:

```
User: I want to develop a user authentication feature

Agent: [Automatically applies sw-brainstorming Skill]
      1. Explore project context...
      2. Ask clarifying questions...
      3. Propose 2-3 approaches...
      4. Present design in sections...
      5. Write spec document → dev/specs/2026-04-18--user-auth.md
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
└── templates/                  # Template files (optional)
    └── <template>.md
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

- Based on the [Superpowers](https://github.com/anthropics/superpowers) skill format
- Inspired by mature software engineering practices

---

<div align="center">

**Making AI programming more systematic, predictable, and high-quality** 🚀

</div>
