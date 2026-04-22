---
name: sw-executing-plans
description: "Use when you have a written implementation plan to execute in a separate session with review checkpoints"
---

# 执行计划

## 概述

加载计划，批判性审查，执行所有任务，完成后报告。

**开始时声明：** "我正在使用执行计划技能来实现此计划。"

**注意：** 告诉你的用户，如果有子 Agent 支持，Superpowers 的工作效果会更好。如果运行在支持子 Agent 的平台上（如 Claude Code 或 Codex），质量会显著提高。如果子 Agent 可用，请使用 `sw-subagent-development` 替代此技能。

## 流程

### 步骤 1：加载并审查计划
1. 读取计划文件
2. 批判性审查——识别关于计划的任何问题或顾虑
3. 如果有顾虑：在开始前提出来与用户讨论
4. 如果没有顾虑：创建 TodoWrite 并继续

### 步骤 2：执行任务

对每个任务：
1. 标记为 in_progress
2. 精确遵循每个步骤（计划包含小粒度步骤）
3. 按指定运行验证
4. 标记为 completed

### 步骤 3：完成开发

所有任务完成并验证后：
- 声明："我正在使用 `sw-finishing-branch` 技能来完成此工作。"
- **必需子技能：** 使用 `sw-finishing-branch`
- 遵循该技能验证测试、呈现选项、执行选择

## 何时停止并寻求帮助

**立即停止执行当：**
- 遇到阻塞（缺少依赖、测试失败、指令不清）
- 计划有严重缺口导致无法开始
- 你不理解某个指令
- 验证反复失败

**请求澄清，不要猜测。**

## 何时回顾早期步骤

**返回审查（步骤 1）当：**
- 用户根据你的反馈更新计划
- 根本方法需要重新思考

**不要强行突破阻塞** — 停下来询问。

## 记住
- 先批判性审查计划
- 精确遵循计划步骤
- 不要跳过验证
- 计划要求时引用技能
- 遇到阻塞时停止，不要猜测
- 未经用户明确同意，绝不在 main/master 分支上开始实现

## 集成

**必需工作流技能：**
- **sw-using-git-worktrees** - 必需：开始前设置隔离工作区
- **sw-writing-specs** - 创建此技能执行的计划
- **sw-finishing-branch** - 所有任务完成后完成开发
