---
name: himice-online-office
description: 在 Codex 中通过 Google Workspace CLI、MCP 或 Connector 读取和更新 Drive、Docs、Sheets、Slides、Gmail、Calendar 等在线办公内容。
---

# Himice Online Office — Codex

使用已配置的 Google Workspace MCP/Connector；缺少合适的 Connector 或需要可复现批处理时，使用 [Google Workspace CLI](https://github.com/googleworkspace/cli)。该 CLI 仓库明确标注为非正式支持的 Google 产品且仍在快速迭代，部署前固定并验证版本。

1. 先确认账号、Workspace、目标文件/日历/邮箱和可用权限。优先使用精确 ID 或已解析的链接，不凭名称猜目标。
2. 读取、检索和汇总可直接执行；创建、覆盖、移动、共享、发送邮件/消息或修改日历前，确认目标与内容已获授权。
3. 保留原生 Docs/Sheets/Slides 格式；需要高保真本地编辑时先导出副本，使用对应 Office Skill，确认后再导入或更新。
4. 写入后回读文件元数据或正文、表格区域、幻灯片数量、邮件/日历事件状态，确认变化落在正确对象。
5. 不在日志或命令行参数中暴露 OAuth 凭据、客户税号或未公开资料。
