> 本文件是 `sw-verification-before-completion/SKILL.md` 的补充文档。请先阅读主文件了解完整执行流程。

## 验证设计方法论

检查清单告诉你**验证什么**，本节告诉你**如何设计验证**。

### 无测试框架的遗留代码

没有自动化测试 ≠ 不能验证：

```bash
# 1. 最小验证实验：输入 → 执行 → 断言
python -c "
from mymodule import process
result = process('test_input')
assert result == 'expected_output', f'期望 expected_output，实际 {result}'
print('验证通过')
"

# 2. 边界值快速验证
python -c "from mymodule import process; print(repr(process('')))"    # 空输入
python -c "from mymodule import process; print(repr(process(None)))"  # None
python -c "from mymodule import process; print(repr(process('a'*10000)))"  # 大数据
```

**原则**：设计最小可重复的验证实验，记录输入、输出和预期。

### 验证"未改变"（重构后）

重构的核心风险是行为漂移。验证策略：

1. **关键用例对比** - 重构前后运行相同输入，对比输出是否一致
2. **性能基准** - 如有性能要求，对比关键路径耗时
3. **接口契约** - 验证公开接口的输入输出契约未变
4. **日志/副作用** - 确认副作用行为一致（如文件写入、API 调用次数）

```bash
# 重构前后对比示例
python -c "from old_module import func; print(func('key_case'))" > old_output.txt
python -c "from new_module import func; print(func('key_case'))" > new_output.txt
diff old_output.txt new_output.txt
```

### 覆盖率 ≠ 行为覆盖

高覆盖率不保证需求被覆盖。额外检查：

- [ ] 每个验收标准都有至少一个验证点
- [ ] 测试的断言验证了有意义的行为，而非只是"运行不报错"
- [ ] 边界条件和错误路径有明确断言
- [ ] 测试名称描述了行为，而非实现细节

### 验收标准映射

将 Spec 中的验收标准转化为可验证的断言：

| 验收标准 | 验证方式 | 示例断言 |
|----------|---------|---------|
| "用户可以注册账号" | 端到端测试 | `assert register('user', 'pass') == success` |
| "密码最少 8 位" | 边界测试 | `assert register('u', 'short') == error('密码至少 8 位')` |
| "注册后发送邮件" | 集成测试 | `assert email_queue.has_job('welcome', 'user@example.com')` |

**原则**：每个"应该..."的陈述都必须能找到对应的验证证据。

## 常见验证陷阱

| 陷阱 | 问题 | 正确做法 |
|------|------|---------|
| **只测成功路径** | 遗漏错误处理 | 测试失败场景 |
| **用生产数据测试** | 风险高 | 使用测试数据 |
| **只在开发环境测试** | 环境问题 | 在目标环境测试 |
| **依赖手动验证** | 不可重复 | 自动化验证 |
| **验证后修改代码** | 引入新 bug | 修改后重新验证 |
| **重复验证同一项** | 误以为覆盖全面，实际遗漏其他 | 逐条确认，不重复计数 |
| **验证环境漂移** | 开发环境特殊配置导致结果不可复现 | 记录环境，干净环境复测 |
| **证据选择性记录** | 失败的"快速修好了"不记录，失去追溯 | 全部记录，无论结果 |
| **测试数据污染** | 上次验证残留数据影响本次结果 | 验证前重置数据 |
