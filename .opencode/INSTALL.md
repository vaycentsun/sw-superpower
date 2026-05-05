# 安装 sw-superpower（OpenCode 版）

## 前置条件

- 已安装 [OpenCode.ai](https://opencode.ai)

## 安装前的环境清理

若之前安装过旧版的sw-superpower，请先清理旧配置：

```bash
# 删除该插件的旧缓存
rm -rf ~/.cache/opencode/packages/sw-superpower@git+http
# 移除克隆的仓库
rm -rf ~/.config/opencode/superpowers
```

然后按照上方的安装步骤重新配置。

## 安装方式

在 `opencode.json`（全局或项目级）的 `plugin` 数组中添加：

```json
{
  "plugin": ["sw-superpower@git+https://github.com/vaycentsun/sw-superpower.git"]
}
```

重启 OpenCode。插件会自动通过 Bun 安装并注册所有技能。

**验证安装**：询问 Agent "Tell me about your sw-superpowers"

## 使用方法

使用 OpenCode 原生的 `skill` 工具：

```
使用 skill 工具列出所有技能
使用 skill 工具加载 sw-brainstorming
```

## 故障排除

### 插件未加载

1. 检查日志：`opencode run --print-logs "hello" 2>&1 | grep -i sw-superpowers`
2. 验证 `opencode.json` 中的插件配置是否正确
3. 确保 OpenCode 版本足够新

### 技能未找到

1. 使用 `skill` 工具列出已发现的技能
2. 检查插件是否已加载（参见上文）
3. 每个技能需要包含有效的 YAML frontmatter 的 `SKILL.md` 文件
