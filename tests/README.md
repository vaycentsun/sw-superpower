# 测试套件

> 为 sw-superpower 项目设计的测试套件，适配 OpenCode 平台。

## 测试目录结构

```
tests/
├── README.md                          # 本文档
├── opencode/                          # OpenCode 平台测试
│   ├── run-tests.sh                   # 主测试运行器
│   ├── test-plugin-loading.sh         # 插件结构和文件验证
│   ├── test-skill-structure.sh        # Skill 文件结构验证
│   └── test-tool-mapping.sh           # 工具映射完整性验证
└── skill-triggering/                  # 技能触发场景测试
    ├── run-test.sh                    # 触发测试框架
    └── prompts/                       # 测试提示词
        ├── brainstorming.txt
        ├── test-driven-development.txt
        ├── systematic-debugging.txt
        └── ...
```

## 运行测试

### 基础测试（无需 OpenCode）

```bash
cd tests/opencode
bash run-tests.sh
```

### 指定测试

```bash
bash run-tests.sh -t test-skill-structure.sh
```

### 详细输出

```bash
bash run-tests.sh -v
```

## 测试类型

### 1. 插件加载测试 (`test-plugin-loading.sh`)

验证：
- `.opencode/plugins/sw-superpowers.js` 插件文件存在
- 插件能正确扫描 skills 目录
- 所有 Skill 目录结构符合规范

### 2. Skill 结构测试 (`test-skill-structure.sh`)

验证：
- 所有 `SKILL.md` 文件包含 YAML frontmatter
- `name` 和 `description` 字段存在
- 文件使用正确的命名规范
- 无文件超过 600 行（主 SKILL.md）
- 所有 Skill 都有 Red Flags 和常见借口表

### 3. 工具映射测试 (`test-tool-mapping.sh`)

验证：
- `sw-using-superpowers/references/` 目录存在
- 工具映射文件完整（copilot-tools.md、codex-tools.md、gemini-tools.md）
- OpenCode 工具映射包含所有常用工具

### 4. 技能触发测试 (`skill-triggering/`)

定义自然语言提示词场景，验证 Agent 是否能正确触发对应 Skill。

> **注意**：技能触发测试需要 OpenCode 环境实际运行 Agent。在没有 OpenCode 时，可以手动审查提示词和期望触发结果。

## 添加新测试

1. 在 `tests/opencode/` 创建新的 `test-*.sh` 脚本
2. 脚本返回 0 表示通过，非 0 表示失败
3. 添加到 `run-tests.sh` 的 `tests` 数组中

## 测试哲学

- **快速**：基础测试应在 10 秒内完成
- **独立**：每个测试可单独运行
- **清晰**：失败时提供明确的错误信息
- **覆盖**：结构、内容、映射三方面验证
