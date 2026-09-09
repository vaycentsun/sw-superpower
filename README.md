<div align="right">
  <strong>🇺🇸 English</strong> | <a href="./README.zh.md">🇨🇳 中文</a> | <a href="./README.ja.md">🇯🇵 日本語</a> | <a href="./README.es.md">🇪🇸 Español</a> | <a href="./README.fr.md">🇫🇷 Français</a>
</div>

# sw-agiledevelopment 🦸

> An Agile Development skill set for AI coding agents — structured software engineering workflows from requirements clarification to code review.

A complete set of software engineering workflow skills that help AI coding agents complete every step from requirements analysis to code review in a systematic, reproducible way.

**Multi-Platform Support**: This framework natively supports **OpenCode** (plugin, recommended), **Codex** (plugin), **GitHub Copilot** (skill mode), and **ZCode** (plugin). Choose your preferred AI agent platform and follow the installation guide below.

---

## 🚀 Quick Start

### Installation

**OpenCode Plugin (Recommended)**

Tell your AI Agent:

> "Install the sw-agiledevelopment plugin from https://github.com/vaycentsun/sw-agiledevelopment and follow the instructions in `.opencode/INSTALL.md`."

The Agent will read the install guide, configure the plugin, and verify the setup automatically.

**Codex Plugin Installation**

Tell your AI Agent:

> "Install the sw-agiledevelopment plugin from https://github.com/vaycentsun/sw-agiledevelopment and follow the instructions in `.codex-plugin/INSTALL.md`."

The Agent will read the install guide, configure the plugin, and verify the setup automatically.

**GitHub Copilot (Skill Mode)**

Tell your AI Agent:

> "Install the sw-agiledevelopment Copilot skill from https://github.com/vaycentsun/sw-agiledevelopment and follow the instructions in `.github/INSTALL.md`."

The Agent will:
1. Copy `.github/copilot-instructions.md` to your project's `.github/` directory (Copilot reads this automatically in every Chat session)
2. Copy all `sw-*/` skill directories to your project's `.sw-agiledevelopment/` directory (for detailed reference)

No Marketplace token or VSIX installation required. Copilot will automatically follow the agile development workflow once installed.

**Android Studio (AI Agent)**

Tell your AI Agent:

> "Install the sw-agiledevelopment framework from https://github.com/vaycentsun/sw-agiledevelopment and follow the instructions in `.androidstudio/INSTALL.md`."

The Agent will:
1. Copy `.androidstudio/sw-agiledevelopment.md` to your project's `.androidstudio/` directory (Android Studio AI Agent reads this as the system prompt)
2. Copy all `sw-*/` skill directories to your project's `.sw-agiledevelopment/` directory (for detailed reference)

No plugin installation required. The Android Studio AI Agent will automatically follow the agile development workflow once installed.

**Tongyi Lingma (AI Agent)**

Tell your AI Agent:

> "Install the sw-agiledevelopment lingma agent from https://github.com/vaycentsun/sw-agiledevelopment and follow the instructions in `.lingma/INSTALL.md`."

The Agent will read the install guide, configure the agent, and verify the setup automatically.

**ZCode Plugin**

In the ZCode client, open **Settings → Plugin Management → Discover**, click **+**, add the marketplace `vaycentsun/sw-agiledevelopment`, then click **Get** on the plugin card. Upgrades are one click when a new version is published.

Or tell your AI Agent:

> "Install the sw-agiledevelopment ZCode plugin from https://github.com/vaycentsun/sw-agiledevelopment and follow the instructions in `.zcode-plugin/INSTALL.md`."

The Agent will read the install guide, register the plugin (via marketplace or filesystem install), and verify that the SessionStart bootstrap hook injects the agile workflow into every new session.

---

## 🗺️ Core Workflow

```
Start New Feature
    ↓
sw-requirements-clarification
    ↓ Output: business-specs/YYYY-MM-DD--feature.md
sw-technical-spec
    ↓ Output: technical-specs/YYYY-MM-DD--feature.md
sw-working-plan
    ↓ Output: plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development
    ├── sw-test-driven-dev (TDD for each task)
    ├── sw-code-review (Review after tasks)
    ↓
sw-task-verification
    ↓
sw-finishing-branch
```

**Alternative paths:**
- `sw-execute-plan` — Execute plans in the same session without subagents
- `sw-parallel-debugging` — Parallel debugging for independent failures

---

## 📝 TODO

- **TODO**: Integrate visual requirements analysis to enhance requirements analysis and documentation before the requirements-clarification stage.

---

## 📋 Skills

| Skill | Purpose | Trigger |
|-------|---------|---------|
| **sw-requirements-clarification** | Transform ideas into business requirements | Starting new feature |
| **sw-technical-spec** | Write structured technical specification | Requirements clarified |
| **sw-working-plan** | Create detailed implementation plans | Need execution plan |
| **sw-subagent-development** | Execute plans using subagents | Tasks are independent |
| **sw-execute-plan** | Execute plans in same session | Not using subagents |
| **sw-test-driven-dev** | Enforce RED-GREEN-REFACTOR cycle | Implementing or fixing |
| **sw-code-review** | Request & handle code review feedback | After task, before merge |
| **sw-systematic-debugging** | Systematic bug investigation | Bugs or test failures |
| **sw-parallel-debugging** | Parallel debugging | 2+ independent failures |
| **sw-task-verification** | Verify task completion | Ready to mark complete |
| **sw-finishing-branch** | Verify, decide, and clean up branch | All tasks completed |
| **sw-writing-skills** | Create and validate new skills | Need a new skill |
| **sw-using-agiledevelopment** | Skill system bootstrap | Every conversation start |

---

## 📄 License

[MIT](./LICENSE)

---

## 🙏 Acknowledgements

- Based on the Agile Development methodology, originally inspired by the [Superpowers](https://github.com/obra/superpowers) skill format
- Inspired by mature software engineering practices
