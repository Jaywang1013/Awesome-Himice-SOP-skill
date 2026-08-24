---
name: himice-enterprise-knowledge
description: 在 DeepSeek Harness 中通过已配置 MCP 检索、汇总和维护 Notion、Google Drive、SharePoint 等企业知识源。
whenToUse: 用户需要查找公司制度、项目资料、模板、历史决策或跨知识库汇总时使用。
user-invocable: true
---

# Himice Enterprise Knowledge — DSH

只使用当前 DSH profile 已配置并获授权的 MCP Server。先列出实际可用的 Notion、Drive、SharePoint 或其他知识库工具，不因用户提到某系统就假定连接存在。

1. 确认问题范围、部门/项目、时间和允许检索的知识源；使用数据库、站点、文件夹或项目标识缩小范围。
2. 读取标题、路径/URL、所有者、更新时间和正文后再总结；同名文件保留版本差异。
3. 跨来源结论标明系统和文档，冲突时列出来源日期并标待确认；不得把推断写成公司制度。
4. 创建、覆盖、移动、共享或改权限前确认目标和授权；写入后回读验证。
5. 只返回当前用户有权访问的内容，不把客户资料复制到更宽权限的知识库。
