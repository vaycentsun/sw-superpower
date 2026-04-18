# sw-superpower 🦸

> 为 AI 编程 Agent 设计的软件工程技能集 (Superpowers 风格)

[![中文](https://img.shields.io/badge/lang-中文-brightgreen.svg)](./README.md)

这是一套完整的软件开发工作流指导技能，帮助 AI 编程 Agent 以系统化、可复现的方式完成从需求分析到代码审查的每个环节。

---

## 📦 项目概述

`sw-superpower` 是一套为 [Kimi Code CLI](https://github.com/MoonshotAI/kimi-code) 设计的 Superpowers 风格技能集。它将成熟的软件工程实践（TDD、代码审查、系统化调试）封装成结构化、可复用的 Agent 技能。

### 核心理念

- **流程驱动**: 每个 Skill 定义明确的触发条件和执行流程
- **铁律优先**: 不可违反的规则放在最前面
- **压力测试**: 通过 TDD 方式创建和验证 Skill
- **渐进交付**: 从头脑风暴到代码交付的完整工作流

---

## 🗂️ 项目结构

```
sw-superpower/
├── sw-brainstorming/              # 头脑风暴与需求分析
├── sw-writing-specs/              # 编写实现计划
├── sw-subagent-development/       # 子 Agent 驱动开发
├── sw-test-driven-dev/            # 测试驱动开发
├── sw-code-review/                # 代码审查
├── sw-systematic-debugging/       # 系统化调试
├── sw-verification-before-completion/  # 完成前验证
├── sw-finishing-branch/           # 完成开发分支
├── sw-using-git-worktrees/        # Git 工作区管理
└── sw-writing-skills/             # 编写新技能（元 Skill）
```

---

## 🚀 核心工作流

完整的软件开发工作流按以下顺序执行：

```
开始新功能
    ↓
sw-brainstorming (头脑风暴与设计)
    ↓ 输出: dev/specs/YYYY-MM-DD--feature.md
sw-writing-specs (编写实现计划)
    ↓ 输出: dev/specs/plans/YYYY-MM-DD--feature-plan.md
sw-subagent-development (子 Agent 驱动开发)
    ├── sw-test-driven-dev (每个任务遵循 TDD)
    └── sw-code-review (两阶段审查)
    ↓
sw-verification-before-completion (完成前验证)
    ↓
sw-finishing-branch (完成分支)
```

---

## 📋 Skill 一览

| Skill | 用途 | 触发条件 |
|-------|------|----------|
| **sw-brainstorming** | 将想法转化为完整设计和 Spec | 开始新功能开发 |
| **sw-writing-specs** | 创建详细的实现计划 | 设计已批准，需要执行计划 |
| **sw-subagent-development** | 使用子 Agent 执行计划 | 有实现计划，任务相对独立 |
| **sw-test-driven-dev** | 强制 RED-GREEN-REFACTOR 循环 | 实现任何功能或修复 Bug |
| **sw-code-review** | 两阶段代码审查 | 完成任务或功能后 |
| **sw-systematic-debugging** | 系统化 Bug 调查 | 发现 Bug 或测试失败 |
| **sw-verification-before-completion** | 标记完成前验证 | 准备标记任务完成 |
| **sw-finishing-branch** | 验证、决策、清理分支 | 所有任务完成 |
| **sw-using-git-worktrees** | 创建隔离工作区 | 开始新功能，需要并行开发 |
| **sw-writing-skills** | 创建和验证新 Skill | 需要创建新技能 |

---

## 🎯 快速开始

### 安装

1. 克隆仓库到 Kimi Code CLI 技能目录：

```bash
# 假设 Kimi Code CLI 技能目录为 ~/.kimi/skills/
cd ~/.kimi/skills/
git clone https://github.com/your-username/sw-superpower.git
```

2. 重启 Kimi Code CLI 或重新加载技能。

### 使用示例

当你开始一个新功能时，Agent 会自动识别并应用相应 Skill：

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

---

## 🏗️ Skill 结构

每个 Skill 是自包含的目录，遵循统一结构：

```
sw-<skill-name>/
├── SKILL.md                    # 主技能文件（必需）
├── subagent-prompts/           # 子 Agent 提示词（可选）
│   └── <name>-prompt.md
└── templates/                  # 模板文件（可选）
    └── <template>.md
```

### SKILL.md 格式

```markdown
---
name: skill-name
description: "Use when [具体触发条件]"
---

# Skill 名称

## 铁律
关键规则，不可违反

## 流程
流程图和详细步骤

## 红旗 - 立即停止
违规迹象列表

## 常见借口表
| 借口 | 现实 |
|------|------|

## 集成
前置和后续 Skill

## 输出示例
期望的输出格式
```

---

## 🔑 关键原则

### YAGNI 原则

> You Aren't Gonna Need It

- 不要添加 Spec 未要求的功能
- 不要过度设计
- 不要假设未来需求

### 子 Agent 开发原则

- 每个任务使用全新子 Agent
- 子 Agent 不应继承会话上下文
- 提供完整任务文本和上下文

### 审查原则

- **客观公正**: 基于规范，不是个人偏好
- **建设性**: 提供具体改进建议
- **优先级**: 关注严重问题

---

## 🧪 测试策略

本项目采用 TDD 方式开发 Skill：

1. **先测试，后 Skill** - 没有例外
2. **创建压力场景** - 3+ 种压力组合测试
3. **记录基线失败** - 观察无 Skill 时的失败行为
4. **编写 Skill 解决失败** - 针对观察到的失败
5. **验证合规性** - 带 Skill 重新测试
6. **关闭漏洞** - 找到新借口，添加对策

---

## 🤝 贡献指南

### 创建新 Skill

1. 使用 `sw-writing-skills` Skill 指导创建流程
2. 遵循 TDD 方式：先测试，后编写
3. 创建 3+ 压力场景测试
4. 记录基线失败行为
5. 编写 Skill 解决特定失败
6. 验证合规性，关闭漏洞

### 提交规范

```bash
# 创建新 Skill
feat: add sw-<skill-name> for <purpose>

# 更新现有 Skill
fix: resolve <issue> in sw-<skill-name>

docs: update <section> in sw-<skill-name>
```

---

## 📄 许可证

[MIT](./LICENSE)

---

## 🙏 致谢

- 基于 [Superpowers](https://github.com/anthropics/superpowers) 技能格式
- 灵感来源于成熟的软件工程实践

---

<div align="center">

**让 AI 编程更系统化、可预测、高质量** 🚀

</div>
