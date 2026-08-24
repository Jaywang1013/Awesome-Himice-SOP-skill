---
name: himice-online-office
description: 在 Claude Code 中通过 Google Workspace CLI 或已配置 MCP 操作 Drive、Docs、Sheets、Slides、Gmail 和 Calendar 在线办公内容。
---

# Himice Online Office — Claude Code

优先使用当前环境已授权的 Google Workspace MCP；缺少适合的 MCP 或需要可复现批处理时使用 [Google Workspace CLI](https://github.com/googleworkspace/cli)。先验证 CLI/MCP、账号和 OAuth 范围。

1. 使用精确 ID 或解析后的链接定位文件、日历和邮件对象，不凭名称猜测。
2. 读取与汇总可直接执行；创建、覆盖、移动、共享、发信或修改日历前确认目标和内容已获授权。
3. 保留原生 Docs/Sheets/Slides 格式；复杂高保真编辑可导出副本，使用对应 document Skill 校验后再导入。
4. 写入后回读元数据及关键内容，确认变化落在正确对象。
5. 不在命令、日志或 Skill 中暴露 OAuth 凭据和敏感公司资料。
