# 安装指南

sw-superpower 是一套纯 Markdown 格式的技能文件，可在任何支持技能/系统提示注入的 AI 编程平台上使用。

## 平台支持

| 平台 | 安装方式 | 自动引导 | 备注 |
|------|----------|----------|------|
| **OpenCode** | 插件市场 / 手动 clone | ✅ 插件自动注入 | 首选平台，完整功能 |
| **Claude Code** | `~/.claude/skills/` 目录 | ⚠️ 需手动配置 | 支持 skill 工具 |
| **Cursor** | `.cursorrules` / 设置 | ⚠️ 需手动配置 | 粘贴核心提示词 |
| **Gemini CLI** | 扩展 / 手动配置 | ⚠️ 需手动配置 | 支持 extensions |
| **GitHub Copilot CLI** | 插件 / 手动配置 | ⚠️ 需手动配置 | 支持 plugins |
| **OpenAI Codex** | 插件 / 手动配置 | ⚠️ 需手动配置 | 支持插件系统 |
| **其他** | 系统提示注入 | ⚠️ 需手动配置 | 任何支持长上下文的平台 |

---

## OpenCode（推荐）

### 方式一：Plugin 市场（推荐）

在 `opencode.json` 中添加：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/your-username/sw-superpower.git"]
}
```

重启 OpenCode。插件会自动：
- 注册所有技能路径
- 在每个新会话自动注入 `sw-using-superpowers` 引导提示词
- 提供 OpenCode 工具映射

### 方式二：手动 Clone

```bash
git clone https://github.com/your-username/sw-superpower.git \
  ~/.config/opencode/plugins/sw-superpower

# 创建插件入口
ln -s ~/.config/opencode/plugins/sw-superpower/.opencode/plugins/superpowers.js \
  ~/.config/opencode/plugins/superpowers.js
```

在 `opencode.json` 中添加技能路径：

```json
{
  "skills": {
    "paths": ["~/.config/opencode/plugins/sw-superpower"]
  }
}
```

重启 OpenCode。

### 验证安装

```
告诉我你的 superpowers
```

Agent 应该回复它已加载的技能列表，并说明会自动检查技能。

---

## Claude Code

### 安装

```bash
# 创建 skills 目录（如果不存在）
mkdir -p ~/.claude/skills

# Clone 本仓库
git clone https://github.com/your-username/sw-superpower.git \
  ~/.claude/skills/sw-superpower
```

### 配置

编辑或创建 `~/.claude/CLAUDE.md`：

```markdown
# Superpowers 技能系统

你拥有 sw-superpower 软件工程技能集。

**技能路径**: `~/.claude/skills/sw-superpower/`

## 规则

在做出任何回应或行动之前，调用相关技能。即使只有 1% 的概率某个技能可能适用，你也应该调用 `Skill` 工具检查。

**指令优先级**：
1. 用户明确指令（最高）
2. Superpowers 技能
3. 默认系统提示

## 如何加载技能

使用 Claude Code 的 `Skill` 工具：
- `Skill` 加载技能内容
- 技能内容加载后直接遵循

## 工具映射

本技能集使用 Claude Code 原生工具名，无需替换：
- `TodoWrite` → `TodoWrite`
- `Task` 工具带子 Agent → `Task`
- `Skill` 工具 → `Skill`
- `Read`、`Write`、`Edit`、`Bash` → 原生工具

## 核心工作流

```
开始新功能
    ↓
sw-brainstorming (头脑风暴与设计)
    ↓ 输出: docs/superpowers/specs/YYYY-MM-DD--feature-design.md
sw-writing-specs (编写实现计划)
    ↓ 输出: docs/superpowers/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (子 Agent 驱动开发)
    ├── sw-test-driven-dev (每个任务遵循 TDD)
    └── sw-requesting-code-review (任务后审查)
    ↓
sw-verification-before-completion (完成前验证)
    ↓
sw-finishing-branch (完成分支)
```

## 可用技能

```
sw-brainstorming/               # 头脑风暴与需求分析
sw-writing-specs/               # 编写实现计划
sw-subagent-development/        # 子 Agent 驱动开发
sw-test-driven-dev/             # 测试驱动开发
sw-requesting-code-review/      # 请求代码审查
sw-receiving-code-review/       # 接收代码审查
sw-systematic-debugging/        # 系统化调试
sw-dispatching-parallel-agents/ # 并行分派 Agent
sw-executing-plans/             # 执行计划
sw-using-git-worktrees/         # Git 工作区管理
sw-verification-before-completion/ # 完成前验证
sw-finishing-branch/            # 完成开发分支
sw-writing-skills/              # 编写新技能
sw-using-superpowers/           # 技能系统引导（核心入口）
```

如果技能适用，你没有选择——必须使用它。
```

重启 Claude Code 或新建会话生效。

---

## Cursor

### 安装

将 `sw-using-superpowers/SKILL.md` 的核心内容复制到项目根目录的 `.cursorrules` 文件中。

或者全局配置：
```bash
# 复制核心引导提示词
cat ~/.cursor/extensions/sw-superpower/sw-using-superpowers/SKILL.md >> ~/.cursor/rules.md
```

### 简化版 `.cursorrules`

如果你不想粘贴完整内容，使用最小化配置：

```markdown
# sw-superpower 最小配置

