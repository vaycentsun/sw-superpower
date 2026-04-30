---
name: sw-writing-specs
description: "Use when creating detailed implementation plan for the project with bite-sized tasks after design is approved"
---

# Writing Specs - 编写实现计划

将批准的设计转化为详细的实现计划，包含可执行的小任务（每个 2-5 分钟）。

## 检查清单

- [ ] **入口门控** — 确认 Spec 文件存在且设计已获明确批准
- [ ] **读取 Spec** — 理解设计概述、组件接口、数据流、验收标准
- [ ] **提取组件** — 列出需要创建/修改的文件和函数/类接口
- [ ] **识别任务类型** — 创建、修改、测试、配置、文档
- [ ] **拆解为小任务** — 每个任务 2-5 分钟，成对安排实现+测试任务
- [ ] **排序任务** — 按依赖关系排序，基础优先，测试紧随
- [ ] **编写详细计划** — 每个任务包含确切文件路径、完整代码、验证步骤
- [ ] **自检（第一层）** — 调用 `plan-document-reviewer` 子 Agent 扫描完整性、Spec 对齐、任务分解、可构建性
- [ ] **自检（第二层）** — 验收标准覆盖检查、粒度、明确性、可验证性、顺序合理、无遗漏
- [ ] **用户审查门控** — 获得明确批准（✅）后才继续；如遇根本性异议则回退到 `sw-brainstorming`
- [ ] **保存计划** — 保存到 `docs/sw-superpower/plans/`，询问用户后提交 Git
- [ ] **调用 sw-subagent-development** — 交接计划文件路径和依赖摘要

## 核心原则

**每个任务必须包含：**
- 确切的文件路径
- 完整的代码（或代码结构）
- 验证步骤

**任务大小：** 每个任务应该能在 2-5 分钟内完成。

**TDD 集成：** 每个实现任务后必须紧跟对应的测试任务。测试验证必须包含 RED（先失败）→ GREEN（实现后通过）。

**铁律：在用户明确批准计划之前，严禁：**
- 调用 `sw-subagent-development` 开始实现
- 跳过两层自检中的任一层
- 忽略入口门控直接读取 Spec
- 以任何理由绕过用户审查门控

## 何时使用

```dot
digraph when_to_use {
  rankdir=TB;
  
  design_approved [label="设计已批准？", shape=diamond];
  has_spec [label="有书面 Spec？", shape=diamond];
  write_specs [label="sw-writing-specs", shape=box];
  need_design [label="先执行 sw-brainstorming", shape=box];
  
  design_approved -> has_spec [label="是"];
  design_approved -> need_design [label="否"];
  has_spec -> write_specs [label="是"];
  has_spec -> need_design [label="否"];
}
```

## 流程

```dot
digraph process {
  rankdir=TB;

  start [label="开始", shape=ellipse];
  gate [label="0. 入口门控\nSpec 存在？设计批准？", shape=diamond];
  need_design [label="返回\nsw-brainstorming", shape=box];
  read_spec [label="1. 读取 Spec 文件", shape=box];
  extract_components [label="2. 提取组件和接口", shape=box];
  identify_tasks [label="3. 识别实现任务", shape=box];
  break_down [label="4. 拆解为小任务\n(2-5 分钟每个)", shape=box];
  order_tasks [label="5. 排序任务\n(依赖关系)", shape=box];
  write_plan [label="6. 编写详细计划", shape=box];
  layer1_review [label="7a. 第一层自检\nplan-document-reviewer 子 Agent", shape=box];
  layer1_fix [label="修复问题", shape=box];
  layer2_review [label="7b. 第二层自检\n验收标准覆盖检查", shape=box];
  layer2_fix [label="修复问题", shape=box];
  user_review [label="8. 用户审查？", shape=diamond];
  user_fix [label="修改计划", shape=box];
  save_plan [label="9. 保存计划\n用户确认后提交 Git", shape=box];
  invoke_subagent [label="10. 调用 sw-subagent-development", shape=doublecircle];

  start -> gate;
  gate -> need_design [label="否"];
  gate -> read_spec [label="是"];
  read_spec -> extract_components;
  extract_components -> identify_tasks;
  identify_tasks -> break_down;
  break_down -> order_tasks;
  order_tasks -> write_plan;
  write_plan -> layer1_review;
  layer1_review -> layer1_fix [label="发现问题"];
  layer1_fix -> layer1_review;
  layer1_review -> layer2_review [label="通过"];
  layer2_review -> layer2_fix [label="发现问题"];
  layer2_fix -> layer1_review [label="修改后重跑第一层"];
  layer2_review -> user_review [label="两层通过"];
  user_review -> user_fix [label="需要修改"];
  user_fix -> layer1_review [label="修改后重跑两层自检"];
  user_review -> save_plan [label="批准"];
  save_plan -> invoke_subagent;
}
```

