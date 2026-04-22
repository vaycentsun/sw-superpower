# 为 OpenCode 安装 sw-superpower

## 前提条件

- 已安装 [OpenCode.ai](https://opencode.ai)

## 安装

在你的 `opencode.json`（全局或项目级别）的 `plugin` 数组中添加 sw-superpower：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/your-username/sw-superpower.git"]
}
```

> **注意**：将 `your-username` 替换为实际仓库所有者。如果你是本地使用，可以直接克隆仓库并 symlink 到 OpenCode 插件目录。

重启 OpenCode。插件会自动安装并注册所有技能。

通过询问验证："告诉我你的 superpowers"

## 手动安装（无插件市场时）

如果你无法通过 `plugin` 字段安装，可以手动 clone：

```bash
# Clone 到 OpenCode 配置目录
git clone https://github.com/your-username/sw-superpower.git \
  ~/.config/opencode/plugins/sw-superpower

# 创建插件入口 symlink
ln -s ~/.config/opencode/plugins/sw-superpower/.opencode/plugins/superpowers.js \
  ~/.config/opencode/plugins/superpowers.js
```

然后在 `opencode.json` 中添加技能路径：

```json
{
  "skills": {
    "paths": ["~/.config/opencode/plugins/sw-superpower"]
  }
}
```

## 从旧的基于 symlink 的安装迁移

如果你之前使用 `git clone` 和 symlink 安装 superpowers，移除旧设置：

```bash
# 移除旧 symlink
rm -f ~/.config/opencode/plugins/superpowers.js
rm -rf ~/.config/opencode/skills/superpowers

# 可选：移除克隆的仓库
rm -rf ~/.config/opencode/superpowers

# 如果从 opencode.json 添加了 skills.paths，移除它
```

然后按照上面的安装步骤操作。

## 用法

使用 OpenCode 的原生 `skill` 工具：

```
use skill tool to list skills
use skill tool to load sw-brainstorming
```

## 更新

重启 OpenCode 时 sw-superpower 自动更新（如使用 plugin 字段）。

要固定特定版本：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/your-username/sw-superpower.git#v1.0.0"]
}
```

## 故障排除

### 插件未加载

1. 检查日志：`opencode run --print-logs "hello" 2>&1 | grep -i sw-superpower`
2. 验证 `opencode.json` 中的插件行
3. 确保你运行的是较新版本的 OpenCode

### 找不到技能

1. 使用 `skill` 工具列出已发现的内容
2. 检查插件是否正在加载（见上文）
3. 确认 `sw-*/SKILL.md` 文件存在

### 工具映射

当技能引用 Claude Code 工具时：
- `TodoWrite` → `todowrite`
- `Task` 带子 Agent → OpenCode 子 Agent 系统（`@mention` 语法）
- `Skill` 工具 → OpenCode 的原生 `skill` 工具
- 文件操作 → 你的原生工具

## 获取帮助

- 报告问题：https://github.com/your-username/sw-superpower/issues
- 原版项目：https://github.com/obra/superpowers
