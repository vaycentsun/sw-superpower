---
name: sw-finishing-branch
description: "Use when all development tasks in dev/ directory are complete and ready to merge, PR, keep, or discard the branch"
---

# Finishing Branch - 完成开发分支

所有任务完成后，验证、决策并清理开发分支。

## 核心原则

**完成 = 验证 + 决策 + 清理**

- 验证所有测试通过
- 呈现选项（合并/PR/保留/丢弃）
- 清理工作区

## 何时使用

```dot
digraph when_to_use {
  rankdir=TB;
  
  all_tasks [label="所有任务完成？", shape=diamond];
  tests_pass [label="所有测试通过？", shape=diamond];
  finish [label="sw-finishing-branch", shape=box];
  fix_tests [label="修复测试", shape=box];
  more_tasks [label="继续任务", shape=box];
  
  all_tasks -> tests_pass [label="是"];
  all_tasks -> more_tasks [label="否"];
  tests_pass -> finish [label="是"];
  tests_pass -> fix_tests [label="否"];
  fix_tests -> tests_pass;
}
```

## 完成流程

```dot
digraph finish_process {
  rankdir=TB;
  
  start [label="开始", shape=ellipse];
  verify_tests [label="1. 验证所有测试\n运行完整测试套件", shape=box];
  tests_ok [label="测试通过？", shape=diamond];
  fix_tests [label="修复失败的测试", shape=box];
  final_review [label="2. 最终代码审查\n(可选子 Agent)", shape=box];
  present_options [label="3. 呈现完成选项", shape=box];
  user_choice [label="用户选择", shape=diamond];
  merge [label="4a. 合并到 main", shape=box];
  create_pr [label="4b. 创建 PR", shape=box];
  keep [label="4c. 保留分支", shape=box];
  discard [label="4d. 丢弃分支", shape=box];
  cleanup [label="5. 清理工作区\n(如使用 git worktree)", shape=box];
  update_spec [label="6. 更新 Spec 状态", shape=box];
  done [label="完成", shape=ellipse];
  
  start -> verify_tests;
  verify_tests -> tests_ok;
  tests_ok -> fix_tests [label="否"];
  fix_tests -> verify_tests;
  tests_ok -> final_review [label="是"];
  final_review -> present_options;
  present_options -> user_choice;
  user_choice -> merge [label="合并"];
  user_choice -> create_pr [label="PR"];
  user_choice -> keep [label="保留"];
  user_choice -> discard [label="丢弃"];
  merge -> cleanup;
  create_pr -> cleanup;
  keep -> cleanup;
  discard -> cleanup;
  cleanup -> update_spec;
  update_spec -> done;
}
```

## 详细步骤

### 1. 验证所有测试

**运行完整测试套件**：

```bash
# Python
python -m pytest -v

# JavaScript
npm test

# 所有项目
make test  # 如果有
```

**验证要求**：
- [ ] 所有测试通过
- [ ] 无错误输出
- [ ] 无警告（或警告已记录并合理解释）
- [ ] 测试覆盖率符合项目要求

**如果测试失败**：
- 修复失败的测试
- 重新运行测试套件
- 重复直到全部通过

### 2. 最终代码审查（可选）

**分派最终审查子 Agent**：

```markdown
请审查整个实现：
- 对比原始 Spec 验证完整性
- 检查代码一致性
- 验证文档更新
- 确认无遗留问题
```

**审查检查清单**：
- [ ] 所有需求已实现
- [ ] 代码风格一致
- [ ] 文档已更新
- [ ] 无 TODO/FIXME 遗留
- [ ] 无调试代码

### 3. 呈现完成选项

向用户展示选项：

> ## 开发分支完成
> 
> **分支**: `feature/user-auth`
> **提交**: `abc1234`
> **测试状态**: ✅ 全部通过 (42/42)
> 
> ### 变更摘要
> - 新增文件: 8
> - 修改文件: 3
> - 删除文件: 0
> - 代码行数: +450/-120
> 
> ### 完成选项
> 
> **A) 合并到 main** [推荐]
> - 直接合并分支到 main
> - 删除开发分支
> - 清理工作区
> 
> **B) 创建 Pull Request**
> - 推送分支到远程
> - 创建 PR 供审查
> - 保留工作区等待合并
> 
> **C) 保留分支**
> - 保留分支和开发环境
> - 用于后续迭代
> 
> **D) 丢弃分支**
> - 删除分支和工作区
> - 保留代码变更（如有需要）
> 
> 请选择 (A/B/C/D)：

### 4. 执行用户选择

#### 选项 A: 合并到 main

```bash
# 切换到 main
git checkout main

# 合并分支
git merge feature/user-auth --no-ff -m "feat: user authentication

- Add User model with password hashing
- Implement login/logout functionality
- Add session management
- Add comprehensive tests

Closes #123"

# 推送
git push origin main

# 删除本地分支
git branch -d feature/user-auth

# 删除远程分支（如有）
git push origin --delete feature/user-auth
```

#### 选项 B: 创建 Pull Request

```bash
# 推送分支到远程
git push -u origin feature/user-auth

# 生成 PR 描述
```

**PR 描述模板**：
```markdown
## 描述
实现用户认证功能

## 变更
- 添加 User 模型
- 实现登录/登出
- 添加会话管理
- 添加测试

## 测试
- [x] 所有测试通过
- [x] 新增测试覆盖新功能

## Spec
关联: `dev/specs/2026-04-08--user-auth.md`

## 审查清单
- [x] 代码遵循项目规范
- [x] 测试覆盖充分
- [x] 文档已更新
```

