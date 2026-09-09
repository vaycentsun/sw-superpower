<div align="right">
  <a href="./README.md">🇺🇸 English</a> | <strong>🇨🇳 中文</strong> | <a href="./README.ja.md">🇯🇵 日本語</a> | <a href="./README.es.md">🇪🇸 Español</a> | <a href="./README.fr.md">🇫🇷 Français</a>
</div>

# sw-agiledevelopment 🦸

> 为 AI 编程 Agent 设计的 Agile Development 技能集 — 从需求澄清到代码审查的结构化软件工程工作流。

一套完整的软件开发工作流技能，帮助 AI 编程 Agent 以系统化、可复现的方式完成从需求分析到代码审查的每个环节。

**多平台支持**：本框架原生支持 **OpenCode**（插件，推荐）、**Codex**（插件）、**GitHub Copilot**（Skill 模式）和 **ZCode**（插件）。选择你偏好的 AI Agent 平台，按照下方的安装指南进行安装即可。

---

## 🚀 快速开始

### 安装

**OpenCode 插件（推荐）**

直接告诉你的 AI Agent：

> "从 https://github.com/vaycentsun/sw-agiledevelopment 安装 sw-agiledevelopment 插件，并参考 `.opencode/INSTALL.md` 中的说明进行安装。"

Agent 会自动读取安装指南，配置插件并验证安装。

**Codex 插件安装**

直接告诉你的 AI Agent：

> "从 https://github.com/vaycentsun/sw-agiledevelopment 安装 sw-agiledevelopment 插件，并参考 `.codex-plugin/INSTALL.md` 中的说明进行安装。"

Agent 会自动读取安装指南，配置插件并验证安装。

**GitHub Copilot (Skill 模式)**

直接告诉你的 AI Agent：

> "从 https://github.com/vaycentsun/sw-agiledevelopment 安装 sw-agiledevelopment Copilot skill，并参考 `.github/INSTALL.md` 中的说明进行安装。"

Agent 会：
1. 将 `.github/copilot-instructions.md` 复制到你项目的 `.github/` 目录下（Copilot 会在每次 Chat 会话中自动读取）
2. 将所有 `sw-*/` 技能目录复制到你项目的 `.sw-agiledevelopment/` 目录下（用于详细参考）

无需 Marketplace token 或 VSIX 安装。安装完成后，Copilot 会自动遵循敏捷开发工作流。

**Android Studio (AI Agent)**

直接告诉你的 AI Agent：

> "从 https://github.com/vaycentsun/sw-agiledevelopment 安装 sw-agiledevelopment 框架，并参考 `.androidstudio/INSTALL.md` 中的说明进行安装。"

Agent 会：
1. 将 `.androidstudio/sw-agiledevelopment.md` 复制到你项目的 `.androidstudio/` 目录下（Android Studio AI Agent 会将其作为 system prompt 读取）
2. 将所有 `sw-*/` 技能目录复制到你项目的 `.sw-agiledevelopment/` 目录下（用于详细参考）

无需安装插件。安装完成后，Android Studio AI Agent 会自动遵循敏捷开发工作流。

**通义灵码（AI Agent）**

直接告诉你的 AI Agent：

> "从 https://github.com/vaycentsun/sw-agiledevelopment 安装 sw-agiledevelopment lingma agent，并参考 `.lingma/INSTALL.md` 中的说明进行安装。"

Agent 会自动读取安装指南，配置 agent 并验证安装。

**ZCode 插件**

在 ZCode 客户端中打开 **设置 → 插件管理 → Discover**，点击 **+** 添加市场 `vaycentsun/sw-agiledevelopment`，然后在插件卡片上点击 **Get** 安装。之后有新版本时可一键升级。

或者直接告诉你的 AI Agent：

> "从 https://github.com/vaycentsun/sw-agiledevelopment 安装 sw-agiledevelopment ZCode 插件，并参考 `.zcode-plugin/INSTALL.md` 中的说明进行安装。"

Agent 会自动读取安装指南，通过 marketplace 或文件系统方式注册插件，并验证 SessionStart bootstrap 钩子是否在每次新会话中注入敏捷工作流。

---

## 🗺️ 核心工作流

```
开始新功能
    ↓
sw-requirements-clarification (需求澄清与分析)
    ↓ 输出: business-specs/YYYY-MM-DD--feature.md
sw-technical-spec (编写技术规格)
    ↓ 输出: technical-specs/YYYY-MM-DD--feature.md
sw-working-plan (编写实现计划)
    ↓ 输出: plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (子 Agent 驱动开发)
    ├── sw-test-driven-dev (每个任务遵循 TDD)
    ├── sw-code-review (任务后审查)
    ↓
sw-task-verification (任务验证)
    ↓
sw-finishing-branch (完成分支)
```

**替代路径：**
- `sw-execute-plan` — 同会话中批量执行计划（不使用子 Agent）
- `sw-parallel-debugging` — 并行调试多个独立失败

---

## 📝 TODO

- **TODO**: 后续将结合可视化需求分析，在 requirements-clarification（需求澄清）阶段前增强需求分析与文档编写。

---

## 📋 技能一览

| 技能 | 用途 | 触发条件 |
|------|------|----------|
| **sw-requirements-clarification** | 将想法转化为业务需求 | 开始新功能开发 |
| **sw-technical-spec** | 编写结构化的技术规格文档 | 需求已澄清 |
| **sw-working-plan** | 创建详细的实现计划 | 需要执行计划 |
| **sw-subagent-development** | 使用子 Agent 执行计划 | 任务相对独立 |
| **sw-execute-plan** | 同会话中批量执行计划 | 不使用子 Agent |
| **sw-test-driven-dev** | 强制 RED-GREEN-REFACTOR 循环 | 实现功能或修复 Bug |
| **sw-code-review** | 请求并处理代码审查反馈 | 任务完成后、合并前 |
| **sw-systematic-debugging** | 系统化 Bug 调查 | 发现 Bug 或测试失败 |
| **sw-parallel-debugging** | 并行调试 | 2+ 独立失败 |
| **sw-task-verification** | 验证任务完成度 | 准备标记任务完成 |
| **sw-finishing-branch** | 验证、决策、清理分支 | 所有任务完成 |
| **sw-writing-skills** | 创建和验证新技能 | 需要创建新技能 |
| **sw-using-agiledevelopment** | 技能系统引导（核心入口） | 任何对话开始时 |

---

## 📄 许可证

[MIT](./LICENSE)

---

## 🙏 致谢

- 基于 Agile Development 方法论，灵感源自 [Superpowers](https://github.com/anthropics/superpowers) 技能格式
- 灵感来源于成熟的软件工程实践
