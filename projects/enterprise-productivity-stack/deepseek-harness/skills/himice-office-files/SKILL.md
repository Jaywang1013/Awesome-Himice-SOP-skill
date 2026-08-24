---
name: himice-office-files
description: 在 DeepSeek Harness 中使用已配置的 Univer Office 集成与 OfficeCLI 创建、读取、编辑和校验 Excel、Word、PPT 与 PDF 文件。
whenToUse: 用户需要在 DSH 中处理办公文件、保持公司模板、公式或版式时使用。
user-invocable: true
---

# Himice Office Files — DSH

先确认 DSH 当前 profile 是否安装了 Univer Office 相关集成，以及 `officecli --version` 是否可用。[Univer](https://github.com/dream-num/univer) 是办公编辑框架，不应把未安装的 DSH 集成描述为内置插件；OfficeCLI 来源为 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI)。

1. 表格、文档和演示的在线可视编辑可走已配置的 Univer 能力；本地 Office 文件结构读取、精准修改、公式/格式验证和渲染优先 OfficeCLI。
2. PDF 阅读可配合 DSH 附件能力或 MarkItDown；需要创建/修改 PDF 时使用实际已安装的 PDF 工具，不能把 Markdown 当作高保真 PDF。
3. 保留原文件并输出副本；除非用户明确要求，不改变公式、数字格式、数据验证、母版、分页、合并单元格或字体。
4. 完成后重新打开或渲染，检查公式错误、内容溢出、页面裁切、字体替换和关键金额。
5. 工具未安装或版本不兼容时停止编辑并给出真实安装状态。
