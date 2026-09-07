# sw-agiledevelopment — Agent 上下文

> **这是什么仓库：** 一个为 AI Coding Agent 设计的软件研发技能框架。"源码"是 `sw-*/` 目录下的 `SKILL.md` 文件，不是一个传统应用项目。

## 编辑前必须知道的事

### 这是一个技能框架，不是应用
- 没有 `npm test`，没有构建步骤，没有传统应用入口。
- `package.json` 仅用于 OpenCode 通过 `git+` URL 安装插件。**不要**往里面添加依赖或脚本。
- `sw-*/SKILL.md` 是唯一需要人工维护的技能源码；`skills/` 是 Codex / ZCode 兼容用的符号链接目录，**始终直接编辑 `sw-*/SKILL.md`**，不要通过 `skills/` 路径修改。

### 平台适配方式
| 平台 | 入口文件 | 引导注入方式 |
|------|---------|-------------|
| OpenCode | `.opencode/plugins/sw-agiledevelopment.js` | `config` 钩子注册技能路径；`experimental.chat.messages.transform` 在第一条用户消息前注入 `sw-using-agiledevelopment/SKILL.md` |
| ZCode | `.zcode-plugin/plugin.json` | `SessionStart` 钩子（`.zcode-plugin/hooks/session-start`）读取 `skills/sw-using-agiledevelopment/SKILL.md` 并注入 |
| Codex | `.codex-plugin/plugin.json` | 插件市场安装后发现 `skills/` 目录下的技能 |
| GitHub Copilot | `.github/copilot-instructions.md` | 复制到目标项目的 `.github/`；技能详情参考 `.sw-agiledevelopment/sw-*/SKILL.md` |
| Android Studio / Tongyi Lingma | `.androidstudio/sw-agiledevelopment.md` / `.lingma/sw-agile-developer.md` | 系统提示注入 |

### 文件路径约定（按需创建）
- **Business Spec**: `docs/sw-agiledevelopment/business-specs/YYYY-MM-DD--<feature-name>.md`
- **Technical Spec**: `docs/sw-agiledevelopment/technical-specs/YYYY-MM-DD--<feature-name>.md`
- **Working-plan**: `docs/sw-agiledevelopment/plans/YYYY-MM-DD--<feature-name>-plan.md`
- **Skill**: `sw-<skill-name>/SKILL.md`
- **Subagent 提示词**: `subagent-prompts/<name>-prompt.md`

### 指令优先级
本项目的技能覆盖默认系统提示，但**用户指令始终优先**：
1. 用户的明确指令（`OPENCODE.md`、`CLAUDE.md`、`GEMINI.md`、`AGENTS.md`、直接请求）
2. sw-agiledevelopment 技能
3. 默认系统提示

编辑包含硬规则的技能（如"始终使用 TDD"）时，**不要**弱化它们。

## SKILL.md 约束（pre-push 钩子强制执行）

激活钩子（每个贡献者只需执行一次）：
```bash
ln -s ../../hooks/pre-push .git/hooks/pre-push
```

钩子检查项：
| 约束 | 详情 |
|------|------|
| **Frontmatter** | 必须以 `---` 开头，包含 `name:` 和 `description:` |
| **简单 Frontmatter** | 插件解析器只认简单 `key: value` 格式。**不要**用多行字符串、嵌套对象等复杂 YAML |
| **行数限制** | `<= 600` 行；超出的技能在同一个 `sw-*/` 目录内拆成多个 `.md` 文件（参考 `sw-writing-skills/`） |
| **红旗章节** | 必须包含 `## 红旗` 章节 |
| **常见借口表** | 必须包含常见借口表格（如 `| 想法 | 现实 |`） |
| **命名一致** | 目录名必须匹配 `sw-<skill-name>/`，且与 frontmatter 中的 `name:` 字段一致 |
| **CSO description** | `description` 字段必须符合 CSO（Claude Search Optimization）规则；pre-push 会调用 `scripts/validate-skill-descriptions.sh` |

## 添加或编辑技能
1. 创建 `sw-<name>/` 目录并放入 `SKILL.md`。
2. 包含 frontmatter、`## 红旗` 章节、常见借口表。
3. 遵循 `docs/terminology.md` 的中英文术语规范。
4. 如果超过 600 行，在同一目录内拆分（如 `SKILL.md` + `advanced.md`）。
5. 提交前运行 `git push --dry-run`，确保通过 pre-push 验证。

## 验证与安装检查脚本

这些脚本只在开发或安装验证时运行，不影响 Agent 使用 skill 后的研发速度：

```bash
bash scripts/validate-skill-descriptions.sh   # 校验所有 skill 的 description 是否符合 CSO
bash scripts/verify-opencode.sh               # 验证 OpenCode 插件结构
bash scripts/verify-zcode.sh                  # 验证 ZCode 插件结构与 SessionStart hook
bash scripts/verify-codex.sh                  # 验证 Codex 插件清单
bash scripts/verify-copilot.sh                # 验证 Copilot 指令文件
bash scripts/verify-lingma.sh                 # 验证 Lingma Agent 引导文件
bash scripts/verify-androidstudio.sh          # 验证 Android Studio 引导文件
```

## 版本号管理
`VERSION` 文件是唯一的版本来源。**不要**手动编辑 `package.json` 中的版本号：
```bash
./scripts/bump-version.sh <新版本号>
```
这会同步更新 `VERSION`、`package.json`、`docs/install-opencode.md`、`.codex-plugin/plugin.json` 和 `CHANGELOG.md`。

## 忽略的文件
- `.opencode/node_modules/`、`.opencode/package*.json` —— 插件开发依赖，不是项目源码。

## 关键参考文档
- `docs/terminology.md` —— 所有 `SKILL.md` 必须遵循的中英文术语规范
- `sw-writing-skills/SKILL.md` —— 编写新技能的元技能
- `.opencode/INSTALL.md`、`.zcode-plugin/INSTALL.md`、`.codex-plugin/INSTALL.md`、`.github/INSTALL.md` —— 各平台安装指南
