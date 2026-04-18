# sw-superpower - Smart Router 软件工程技能集

这是一个为 AI 编程 Agent 设计的软件工程技能（Skill）集合，采用 Superpowers 风格格式。项目提供了一套完整的软件开发工作流指导，从需求分析到代码审查，从测试驱动开发到分支管理。

## 项目结构

```
sw-superpower/
├── sw-brainstorming/              # 头脑风暴与需求分析
│   ├── SKILL.md
│   ├── subagent-prompts/
│   │   └── spec-writer-prompt.md  # Spec 编写子 Agent 提示词
│   └── templates/
│       └── spec-template.md       # Spec 文档模板
├── sw-writing-specs/              # 编写实现计划
│   └── SKILL.md
├── sw-subagent-development/       # 子 Agent 驱动开发
│   ├── SKILL.md
│   └── subagent-prompts/
│       ├── implementer-prompt.md      # 实现子 Agent 提示词
│       ├── spec-reviewer-prompt.md    # Spec 合规审查子 Agent
│       └── code-quality-reviewer-prompt.md  # 代码质量审查子 Agent
├── sw-test-driven-dev/            # 测试驱动开发
│   └── SKILL.md
├── sw-code-review/                # 代码审查
│   └── SKILL.md
├── sw-systematic-debugging/       # 系统化调试
│   └── SKILL.md
├── sw-verification-before-completion/  # 完成前验证
│   └── SKILL.md
├── sw-finishing-branch/           # 完成开发分支
│   └── SKILL.md
├── sw-using-git-worktrees/        # Git 工作区管理
│   └── SKILL.md
└── sw-writing-skills/             # 编写新技能
│   └── SKILL.md
```

## 技术栈

- **文档格式**: Markdown with YAML frontmatter
- **流程图语法**: Graphviz DOT
- **语言**: 中文（主要文档和注释）
- **风格**: Superpowers Skill 格式

## Skill 体系说明

每个 Skill 是一个自包含的目录，包含：

- **SKILL.md**: 主技能文件，定义触发条件、流程、规则和输出格式
- **subagent-prompts/**: 子 Agent 提示词（可选）
- **templates/**: 模板文件（可选）

### SKILL.md 结构

```markdown
---
name: skill-name
description: "Use when [触发条件]"
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

## 核心工作流

完整的软件开发工作流顺序：

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

## 各 Skill 功能

| Skill | 用途 | 触发条件 |
|-------|------|----------|
| sw-brainstorming | 将想法转化为完整设计和 Spec | 开始新功能开发 |
| sw-writing-specs | 创建详细的实现计划 | 设计已批准，需要执行计划 |
| sw-subagent-development | 使用子 Agent 执行计划 | 有实现计划，任务相对独立 |
| sw-test-driven-dev | 强制 RED-GREEN-REFACTOR 循环 | 实现任何功能或修复 Bug |
| sw-code-review | 两阶段代码审查 | 完成任务或功能后 |
| sw-systematic-debugging | 系统化 Bug 调查 | 发现 Bug 或测试失败 |
| sw-verification-before-completion | 标记完成前验证 | 准备标记任务完成 |
| sw-finishing-branch | 验证、决策、清理分支 | 所有任务完成 |
| sw-using-git-worktrees | 创建隔离工作区 | 开始新功能，需要并行开发 |
| sw-writing-skills | 创建和验证新 Skill | 需要创建新技能 |

## 开发规范

### 文档语言
- **主要语言**: 中文
- **代码示例**: 英文
- **注释**: 关键逻辑使用中文注释

### 代码规范
- **Python**: 遵循 PEP 8，Python >= 3.11
- **JavaScript**: ES6+ 语法
- **目录命名**: 小写字母，多单词用连字符 `-`
- **文件命名**: 小写，使用连字符

### 流程图规范
- 使用 Graphviz DOT 语法
- 节点标签使用中文
- 标签应有语义意义（避免 step1, step2）
- 不在流程图中放置代码（不可复制粘贴）

## 子 Agent 提示词

项目包含 4 个预定义的子 Agent 提示词：

1. **spec-writer-prompt.md**: Spec 编写专家，将设计决策转化为结构化文档
2. **implementer-prompt.md**: 代码实现专家，严格遵循 TDD 流程
3. **spec-reviewer-prompt.md**: Spec 合规性审查专家
4. **code-quality-reviewer-prompt.md**: 代码质量审查专家

## 测试策略

- **TDD 铁律**: 没有先失败的测试，不写生产代码
- **RED-GREEN-REFACTOR**: 强制循环
- **两阶段审查**: Spec 合规性审查优先，代码质量审查其次
- **验证清单**: 每个任务完成后必须验证

## 关键原则

### YAGNI 原则
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

## 文件路径约定

- **Spec 文件**: `dev/specs/YYYY-MM-DD--<feature-name>.md`
- **计划文件**: `dev/specs/plans/YYYY-MM-DD--<feature-name>-plan.md`
- **Skill 目录**: `sw-<skill-name>/`
- **子 Agent 提示词**: `subagent-prompts/<name>-prompt.md`

## 贡献指南

创建新 Skill 时：
1. 使用 `sw-writing-skills` Skill 指导创建流程
2. 遵循 TDD 方式：先测试，后编写
3. 创建 3+ 压力场景测试
4. 记录基线失败行为
5. 编写 Skill 解决特定失败
6. 验证合规性，关闭漏洞

## 相关资源

- **Superpowers 技能格式**: 本项目采用 Superpowers 风格的 Skill 格式
- **项目语言**: 中文（基于项目文档语言）