## 规则
- 在回应前，检查 `sw-*/SKILL.md` 是否有适用的技能
- 技能覆盖默认行为
- 用户指令始终优先

## 核心工作流
brainstorming → writing-specs → subagent-development → verification → finishing-branch

## 工具映射
- `TodoWrite` → Cursor 的任务跟踪（如有）
- `Task` 子 Agent → Composer Agent
- `Skill` → 读取对应 SKILL.md 文件
- `Read/Write/Edit/Bash` → 原生工具

## 目录
- 技能：`sw-*/SKILL.md`
- Spec：`docs/superpowers/specs/`
- 计划：`docs/superpowers/plans/`
```

---

## Gemini CLI

### 安装

```bash
gemini extensions install https://github.com/your-username/sw-superpower
```

或在 `~/.gemini/config` 中配置技能路径，将 `sw-using-superpowers/SKILL.md` 内容添加到 `GEMINI.md`。

### 手动配置

创建/编辑 `~/GEMINI.md`：

```markdown
# Gemini 的 sw-superpower 配置

将 `sw-using-superpowers/SKILL.md` 的完整内容粘贴到此处。

## 工具映射
- `TodoWrite` → 无直接等效，使用文本列表跟踪
- `Task` 子 Agent → Gemini 的多轮对话
- `Skill` → 读取文件
- `Read/Write/Edit` → 代码操作工具
```

---

## GitHub Copilot CLI

```bash
# 注册 superpowers 市场（如使用原版）
copilot plugin marketplace add obra/superpowers-marketplace

# 安装 sw-superpower（如已发布到市场）
copilot plugin install sw-superpower@superpowers-marketplace
```

手动安装：将技能目录放入 Copilot 配置目录，并在配置中引用。

---

## OpenAI Codex

在 Codex 的插件设置中，添加本仓库 URL：

```
https://github.com/your-username/sw-superpower
```

或在 Codex 的系统提示中粘贴 `sw-using-superpowers/SKILL.md` 内容。

---

## 通用手动安装（任何平台）

如果你的平台不支持上述任何方式，使用**最小化手动安装**：

### 步骤 1：Clone 仓库

```bash
git clone https://github.com/your-username/sw-superpower.git
```

### 步骤 2：在你的系统提示中引用

将以下内容添加到你的 AI Agent 系统提示中：

```markdown
# sw-superpower 技能系统

你拥有位于 `<仓库路径>/sw-superpower/` 的软件工程技能集。

**核心规则**：
1. 在做出任何回应前，检查是否有适用的技能
2. 技能内容覆盖默认行为
3. 用户指令始终优先

**工作流**：
sw-brainstorming → sw-writing-specs → sw-subagent-development → sw-verification-before-completion → sw-finishing-branch

**重要技能**：
- sw-using-superpowers：技能系统引导（每次会话开始时加载）
- sw-test-driven-dev：TDD 强制
- sw-systematic-debugging：调试

加载方式：读取对应目录下的 `SKILL.md` 文件。
```

### 步骤 3：平台工具映射

根据你的平台替换工具名：

| 本技能集引用 | OpenCode | Claude Code | Cursor | Gemini | Copilot |
|-------------|----------|-------------|--------|--------|---------|
| `TodoWrite` | `todowrite` | `TodoWrite` | 手动列表 | 文本列表 | 任务列表 |
| `Task` (subagent) | OpenCode 子 Agent | `Task` | Composer Agent | 多轮对话 | Agent |
| `Skill` | `skill` | `Skill` | 读取文件 | 读取文件 | 读取文件 |
| `Read` | `read` | `Read` | 读取 | 读取 | 读取 |
| `Write` | `write` | `Write` | 写入 | 写入 | 写入 |
| `Edit` | `edit` | `Edit` | 编辑 | 编辑 | 编辑 |
| `Bash` | `bash` | `Bash` | 终端 | 终端 | 终端 |

---

## 验证安装

无论使用哪种平台，安装后测试以下场景：

1. **技能发现**：Agent 能否列出可用技能？
2. **自动触发**：用户说"我想开发新功能"时，Agent 是否自动加载 `sw-brainstorming`？
3. **工具映射**：Agent 是否能正确使用你平台的工具名？
4. **工作流**：Agent 是否能按顺序调用 `brainstorming → writing-specs → development`？

---

## 更新

### Git 方式

```bash
cd <sw-superpower 安装路径>
git pull origin main
```

### Submodule 方式

```bash
cd <你的项目>
git submodule update --remote --merge
```

### Plugin 方式（OpenCode）

重启 OpenCode 自动更新，或固定版本：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/your-username/sw-superpower.git#v1.0.0"]
}
```

---

## 获取帮助

- 报告问题：https://github.com/your-username/sw-superpower/issues
- 原版项目：https://github.com/obra/superpowers
- 讨论区：https://github.com/your-username/sw-superpower/discussions