## 详细步骤

### 0. 入口门控

在开始前检查：
1. **Spec 文件存在性**：`docs/sw-superpower/specs/YYYY-MM-DD--<feature>.md` 是否存在？
2. **设计已批准**：该 Spec 是否已通过 `sw-brainstorming` 的用户审查门控？

如果任一检查失败：
- **Spec 不存在** → 告知用户："未找到 Spec 文件。请先执行 sw-brainstorming 完成设计阶段。"
- **设计未明确批准** → 告知用户："设计尚未获得明确批准。请返回 sw-brainstorming 完成审查流程。"
- **两者都通过** → 继续执行第 1 步

### 1. 读取 Spec 文件

读取 `docs/sw-superpower/specs/YYYY-MM-DD--<feature>.md` 文件，理解：
- 设计概述
- 组件和接口
- 数据流
- 验收标准

### 2. 提取组件和接口

从 Spec 中提取：
- 需要创建/修改的文件
- 函数/类接口定义
- 依赖关系
- **验收标准清单** — 列出所有验收标准，作为后续覆盖检查的基准

### 3. 识别实现任务

基于组件识别任务类型：
- **创建文件** - 新模块、类、函数
- **修改文件** - 添加功能、修复 bug
- **编写测试** - 单元测试、集成测试
- **配置变更** - 配置文件、环境变量
- **文档更新** - README、注释

### 4. 拆解为小任务

**任务大小标准：** 每个任务 2-5 分钟

**TDD 成对要求：** 每个实现任务后必须紧跟对应的测试任务，不允许累积多个实现后再统一测试。

**拆解原则：**
```
❌ 大任务: "实现用户认证模块"
✅ 小任务（成对出现）:
  - 创建 User 模型类（实现）
  - 编写 User 模型测试（测试）← 依赖上一任务
  - 实现密码哈希函数（实现）
  - 编写密码哈希测试（测试）← 依赖上一任务
```

### 5. 排序任务

**成对排序原则：** 实现任务和对应的测试任务必须相邻，中间不得插入其他实现任务。

按依赖关系排序：
1. **基础优先** - 被依赖的组件先实现
2. **测试紧随** - 每个实现任务后必须紧跟其测试任务
3. **集成在后** - 组件完成后再集成

**错误排序示例**（禁止）：
```
1. 创建数据模型
2. 实现业务逻辑  ← 错误：未先测试数据模型
3. 编写模型测试
```

**正确排序示例**：
```
1. 创建数据模型
2. 编写模型测试
3. 实现业务逻辑
4. 编写业务逻辑测试
5. 实现 API 接口
6. 编写 API 测试
7. 集成所有组件
```

### 6. 编写详细计划

每个任务必须包含：

```markdown
### 任务 N: <任务名称>

**目标**: <一句话描述>

**文件**: `<确切文件路径>`

**操作**:
```python
# 完整代码或代码结构
class User:
    def __init__(self, username: str, password: str):
        self.username = username
        self.password_hash = self._hash_password(password)
