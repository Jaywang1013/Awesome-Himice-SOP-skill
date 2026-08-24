---
name: himice-office-files
description: 在 Codex 中创建、读取、编辑和校验 Excel、Word、PowerPoint 与 PDF。用于需要 OpenAI 官方办公 Skills 与 OfficeCLI 协同、并保持公司模板格式的文件任务。
---

# Himice Office Files — Codex

按文件主格式选择 OpenAI 官方运行时 Skill：Excel 用 `spreadsheets`，Word 用 `documents`，PPT 用 `presentations`，PDF 用 `pdf`。当前上游入口为 [OpenAI Plugins](https://github.com/openai/plugins)；OfficeCLI 来源为 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI)。

1. 先检查目标 Skill 与 `officecli --version` 是否可用。缺失时说明缺项并按上游安装，不得伪装已执行。
2. 创建或复杂改写优先使用对应官方 Skill；已有 Office 文件的结构查看、精准编辑、公式/版式校验和渲染可用 OfficeCLI 补充。
3. 始终保留原文件，输出新副本。除非用户明确要求，不改变公式、数字格式、数据验证、母版、分页、合并单元格、批注或字体。
4. 交付前重新打开或渲染文件，检查公式错误、内容溢出、分页、字体替换和关键金额；PDF 还要检查页面完整性与可检索文本。
5. MarkItDown 只能用于内容提取，不能代替需要保持格式的 Office 编辑。
