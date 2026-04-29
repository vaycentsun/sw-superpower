# 安装 sw-superpower（OpenCode 版）

## 前置条件

- 已安装 [OpenCode.ai](https://opencode.ai)

## 安装

在 `opencode.json`（全局或项目级）的 `plugin` 数组中添加：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/vaycentsun/sw-superpower.git"]
}
```

重启 OpenCode。插件会自动通过 Bun 安装并注册所有技能。

**验证安装**：询问 Agent "Tell me about your sw-superpowers"

## 从旧版符号链接安装迁移

如果你之前使用 `git clone` 和符号链接的方式安装过 sw-superpower，请先清理旧配置：

```bash
# 移除旧符号链接
rm -f ~/.config/opencode/plugins/sw-superpowers.js
rm -rf ~/.config/opencode/skills/sw-superpowers

# 可选：移除克隆的仓库
rm -rf ~/.config/opencode/superpowers

# 如果在 opencode.json 中配置了 skills.paths，请一并移除与 superpowers 相关的条目
```

然后按照上方的安装步骤重新配置。

## 使用方法

使用 OpenCode 原生的 `skill` 工具：

```
使用 skill 工具列出所有技能
使用 skill 工具加载 sw-brainstorming
```

## 更新

使用插件方式安装时，sw-superpower 会在重启 OpenCode 时自动更新。

如需固定到特定版本：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/vaycentsun/sw-superpower.git#v1.0.0"]
}
```

## 故障排除

### 插件未加载

1. 检查日志：`opencode run --print-logs "hello" 2>&1 | grep -i superpowers`
2. 验证 `opencode.json` 中的插件配置是否正确
3. 确保 OpenCode 版本足够新

### 技能未找到

1. 使用 `skill` 工具列出已发现的技能
2. 检查插件是否已加载（参见上文）
3. 每个技能需要包含有效的 YAML frontmatter 的 `SKILL.md` 文件

### 工具映射

sw-superpower 的 Skill 使用 Claude Code 工具名称。在 OpenCode 中，自动映射为以下等效工具：

| Claude Code 工具 | OpenCode 等效项 |
|-----------------|----------------|
| `TodoWrite` | `todowrite` |
| `Task` 工具配子 Agent | OpenCode 子 Agent 系统（`@mention`） |
| `Skill` 工具 | OpenCode 原生 `skill` 工具 |
| 文件操作（Read/Write/Edit） | 你的原生工具 |

## 获取帮助

- 提交 Issue：https://github.com/vaycentsun/sw-superpower/issues
- 完整文档：https://github.com/vaycentsun/sw-superpower/blob/main/docs/install-opencode.md
