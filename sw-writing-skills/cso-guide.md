# Claude Search Optimization (CSO) 指南

> 编写让 Agent 能够发现、理解和正确使用的 Skill 描述和元数据。

## 1. 描述 ≠ 工作流摘要

```yaml
# ❌ 错误：描述中总结了工作流程
description: Use when executing plans - dispatches subagent per task with code review between tasks

# ❌ 错误：包含过多流程细节
description: Use for TDD - write test first, watch it fail, write minimal code, refactor

# ✅ 正确：只描述触发条件，无工作流摘要
description: Use when executing implementation plans with independent tasks in the current session

# ✅ 正确：只描述触发条件
description: Use when implementing any feature or bugfix, before writing implementation code
```

**为什么重要：** 描述总结了工作流程时，Agent 可能只读描述而不读完整 Skill，导致行为错误。一个说"任务间代码审查"的描述会让 Agent 只做一次审查，即使 Skill 的流程图明确显示需要两次审查（先 Spec 合规，后代码质量）。

**陷阱：** 描述中总结工作流会创造一条捷径，Agent 会走这条捷径。Skill 正文变成了 Agent 跳过的文档。

**好的描述内容：**
- 以 "Use when..." 开头，聚焦触发条件
- 使用具体触发、症状和情境
- 描述*问题*（race conditions、不一致行为）而非*语言特定症状*（setTimeout、sleep）
- 保持技术中立，除非 Skill 本身是技术特定的
- 使用第三人称（注入系统提示）
- **绝不**总结 Skill 的流程或工作流

```yaml
# ❌ 错误：太抽象，未说明何时使用
description: For async testing

# ❌ 错误：第一人称
description: I can help you with async tests when they're flaky

# ❌ 错误：提到技术但 Skill 不特定于它
description: Use when tests use setTimeout/sleep and are flaky

# ✅ 正确：以 "Use when" 开头，描述问题，无工作流
description: Use when tests have race conditions, timing dependencies, or pass/fail inconsistently

# ✅ 正确：技术特定 Skill，触发条件明确
description: Use when using React Router and handling authentication redirects
```

## 2. 关键词覆盖

使用 Agent 会搜索的词汇：
- **错误消息**: "Hook timed out", "ENOTEMPTY", "race condition"
- **症状**: "flaky", "hanging", "zombie", "pollution"
- **同义词**: "timeout/hang/freeze", "cleanup/teardown/afterEach"
- **工具**: 实际命令、库名称、文件类型

## 3. 命名规范

**使用主动语态，动词开头：**
- ✅ `creating-skills` 而非 `skill-creation`
- ✅ `condition-based-waiting` 而非 `async-test-helpers`

**以行为或核心洞察命名：**
- ✅ `condition-based-waiting` > `async-test-helpers`
- ✅ `using-skills` 而非 `skill-usage`
- ✅ `flatten-with-flags` > `data-structure-refactoring`
- ✅ `root-cause-tracing` > `debugging-techniques`

**动名词（-ing）适合流程：**
- `creating-skills`, `testing-skills`, `debugging-with-logs`
- 主动，描述你正在进行的动作

## 4. Token 效率（关键）

**问题：** 入门和频繁引用的 Skill 会加载到每个会话中。每个 token 都重要。

**目标字数：**
- 入门工作流：每个 < 150 词
- 频繁加载的 Skill：总共 < 200 词
- 其他 Skill：< 500 词（仍然要简洁）

**技巧：**

**将细节移到工具帮助：**
```bash
# ❌ 错误：在 SKILL.md 中记录所有参数
search-conversations 支持 --text, --both, --after DATE, --before DATE, --limit N

# ✅ 正确：引用 --help
search-conversations 支持多种模式和过滤器。运行 --help 查看详情。
```

**使用交叉引用：**
```markdown
# ❌ 错误：重复工作流细节
当搜索时，分派子 Agent 使用模板...
[20 行重复指令]

# ✅ 正确：引用其他 Skill
始终使用子 Agent（节省 50-100x 上下文）。**必需：** 使用 [other-skill-name] 处理工作流。
```

**压缩示例：**
```markdown
# ❌ 错误：冗长示例（42 词）
用户: "我们之前在 React Router 中如何处理认证错误？"
你: 我将搜索过去的对话，查找 React Router 认证模式。
[分派子 Agent，搜索查询: "React Router authentication error handling 401"]

# ✅ 正确：最小示例（20 词）
用户: "我们之前在 React Router 中如何处理认证错误？"
你: 搜索中...
[分派子 Agent → 合成]
```

**消除冗余：**
- 不要重复交叉引用 Skill 中已有的内容
- 不要解释命令本身已经明显的内容
- 不要包含同一模式的多个示例

**验证：**
```bash
wc -w sw-writing-skills/SKILL.md
# 入门工作流：目标 < 150 词
# 其他频繁加载：目标 < 200 词
```

## 5. 描述字段快速检查清单

编写 description 时逐项检查：

- [ ] 以 "Use when..." 开头
- [ ] 描述触发条件和症状（不是工作流）
- [ ] 使用第三人称
- [ ] 包含关键词（错误消息、症状、工具名）
- [ ] 技术中立（除非 Skill 本身技术特定）
- [ ] 长度 < 500 字符（理想 < 200）
- [ ] 不包含流程、步骤或工作流摘要

## 6. 常见描述错误

| 错误类型 | 示例 | 修复 |
|---------|------|------|
| 总结工作流 | `Use when executing plans - dispatches subagent per task...` | `Use when executing implementation plans with independent tasks` |
| 太抽象 | `For async testing` | `Use when tests have race conditions or pass/fail inconsistently` |
| 第一人称 | `I can help you with async tests` | `Use when tests are flaky or have timing dependencies` |
| 技术症状 | `Use when tests use setTimeout/sleep` | `Use when tests have timing dependencies` |
| 太冗长 | > 500 字符 | 压缩到触发条件 |

## 7. YAML Frontmatter 要求

SKILL.md frontmatter 需要两个字段：
- `name`（最多 64 个字符）：人类可读名称
- `description`（最多 1024 个字符）：使用时机和触发条件

```yaml
---
name: skill-name-with-hyphens
description: "Use when [specific triggering conditions and symptoms]"
---
```