```

**验证**:
- [ ] <验证步骤 1>
- [ ] <验证步骤 2>

**依赖**: <依赖的前置任务编号>
```

**任务配对示例**：
```
任务 1: 创建 User 模型类（实现）
任务 2: 编写 User 模型测试（测试）← 依赖任务 1
任务 3: 实现登录函数（实现）
任务 4: 编写登录函数测试（测试）← 依赖任务 3
```

### 7. 自检

自检分为两层，必须依次完成。

**第一层：结构化审查（子 Agent）**
启动 `plan-document-reviewer` 子 Agent（见 `plan-document-reviewer-prompt.md`），对计划进行自动化扫描：
- 完整性：TODO、占位符、不完整的任务、缺失的步骤
- Spec 对齐：计划覆盖 Spec 需求，无重大范围蔓延
- 任务分解：任务有清晰的边界，步骤可执行
- 可构建性：工程师能遵循此计划而不卡住

子 Agent 发现的问题必须修复后才能进入第二层。

**第二层：业务逻辑自检（Agent）**
完成计划后检查：
1. **验收标准覆盖** - 每个 Spec 中的验收标准是否都有对应的验证任务？
2. **粒度** - 每个任务 2-5 分钟
3. **明确性** - 每个任务有确切文件路径
4. **可验证** - 每个任务有验证步骤
5. **顺序合理** - 依赖关系正确
6. **无遗漏** - 测试任务包含在内

**闭环**：如果第二层发现问题并对计划进行了修改，必须**重新运行第一层**（子 Agent 审查），确保修改没有引入新的占位符、矛盾或歧义。

两层都通过后，才进入用户审查门控。

### 8. 用户审查门控

两层自检都通过后，展示计划给用户：

> "实现计划已编写完成。计划包含 N 个任务：
> - 任务 1-3: 数据模型和测试
> - 任务 4-6: 业务逻辑和测试
> - 任务 7-9: API 和集成测试
> 
> 预计总时间：X 分钟。
> 
> 请审查计划，如有调整请告知。"

**批准判定标准**：
- ✅ **明确批准**（任一算批准）："LGTM"、"批准"、"继续"、"没问题"、"可以进入实现"、"Go ahead"
- ❓ **模糊回应**（如"先这样吧"、"看看再说"、"差不多"、"OK"、"嗯"）：**必须追问** — "请明确确认这个计划可以进入实现阶段吗？"
- ❓ **不确定**：如果你不确定用户的回复是否算批准 — **直接问用户** — "请问您是批准这个计划进入实现阶段，还是需要修改？"
- ❌ **修改请求**：回到计划修改，重新运行两层自检 + 用户审查循环。

**根本性异议回退**：如果用户对计划方向有**根本性异议**（如"这个方案完全不行"、"Spec 本身有问题"、"需要重新设计"），不要在本计划中反复修改。立即回退到：
- **Spec 缺陷** → 回到 `sw-brainstorming`，重新审查或修改 Spec
- **设计方向错误** → 回到 `sw-brainstorming`，重新提出方案

**铁律**：只有收到明确的 ✅ 批准信号后才继续。

### 9. 保存计划

保存到 `docs/sw-superpower/plans/YYYY-MM-DD--<feature>-plan.md`

**Git 提交**：询问用户确认后再提交：
> "计划文件已保存到 `docs/sw-superpower/plans/YYYY-MM-DD--<feature>-plan.md`。是否需要我将其提交到 Git？"

只有用户明确同意后才执行 `git add` 和 `git commit`。

### 10. 进入实现阶段

**唯一出口**：调用 `sw-subagent-development` Skill 执行计划。

**交接内容**：
- 计划文件路径：`docs/sw-superpower/plans/YYYY-MM-DD--<feature>-plan.md`
- Spec 文件路径：`docs/sw-superpower/specs/YYYY-MM-DD--<feature>.md`
- 任务总数和依赖关系摘要

