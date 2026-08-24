---
name: himice-online-office
description: 在 DeepSeek Harness 中通过 Google Workspace CLI、已安装的 DSH 插件或 MCP 操作 Drive、Docs、Sheets、Slides、Gmail 与 Calendar。
whenToUse: 用户需要在 DSH 中读取、创建或更新 Google Workspace 在线办公内容时使用。
user-invocable: true
---

# Himice Online Office — DSH

使用 [Google Workspace CLI](https://github.com/googleworkspace/cli) 或当前 profile 已安装的 Google Workspace DSH 插件/MCP。不要假定名为“Google Workspace”的插件一定存在；先检查当前环境实际暴露的工具和权限。

1. 确认账号、Workspace、目标对象和 OAuth 范围；使用精确 ID 或解析后的链接，不凭名称猜文件或日历。
2. 读取和汇总可直接执行；创建、覆盖、移动、共享、发信或改日历前确认目标和内容已获授权。
3. 保留原生 Docs/Sheets/Slides 格式；复杂本地格式编辑先导出副本，完成校验后再导入。
4. 写入后回读对象元数据和关键内容，确认修改落在正确文件、表格范围或事件。
5. 不在日志、命令参数或 Skill 中写 OAuth 密钥和敏感公司资料。
