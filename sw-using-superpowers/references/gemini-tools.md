# Gemini CLI 工具映射

Skills 使用 Claude Code 工具名称。遇到这些时，使用你的平台等效项：

| Skill 引用 | Gemini CLI 等效项 |
|-----------|------------------|
| `Read`（文件读取） | `read_file` |
| `Write`（文件创建） | `write_file` |
| `Edit`（文件编辑） | `replace` |
| `Bash`（运行命令） | `run_shell_command` |
| `Grep`（搜索文件内容） | `grep_search` |
| `Glob`（按名称搜索文件） | `glob` |
| `TodoWrite`（任务跟踪） | `write_todos` |
| `Skill` 工具（调用技能） | `activate_skill` |
| `WebSearch` | `google_web_search` |
| `WebFetch` | `web_fetch` |
| `Task` 工具（分派子 Agent） | 无等效项 — Gemini CLI 不支持子 Agent

## 无子 Agent 支持

Gemini CLI 没有 Claude Code `Task` 工具的等效项。依赖子 Agent 分派的 Skills（`subagent-driven-development`、`dispatching-parallel-agents`）将回退到通过 `executing-plans` 的单会话执行。

## 其他 Gemini CLI 工具

这些工具在 Gemini CLI 中可用，但没有 Claude Code 等效项：

| 工具 | 用途 |
|------|------|
| `list_directory` | 列出文件和子目录 |
| `save_memory` | 将事实持久化到 GEMINI.md 跨会话 |
| `ask_user` | 向用户请求结构化输入 |
| `tracker_create_task` | 丰富的任务管理（创建、更新、列出、可视化） |
| `enter_plan_mode` / `exit_plan_mode` | 在做出更改之前切换到只读研究模式 |
