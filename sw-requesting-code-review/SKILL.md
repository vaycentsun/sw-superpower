---
name: sw-requesting-code-review
description: "Use when completing tasks, implementing major features, or before merging to verify work meets requirements"
---

# 请求代码审查

分派 `sw-code-review` 子 Agent 在问题级联之前捕获问题。审查者获得精心设计的评估上下文——绝不是你的会话历史。这让审查者专注于工作产品，而不是你的思维过程，也为你保留了继续工作的上下文。

**核心原则：** 尽早审查，频繁审查。

## 何时请求审查

**强制：**
- 子 Agent 驱动开发中每个任务后
- 完成主要功能后
- 合并到 main 之前

**可选但 valuable：**
- 卡住时（新视角）
- 重构前（基线检查）
- 修复复杂 Bug 后

## 如何请求

**1. 获取 git SHAs：**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # 或 origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. 分派代码审查者子 Agent：**

使用 Task 工具配合 `sw-code-review` 类型，填写 `./code-reviewer.md` 模板

**占位符：**
- `{WHAT_WAS_IMPLEMENTED}` - 你刚刚构建了什么
- `{PLAN_OR_REQUIREMENTS}` - 它应该做什么
- `{BASE_SHA}` - 起始提交
- `{HEAD_SHA}` - 结束提交
- `{DESCRIPTION}` - 简要摘要

**3. 根据反馈行动：**
- 立即修复关键问题
- 继续前修复重要问题
- 记录次要问题稍后处理
- 如果审查者错了，反驳（附推理）

## 示例

```
[刚刚完成任务 2：添加验证函数]

你：让我在继续前请求代码审查。

BASE_SHA=$(git log --oneline | grep "任务 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[分派 sw-code-review 子 Agent]
  WHAT_WAS_IMPLEMENTED: 对话索引的验证和修复函数
  PLAN_OR_REQUIREMENTS: docs/superpowers/plans/deployment-plan.md 中的任务 2
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: 添加了 verifyIndex() 和 repairIndex()，支持 4 种问题类型

[子 Agent 返回]：
  优点：清晰的架构，真实的测试
  问题：
    重要：缺少进度指示器
    次要：魔法数字 (100) 用于报告间隔
  评估：可以继续

你：[修复进度指示器]
[继续任务 3]
```

## 与工作流集成

**子 Agent 驱动开发：**
- 每个任务后审查
- 在问题复合前捕获
- 进入下一个任务前修复

**执行计划：**
- 每批（3 个任务）后审查
- 获取反馈，应用，继续

**临时开发：**
- 合并前审查
- 卡住时审查

## 红旗 - 停止并审查

| 想法 | 现实 |
|------|------|
| "这个很简单，不需要审查" | 简单代码也有盲点。10 分钟审查可能节省数小时调试 |
| "审查者错了，忽略" | 用技术推理反驳，不是忽略。有效反馈可能来自误解 |
| "先继续，稍后修复" | 问题会复合。进入下一任务前修复 |
| "自审就够了" | 自审有盲点。独立审查发现不同问题 |
| " deadline 紧，没空审查" | 未审查的代码会让 deadline 更紧 |

## 常见借口表

| 借口 | 现实 |
|------|------|
| "审查浪费时间" | 10 分钟审查可能节省数小时调试 |
| "我已经自审过了" | 自审有盲点，独立审查发现不同问题 |
| "审查者不懂这个领域" | 外部视角常发现领域专家遗漏的问题 |
| " deadline 紧，没空审查" | 未审查的代码 deadline 后会成为技术债务 |
| "合并前再审查也行" | 问题在代码库中停留越久，修复成本越高 |

参见模板：`./code-reviewer.md`
