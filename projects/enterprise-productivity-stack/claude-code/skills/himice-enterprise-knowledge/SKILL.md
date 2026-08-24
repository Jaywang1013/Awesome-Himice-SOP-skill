---
name: himice-enterprise-knowledge
description: 在 Claude Code 中通过已配置的 Notion 与 Google Drive MCP 检索、汇总和维护企业制度、项目资料、模板和历史决策。
---

# Himice Enterprise Knowledge — Claude Code

使用当前环境实际配置并获授权的 Notion、Google Drive MCP；如果用户要求其他知识库，仅在对应 MCP 已安装时使用。

1. 确认问题范围、部门/项目、时间和允许检索的知识源；使用数据库、文件夹或项目标识缩小范围。
2. 读取标题、路径/URL、所有者、更新时间和正文后再总结；同名文件保留版本差异。
3. 跨来源结论标明 Notion 或 Drive 文档；冲突时列出来源日期并标待确认，不把推断写成公司制度。
4. 创建、覆盖、移动、共享或修改权限前确认目标和授权；写入后回读验证。
5. 只返回用户有权访问的内容，不把客户资料复制到权限更宽的知识库。