#### 选项 C: 保留分支

```bash
# 推送分支到远程（确保备份）
git push -u origin feature/user-auth

# 保留本地分支和工作区
```

告知用户：
> 分支已保留。当前在 `feature/user-auth` 分支。
> 如需继续开发，可直接在此分支工作。

#### 选项 D: 丢弃分支

```bash
# 切换到 main
git checkout main

# 删除本地分支
git branch -D feature/user-auth

# 删除远程分支（如有）
git push origin --delete feature/user-auth
```

**注意**：如果用户想要保留代码但丢弃分支，先创建补丁：
```bash
git diff main..feature/user-auth > feature.patch
git checkout main
git branch -D feature/user-auth
```

### 5. 清理工作区

**如果使用 git worktree**：

```bash
# 切换到 main worktree
cd /path/to/main/worktree

# 移除 worktree
git worktree remove /path/to/feature-worktree

# 清理 worktree 记录
git worktree prune
```

**清理检查清单**：
- [ ] worktree 目录已删除
- [ ] 无孤立进程
- [ ] 磁盘空间已释放

### 6. 更新 Spec 状态

**更新 Spec 文件**：

```yaml
# 在 dev/specs/YYYY-MM-DD--feature.md 中

status: implemented  # 或 merged

implementation:
  # ... 原有内容
  
completion:
  completed_at: 2026-04-08
  completed_by: coder
  merge_commit: abc1234
  branch: feature/user-auth
  action: merged  # merged | pr | kept | discarded
```

**归档 Spec**：
```bash
# 如果项目有归档流程
git mv dev/specs/active/YYYY-MM-DD--feature.md dev/specs/archived/
git commit -m "docs: archive completed spec"
```

## 验证清单

完成前确认：

- [ ] 所有测试通过
- [ ] 无错误输出
- [ ] 用户已选择完成选项
- [ ] 选择已执行（合并/PR/保留/丢弃）
- [ ] 工作区已清理（如使用 worktree）
- [ ] Spec 状态已更新
- [ ] 更改已提交/推送

## 输出示例

### 合并完成

```markdown
## 开发分支完成 - 已合并

**分支**: `feature/user-auth`
**操作**: 合并到 main
**合并提交**: `abc1234`
**时间**: 2026-04-08 14:30

### 变更统计
- 新增: 8 文件
- 修改: 3 文件
- 删除: 0 文件
- +450/-120 行

### 后续步骤
1. ✅ 分支已删除
2. ✅ Worktree 已清理
3. ✅ Spec 已归档
4. 🔄 CI/CD 正在运行 (https://ci.example.com/build/123)

### 相关资源
- Spec: `dev/specs/archived/2026-04-08--user-auth.md`
- 提交: `abc1234`
```

### PR 创建完成

```markdown
## 开发分支完成 - PR 已创建

**分支**: `feature/user-auth`
**操作**: 创建 Pull Request
**PR**: #45 (https://github.com/username/repo/pull/45)

### PR 状态
- 状态: 🟡 等待审查
- 审查者: (待分配)
- CI: 🟢 通过

### 后续步骤
1. 分配审查者
2. 等待审查反馈
3. 根据反馈修改
4. 合并到 main

### 保留资源
- Worktree: `/path/to/worktrees/feature-user-auth/`
- Spec: `dev/specs/active/2026-04-08--user-auth.md`
```

## 集成

**前置 Skill**: 
- sw-subagent-development（完成所有任务）
- sw-code-review（最终审查）

**后续**: 无（工作流终点）

**相关 Skill**:
- sw-using-git-worktrees - 如果使用了 worktree

## 红旗 - 阻止完成

| 想法 | 现实 |
|------|------|
| "测试大部分通过了，可以完成" | 测试未通过 = 不应完成。所有测试必须通过 |
| "严重 bug 先记录，以后修复" | 严重 bug 未修复 = 不应完成。合并严重 bug = 污染 main |
| "用户大概想合并" | 用户未明确选择 = 不应完成。必须确认用户意图 |
| "文档可以以后更新" | 未完成文档更新 = 不应完成。文档是交付的一部分 |
| "worktree 以后清理" | 未清理工作区 = 不应完成。清理是完成的组成部分 |

## 常见借口表

| 借口 | 现实 |
|------|------|
| "就剩一个测试失败，先完成" | 一个失败测试可能隐藏严重问题。所有测试必须通过 |
| "用户忙，我先合并" | 未经用户明确确认的合并可能违背用户意图 |
| "文档不重要，代码才重要" | 文档是维护和理解代码的基础。不完整的文档 = 不完整的功能 |
| "worktree 不占多少空间" | 未清理的 worktree 积累会导致混乱和资源浪费 |
| "以后修 bug 比现在更快" | 已知 bug 合并到 main 后修复成本更高 |

## 最佳实践

1. **总是运行完整测试** - 不只是修改的测试
2. **明确用户意图** - 确认用户想要合并/PR/保留/丢弃
3. **备份重要工作** - 推送分支到远程再删除本地
4. **更新文档** - 完成时更新 Spec 和 README
5. **清理彻底** - 不遗留 worktree 或临时文件
