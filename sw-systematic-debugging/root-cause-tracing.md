# 根本原因追踪

## 概述

Bug 通常在调用栈深处显现（错误的目录中 git init、错误的文件位置、错误的路径打开数据库）。你的本能是在错误出现的地方修复，但那是治疗症状。

**核心原则：** 向后追踪调用链直到找到原始触发器，然后在源头修复。

## 何时使用

```dot
digraph when_to_use {
    "Bug 出现在栈深处？" [shape=diamond];
    "能向后追踪吗？" [shape=diamond];
    "在症状点修复" [shape=box];
    "追踪到原始触发器" [shape=box];
    "更好：也添加纵深防御" [shape=box];

    "Bug 出现在栈深处？" -> "能向后追踪吗？" [label="是"];
    "能向后追踪吗？" -> "追踪到原始触发器" [label="是"];
    "能向后追踪吗？" -> "在症状点修复" [label="否 - 死胡同"];
    "追踪到原始触发器" -> "更好：也添加纵深防御";
}
```

**使用时机：**
- 错误发生在执行深处（不在入口点）
- 堆栈跟踪显示长调用链
- 不清楚无效数据 originate 于哪里
- 需要找到哪个测试/代码触发问题

## 追踪流程

### 1. 观察症状
```
错误：git init 在 /Users/jesse/project/packages/core 中失败
```

### 2. 找到直接原因
**什么代码直接导致这个？**
```typescript
await execFileAsync('git', ['init'], { cwd: projectDir });
```

### 3. 问：什么调用了这个？
```typescript
WorktreeManager.createSessionWorktree(projectDir, sessionId)
  → 由 Session.initializeWorkspace() 调用
  → 由 Session.create() 调用
  → 由 Project.create() 处的测试调用
```

### 4. 继续向上追踪
**传递了什么值？**
- `projectDir = ''`（空字符串！）
- 空字符串作为 `cwd` 解析为 `process.cwd()`
- 那是源代码目录！

### 5. 找到原始触发器
**空字符串来自哪里？**
```typescript
const context = setupCoreTest(); // 返回 { tempDir: '' }
Project.create('name', context.tempDir); // 在 beforeEach 之前访问！
```

## 添加堆栈跟踪

当你无法手动追踪时，添加仪器：

```typescript
// 在问题操作之前
async function gitInit(directory: string) {
  const stack = new Error().stack;
  console.error('DEBUG git init:', {
    directory,
    cwd: process.cwd(),
    nodeEnv: process.env.NODE_ENV,
    stack,
  });

  await execFileAsync('git', ['init'], { cwd: directory });
}
```

**关键：** 在测试中使用 `console.error()`（不是 logger——可能不显示）

**运行并捕获：**
```bash
npm test 2>&1 | grep 'DEBUG git init'
```

**分析堆栈跟踪：**
- 查找测试文件名
- 找到触发调用的行号
- 识别模式（相同的测试？相同的参数？）

## 查找哪个测试导致污染

如果某物在测试期间出现但不知道哪个测试：

使用本目录中的二分脚本 `find-polluter.sh`：

```bash
./find-polluter.sh '.git' 'src/**/*.test.ts'
```

逐个运行测试，在第一个污染者处停止。参见脚本了解用法。

## 真实示例：空的 projectDir

**症状：** `.git` 在 `packages/core/` 中创建（源代码）

**追踪链：**
1. `git init` 在 `process.cwd()` 中运行 ← 空的 cwd 参数
2. WorktreeManager 被传入空的 projectDir 调用
3. Session.create() 被传入空字符串
4. 测试在 beforeEach 之前访问了 `context.tempDir`
5. setupCoreTest() 初始返回 `{ tempDir: '' }`

**根本原因：** 顶层变量初始化访问空值

**修复：** 让 tempDir 成为 getter，如果在 beforeEach 之前访问则抛出

**还添加了纵深防御：**
- 第 1 层：Project.create() 验证目录
- 第 2 层：WorkspaceManager 验证不为空
- 第 3 层：NODE_ENV 守卫拒绝在 tmpdir 外 git init
- 第 4 层：git init 前的堆栈跟踪日志

## 关键原则

```dot
digraph principle {
    "找到直接原因" [shape=ellipse];
    "能向上追踪一层吗？" [shape=diamond];
    "向后追踪" [shape=box];
    "这是源头吗？" [shape=diamond];
    "在源头修复" [shape=box];
    "在每一层添加验证" [shape=box];
    "Bug 不可能" [shape=doublecircle];
    "绝不只修复症状" [shape=octagon, style=filled, fillcolor=red, fontcolor=white];

    "找到直接原因" -> "能向上追踪一层吗？";
    "能向上追踪一层吗？" -> "向后追踪" [label="是"];
    "能向上追踪一层吗？" -> "绝不只修复症状" [label="否"];
    "向后追踪" -> "这是源头吗？";
    "这是源头吗？" -> "向后追踪" [label="否 - 继续"];
    "这是源头吗？" -> "在源头修复" [label="是"];
    "在源头修复" -> "在每一层添加验证";
    "在每一层添加验证" -> "Bug 不可能";
}
```

**绝不在错误出现的地方只修复。** 向后追踪找到原始触发器。

## 堆栈跟踪技巧

**在测试中：** 使用 `console.error()` 而不是 logger——logger 可能被抑制
**在操作前：** 在危险操作前记录，不是等它失败后
**包含上下文：** 目录、cwd、环境变量、时间戳
**捕获堆栈：** `new Error().stack` 显示完整调用链

## 实际影响

来自调试会话 (2025-10-03)：
- 通过 5 层追踪找到根本原因
- 在源头修复（getter 验证）
- 添加 4 层防御
- 1847 个测试通过，零污染
