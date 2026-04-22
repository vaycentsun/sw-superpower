# 基于条件的等待

## 概述

不稳定的测试通常用任意延迟猜测时序。这创造了竞态条件——测试在快机器上通过，但在负载下或 CI 中失败。

**核心原则：** 等待你关心的实际条件，不是猜测它花多长时间。

## 何时使用

```dot
digraph when_to_use {
    "测试使用 setTimeout/sleep？" [shape=diamond];
    "测试时序行为？" [shape=diamond];
    "记录 WHY 需要超时" [shape=box];
    "使用基于条件的等待" [shape=box];

    "测试使用 setTimeout/sleep？" -> "测试时序行为？" [label="是"];
    "测试使用 setTimeout/sleep？" -> "使用基于条件的等待" [label="否"];
    "测试时序行为？" -> "记录 WHY 需要超时" [label="是"];
    "测试时序行为？" -> "使用基于条件的等待" [label="否"];
}
```

**使用时机：**
- 测试有任意延迟（`setTimeout`、`sleep`、`time.sleep()`）
- 测试不稳定（有时通过，负载下失败）
- 并行运行时测试超时
- 等待异步操作完成

**不要使用：**
- 测试实际时序行为（防抖、节流间隔）
- 如果使用任意超时，始终记录 WHY

## 核心模式

```typescript
// ❌ 之前：猜测时序
await new Promise(r => setTimeout(r, 50));
const result = getResult();
expect(result).toBeDefined();

// ✅ 之后：等待条件
await waitFor(() => getResult() !== undefined);
const result = getResult();
expect(result).toBeDefined();
```

## 快速模式

| 场景 | 模式 |
|----------|---------|
| 等待事件 | `waitFor(() => events.find(e => e.type === 'DONE'))` |
| 等待状态 | `waitFor(() => machine.state === 'ready')` |
| 等待计数 | `waitFor(() => items.length >= 5)` |
| 等待文件 | `waitFor(() => fs.existsSync(path))` |
| 复杂条件 | `waitFor(() => obj.ready && obj.value > 10)` |

## 实现

通用轮询函数：
```typescript
async function waitFor<T>(
  condition: () => T | undefined | null | false,
  description: string,
  timeoutMs = 5000
): Promise<T> {
  const startTime = Date.now();

  while (true) {
    const result = condition();
    if (result) return result;

    if (Date.now() - startTime > timeoutMs) {
      throw new Error(`等待 ${description} 超时，已 ${timeoutMs}ms`);
    }

    await new Promise(r => setTimeout(r, 10)); // 每 10ms 轮询
  }
}
```

参见本目录中的 `condition-based-waiting-example.ts` 获取完整实现，包括来自实际调试会话的领域特定辅助函数（`waitForEvent`、`waitForEventCount`、`waitForEventMatch`）。

## 常见错误

**❌ 轮询太快：** `setTimeout(check, 1)` - 浪费 CPU
**✅ 修复：** 每 10ms 轮询

**❌ 无超时：** 如果条件永远不满足则无限循环
**✅ 修复：** 始终包含带清晰错误的超时

**❌ 数据陈旧：** 在循环前缓存状态
**✅ 修复：** 在循环内调用 getter 以获取新鲜数据

## 何时任意超时是正确的

```typescript
// 工具每 100ms 滴答一次——需要 2 次滴答来验证部分输出
await waitForEvent(manager, 'TOOL_STARTED'); // 首先：等待条件
await new Promise(r => setTimeout(r, 200));   // 然后：等待时序行为
// 200ms = 100ms 间隔的 2 次滴答——有记录和理由
```

**要求：**
1. 首先等待触发条件
2. 基于已知时序（不是猜测）
3. 注释解释 WHY

## 实际影响

来自调试会话 (2025-10-03)：
- 修复了 3 个文件中 15 个不稳定测试
- 通过率：60% → 100%
- 执行时间：快 40%
- 不再竞态条件
