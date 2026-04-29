# sw-superpower — Agent 上下文

> **这是什么仓库：** 一个为 OpenCode 设计的 Superpowers 风格技能框架。"源代码"是 `sw-*/` 目录下的 SKILL.md 文件，不是一个传统的代码项目。这是 [obra/superpowers](https://github.com/obra/superpowers) 的中文本地化分支。

## 编辑前必须知道的事

### 这是一个技能框架，不是应用
- "源码"是 `sw-*/` 目录下的 SKILL.md 文件。没有 `npm test`，没有构建步骤，也没有传统的应用入口。
- `package.json` 的存在只是为了 OpenCode 能通过 `git+` URL 安装插件。**不要**往里面添加依赖或脚本。
- `.opencode/plugins/sw-superpowers.js` 插件通过两个钩子将技能注入会话：
  - `config` — 将仓库根目录注册到 `config.skills.paths`，让 OpenCode 发现 `sw-*/SKILL.md` 文件。
  - `experimental.chat.messages.transform` — 在每个会话的第一条用户消息前，插入 `sw-using-superpowers/SKILL.md` 内容（加上工具映射）。

### 文件路径约定
- **Spec 文件**: `dev/specs/YYYY-MM-DD--<feature-name>-design.md`
- **计划文件**: `dev/specs/plans/YYYY-MM-DD--<feature-name>-plan.md`
- **Skill 目录**: `sw-<skill-name>/`
- **子 Agent 提示词**: `subagent-prompts/<name>-prompt.md`

### 指令优先级（框架设计）
Superpowers 技能覆盖默认系统提示，但**用户指令始终优先**：
1. 用户的明确指令（CLAUDE.md、GEMINI.md、AGENTS.md、直接请求）—— 最高优先级
2. Superpowers 技能 —— 与默认行为冲突时覆盖
3. 默认系统提示 —— 最低优先级

如果你编辑包含硬规则的技能（如"始终使用 TDD"），**不要**弱化它们。这个框架的设计就是对工作流纪律保持严格。

### Pre-Push 钩子 — 激活它
```bash
ln -s ../../hooks/pre-push .git/hooks/pre-push
```
钩子会强制执行 SKILL.md 约束。**已知 bug：** 代码里检查的是 `> 500` 行，但消息说"上限 600"。如果你编辑钩子，修复这个不一致。

### 如何验证变更
```bash
# 运行 bash 测试套件（不是 npm test）
bash tests/opencode/run-tests.sh

# 运行单个测试
bash tests/opencode/run-tests.sh -t test-skill-structure.sh
```

### 技能文件约束（钩子 + 测试双重验证）
| 约束 | 详情 |
|------|------|
| **Frontmatter** | 必须以 `---` 开头，包含 `name:` 和 `description:` |
| **行数限制** | ~500–600 行。超出的技能拆分成多个 `.md` 文件（参考 `sw-writing-skills/` 结构：SKILL.md + cso-guide.md + skill-creation-workflow.md） |
| **红旗** | 必须包含 `## 红旗` 或 `## Red Flags` 章节 |
| **常见借口表** | 必须包含常见借口表格（如 `| 想法 | 现实 |`） |
| **命名** | 目录名必须匹配 `sw-<skill-name>/`，且与 frontmatter 中的 `name:` 字段一致 |

### 技能 Frontmatter 格式
```markdown
---
name: sw-example
description: "Use when [specific trigger condition]"
---
```
**重要：** 插件的 frontmatter 解析器是一个简单的基于冒号的解析器（见 `.opencode/plugins/sw-superpowers.js`）。**不要**使用复杂 YAML 特性，如多行字符串或嵌套对象。

## 架构

```
sw-superpower/
├── sw-*/                  # 14 个技能目录，每个含 SKILL.md（+ 可选的 subagent-prompts/、templates/、scripts/）
├── .opencode/plugins/      # OpenCode 插件：sw-superpowers.js（自动注册技能 + 注入引导内容）
├── tests/opencode/         # Bash 测试套件（3 个测试：插件加载、技能结构、工具映射）
├── hooks/                  # Git 钩子（pre-push 验证）
├── docs/                   # 面向人类的文档
└── package.json            # 供 OpenCode 通过 git URL 安装插件所需
```

## 插件工作原理
1. **Config 钩子**：将仓库根目录加入 `config.skills.paths`，让 OpenCode 发现 `sw-*/SKILL.md` 文件。
2. **Transform 钩子**：在每个会话的第一条用户消息中，前置插入 `sw-using-superpowers/SKILL.md` 内容（加上 OpenCode 工具映射）作为用户消息的一部分。
3. **效果**：Agent 自动看到 "You have superpowers" 上下文，无需手动加载技能。

## 安装方式

**插件方式（全局，推荐）**
添加到 `~/.config/opencode/opencode.json`：
```json
{
  "plugin": ["sw-superpower@git+http://192.168.1.100:53000/vaycent/sw-superpower.git#main"],
  "permission": { "skill": { "*": "allow" } }
}
```
重启 OpenCode。插件会通过 Bun 自动安装。

**Git submodule（项目级）**
```bash
cd <项目>/skills/
git submodule add https://github.com/vaycentsun/sw-superpower.git
```

## 添加或编辑技能时
1. 创建 `sw-<name>/` 目录，放入 `SKILL.md`。
2. 包含 frontmatter、红旗章节、常见借口表。
3. 提交前运行 `bash tests/opencode/run-tests.sh`。
4. 确保 `git push` 通过 pre-push 钩子。
5. 如果技能超出行数限制，在同一个 `sw-*/` 目录内拆成多个 `.md` 文件（参考 `sw-writing-skills/` 的结构）。

## 忽略的文件
- `.opencode/node_modules/`、`.opencode/package*.json` —— 插件开发依赖，不是项目源码。
- `tests/opencode/*.sh` 的输出 —— 测试是自包含且无状态的。

## 相关文档
- `docs/install-opencode.md` —— 面向人类的 OpenCode 安装指南
- `sw-writing-skills/SKILL.md` —— 编写新技能的元技能
- `tests/README.md` —— 测试套件文档