**大规模计划**：如果任务数 > 20，建议分批调用子 Agent（每批 5-10 个无依赖或同层依赖的任务），避免单个子 Agent 上下文溢出。

**失败回退**：如果子 Agent 执行失败（如任务卡住、上下文不足），回到第 6 步（编写详细计划）重新调整任务粒度或分批策略，重新运行两层自检后再次交接。

## 任务模板

### 创建文件任务

```markdown
### 任务 N: 创建 <文件名>

**目标**: 创建 <文件描述>

**文件**: `<文件路径>`

**内容**:
```<语言>
<完整代码>
```

**验证**:
- [ ] 文件存在
- [ ] 语法正确
- [ ] 可导入/执行
```

### 修改文件任务

```markdown
### 任务 N: 在 <文件名> 中添加 <功能>

**目标**: <具体修改内容>

**文件**: `<文件路径>`

**修改**:
```<语言>
# 现有代码（上下文）：包含函数签名或类定义，至少 3 行上下文

# 新增代码
<完整新增代码>

# 现有代码（上下文）：至少 3 行后续代码，帮助子 Agent 定位
```

**上下文规范**：
- 必须包含目标函数/类的完整签名（def/class 行）
- 修改点前后至少提供 3 行现有代码
- 如涉及多行修改，标注行号或锚点注释（如 `# 在第 42 行后插入`）

**验证**:
- [ ] 修改符合预期
- [ ] 不破坏现有功能
```

### 编写测试任务

```markdown
### 任务 N: 编写 <功能> 的测试

**目标**: 为 <功能> 编写单元测试

**文件**: `<测试文件路径>`

**测试用例**:
```python
def test_<场景>():
    """<测试描述>"""
    # Arrange
    <准备代码>
    
    # Act
    <执行代码>
    
    # Assert
    <验证代码>
```

**验证**:
- [ ] 测试可运行
- [ ] 测试先失败（RED）
- [ ] 实现后通过（GREEN）
```

## 红旗 - 停止并修正

| 想法 | 现实 |
|------|------|
| "这个任务 15 分钟也能做完" | 任务过大（> 10 分钟）= 需要拆分。大任务难以估计和验证 |
| "验证步骤可以省略" | 缺少验证步骤 = 不知道任务是否完成。每个任务必须有验证 |
| "文件路径到时候再确定" | 文件路径不明确 = 实现者迷失。必须指定确切路径 |
| "依赖关系差不多就行" | 依赖关系错误 = 阻塞或冲突。必须正确排序 |
| "测试任务后面再加" | 遗漏测试任务 = 未验证的代码。测试必须包含在计划中 |
| "任务顺序无所谓" | 任务顺序不合理 = 实现阻塞。必须按依赖关系排序 |
| "跳过第一层子 Agent 审查" | 子 Agent 捕获 TODO/占位符/不可执行任务。跳过 = 有缺陷的计划 |
| "跳过验收标准覆盖检查" | 验收标准没对应验证任务 = Spec 目标无法验证。必须逐条对照 |
| "修改计划后不重新运行第一层" | 修改可能引入新的占位符或矛盾。重跑第一层是铁律 |
| "设计没批准就开始写计划" | 未经批准的设计可能方向错误。先确认入口门控 |
| "计划文件直接提交 Git" | AGENTS.md 要求用户确认后才提交。询问是强制步骤 |

## 常见借口表

| 借口 | 现实 |
|------|------|
| "任务拆分太细太繁琐" | 细粒度任务提高可预测性和可验证性。大任务容易遗漏步骤 |
| "验证步骤到时候再想" | 没有验证步骤 = 无法确认任务完成。计划时必须定义 |
| "文件路径实现时再定" | 模糊的文件路径导致实现者做不必要的决策 |
| "测试可以单独一个阶段" | 测试紧随实现是 TDD 原则。分离测试 = 可能跳过 |
| "依赖关系很复杂，简化一下" | 错误的依赖关系导致实现阻塞。复杂依赖需要仔细分析 |
| "入口门控太麻烦，直接读 Spec" | 没有 Spec 或设计未批准就写计划 = 方向错误 + 浪费轮次。门控不可跳过 |
| "两层自检浪费时间，做一层就够了" | 第一层捕获结构缺陷（TODO/占位符），第二层捕获逻辑缺陷（验收标准遗漏）。只做一个 = 有漏洞 |
| "用户会同意提交的，不用问" | AGENTS.md 强制要求用户确认后才提交。假设用户同意 = 违规 |
| "TDD 只是建议，实现完再补测试也行" | 测试后置 = 测试被跳过或质量差。计划中必须实现+测试成对出现 |

## YAGNI 原则

计划中只包含 Spec 明确要求的内容：
- 不要添加 Spec 未要求的功能
- 不要过度设计
- 不要假设未来需求

## 示例

### 输入 Spec（简化）

```markdown
## 用户认证

