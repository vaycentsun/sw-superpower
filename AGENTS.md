# sw-superpower - Agent 行为指导

> 本文档供 AI Agent 阅读。人类用户请参见 [README.md](README.md) 和 [docs/install-opencode.md](docs/install-opencode.md)。

## 指令优先级

Superpowers 技能覆盖默认系统提示行为，但**用户指令始终优先**：

1. **用户的明确指令**（CLAUDE.md、GEMINI.md、AGENTS.md、直接请求）—— 最高优先级
2. **Superpowers 技能** —— 在与默认系统行为冲突时覆盖
3. **默认系统提示** —— 最低优先级

如果 AGENTS.md 说"不要用 TDD"而某个技能说"始终用 TDD"，遵循用户的指令。用户拥有控制权。

## 文件路径约定

- **Spec 文件**: `dev/specs/YYYY-MM-DD--<feature-name>-design.md`
- **计划文件**: `dev/specs/plans/YYYY-MM-DD--<feature-name>-plan.md`
- **Skill 目录**: `sw-<skill-name>/`
- **子 Agent 提示词**: `subagent-prompts/<name>-prompt.md`

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

## 说服原则（用于技能设计）

基于研究的七种说服原则（参见 `sw-writing-skills/persuasion-principles.md`）：

1. **权威** - 使用命令式语言（"必须"、"绝不"）
2. **承诺** - 要求宣布使用、强制明确选择
3. **稀缺** - 时间限制要求、顺序依赖
4. **社会认同** - 通用模式、失败模式
5. **团结** - 协作语言、共享目标
6. **互惠** - 谨慎使用
7. **喜好** - 避免用于纪律执行

## 相关资源

- **项目介绍**: [README.md](README.md)
- **OpenCode 安装指南**: [docs/install-opencode.md](docs/install-opencode.md)
- **Superpowers 技能格式**: [obra/superpowers](https://github.com/obra/superpowers)
- **许可证**: MIT
