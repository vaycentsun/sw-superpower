# OpenCode 安装与使用指南

> 在 OpenCode 平台上安装和使用 sw-superpower 的完整指南。

## 安装

### 方式一：插件安装（推荐）

在 `opencode.json`（全局或项目级）的 `plugin` 数组中添加：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/vaycentsun/sw-superpower.git"]
}
```

重启 OpenCode。插件会自动通过 Bun 安装并注册所有技能。

**验证安装**：询问 Agent "Tell me about your superpowers"

### 方式二：Git Submodule

```bash
cd <你的项目>/skills/
git submodule add https://github.com/vaycentsun/sw-superpower.git
git submodule update --init --recursive
```

**后续更新**：

```bash
cd <你的项目>/skills/sw-superpower
git pull origin main
cd <你的项目>
git add skills/sw-superpower
git commit -m "Update sw-superpower submodule"
```

### 方式三：直接克隆（不推荐用于版本控制项目）

```bash
cd <你的项目>/skills/
git clone https://github.com/vaycentsun/sw-superpower.git
```

重启 OpenCode 或重新加载技能。

---

## 工具映射

sw-superpower 的 Skill 使用 Claude Code 工具名称。在 OpenCode 中，自动映射为以下等效工具：

| Claude Code 工具 | OpenCode 等效项 |
|-----------------|----------------|
| `TodoWrite` | `todowrite` |
| `Task` 工具配子 Agent | OpenCode 子 Agent 系统（`@mention`） |
| `Skill` 工具 | OpenCode 原生 `skill` 工具 |
| `Read` | `read` |
| `Write` | `write` |
| `Edit` | `edit` |
| `Bash` | `bash` |
| `Grep` | `grep` |
| `Glob` | `glob` |
| `WebFetch` | `webfetch` |

---

## 使用方法

### 发现技能

使用 OpenCode 的 `skill` 工具列出所有可用技能：

```
使用 skill 工具列出所有技能
```

### 加载技能

```
使用 skill 工具加载 sw-brainstorming
```

### 个人技能

在 `~/.config/opencode/skills/` 创建你自己的技能：

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

创建 `~/.config/opencode/skills/my-skill/SKILL.md`：

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

### 项目级技能

在项目内创建 `.opencode/skills/` 目录存放项目特定技能。

**技能优先级**：项目技能 > 个人技能 > sw-superpower 技能

---

## 核心工作流

开始使用新功能时，Agent 会自动识别并应用适当的 Skill：

```
用户: 我要开发一个用户认证功能

Agent: [自动应用 sw-brainstorming Skill]
      1. 探索项目上下文...
      2. 提出澄清问题...
      3. 提出 2-3 种方案...
      4. 分节呈现设计...
      5. 编写 Spec 文档 → dev/specs/2026-04-18--user-auth.md
      6. 调用 sw-writing-specs 创建实现计划...
```

完整工作流顺序：

```
开始新功能
    ↓
sw-brainstorming (头脑风暴与设计)
    ↓ 输出: dev/specs/YYYY-MM-DD--feature.md
sw-writing-specs (编写实现计划)
    ↓ 输出: dev/specs/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (子 Agent 驱动开发)
    ├── sw-test-driven-dev (每个任务遵循 TDD)
    ├── sw-requesting-code-review (任务后审查)
    └── sw-receiving-code-review (处理审查反馈)
    ↓
sw-verification-before-completion (完成前验证)
    ↓
sw-finishing-branch (完成分支)
```

替代路径：
- **sw-executing-plans** — 不使用子 Agent 时，在同一会话中批量执行计划
- **sw-dispatching-parallel-agents** — 多个独立任务需要并行处理时

---

## 更新

sw-superpower 在重启 OpenCode 时自动更新（插件方式）。

要固定特定版本，使用分支或标签：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/vaycentsun/sw-superpower.git#v1.0.0"]
}
```

---

## 故障排除

### 插件未加载

1. 检查 OpenCode 日志：`opencode run --print-logs "hello" 2>&1 | grep -i superpowers`
2. 验证 `opencode.json` 中的插件配置是否正确
3. 确保 OpenCode 版本足够新

### 技能未找到

1. 使用 `skill` 工具列出已发现的技能
2. 检查插件是否已加载（参见上文）
3. 每个技能需要包含有效的 YAML frontmatter 的 `SKILL.md` 文件

### 引导内容未出现

1. 检查 OpenCode 版本是否支持 `experimental.chat.system.transform` 钩子
2. 重启 OpenCode 后再次尝试

---

## 相关资源

- 主项目文档：[README.md](../README.md)
- Agent 行为指导：[AGENTS.md](../AGENTS.md)
- 项目仓库：https://github.com/vaycentsun/sw-superpower
- 上游框架：[obra/superpowers](https://github.com/obra/superpowers)