### 组件
- User 类：username, password_hash
- 登录函数：验证用户名密码

### 接口
```python
class User:
    def __init__(self, username: str, password: str)
    def verify_password(self, password: str) -> bool

def login(username: str, password: str) -> User | None
```
```

### 输出实现计划

```markdown
## 用户认证实现计划

### 任务 1: 创建 User 模型类

**目标**: 创建 User 类，包含用户名和密码哈希
**文件**: `dev/auth/models.py`
**内容**: `class User` 含 `__init__`, `_hash_password`, `verify_password`
**验证**: 文件可导入 / User 类可实例化 / 密码哈希正确生成

### 任务 2: 编写 User 模型测试 ← 依赖任务 1

**目标**: 为 User 类编写单元测试
**文件**: `dev/auth/test_models.py`
**内容**: `test_user_creation`, `test_password_verification_success`, `test_password_verification_failure`
**验证**: 测试可运行 / 先失败（RED）/ 实现后通过（GREEN）

### 任务 3: 实现登录函数 ← 依赖任务 1

**目标**: 实现登录验证逻辑
**文件**: `dev/auth/service.py`
**内容**: `def login` 调用 `get_user_from_db`，验证密码后返回 User 或 None
**验证**: 函数可调用 / 正确用户返回 User / 错误密码返回 None

### 任务 4: 编写登录函数测试 ← 依赖任务 3

**目标**: 为登录函数编写测试
**文件**: `dev/auth/test_service.py`
**内容**: `test_login_success`, `test_login_wrong_password`, `test_login_user_not_found`（mock 数据库）
**验证**: 所有场景覆盖 / 先失败（RED）/ 实现后通过（GREEN）
```

## 集成

**前置 Skill**: sw-brainstorming（提供批准的 Spec）

**后续 Skill**: sw-subagent-development（执行计划）

**相关 Skill**:
- sw-test-driven-dev - 确保每个任务遵循 TDD

## 输出示例

**计划文件**: `docs/sw-superpower/plans/2026-04-08--auth-plan.md`

**返回摘要格式**：
```markdown
## 实现计划完成

**计划文件**: `docs/sw-superpower/plans/2026-04-08--auth-plan.md`
**任务数**: 8
**预计时间**: 40 分钟

### 任务概览
| 编号 | 任务 | 文件 | 依赖 |
|------|------|------|------|
| 1 | 创建 User 模型 | `dev/auth/models.py` | - |
| 2 | 编写模型测试 | `dev/auth/test_models.py` | 1 |
| 3 | 实现登录函数 | `dev/auth/service.py` | 1 |
| 4 | 编写登录测试 | `dev/auth/test_service.py` | 3 |

**下一步**: 调用 sw-subagent-development 执行计划
```
