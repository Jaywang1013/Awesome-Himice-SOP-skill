---
name: himice-office-files
description: 在 Claude Code 中使用 Anthropic 官方 document-skills 与 OfficeCLI 创建、读取、编辑和校验 DOCX、XLSX、PPTX 与 PDF，并保持 Himice 公司模板。
---

# Himice Office Files — Claude Code

先确认已按 [Anthropic Agent Skills](https://github.com/anthropics/skills) 官方方式安装 `document-skills`。四个上游入口为 [DOCX](https://github.com/anthropics/skills/tree/main/skills/docx)、[PDF](https://github.com/anthropics/skills/tree/main/skills/pdf)、[PPTX](https://github.com/anthropics/skills/tree/main/skills/pptx) 和 [XLSX](https://github.com/anthropics/skills/tree/main/skills/xlsx)。它们是 source-available、并非开源；遵守各目录 `LICENSE.txt`，不要复制或再发布上游代码。

1. 按主文件格式调用对应 Anthropic Skill；需要本地 Office 文件结构查看、精准修改、公式/格式验证或渲染时结合 [OfficeCLI](https://github.com/iOfficeAI/OfficeCLI)。
2. 工具不可用时报告实际缺项，不用 Markdown 或纯文本伪造高保真文件编辑。
3. 保留原文件并输出副本；除非用户明确要求，不改变公式、数字格式、数据验证、母版、分页、合并单元格、批注或字体。
4. 交付前重新打开或渲染，检查公式错误、内容溢出、页面裁切、字体替换、关键金额和 PDF 可检索性。
5. 公司模板、客户资料和附件只在获授权环境处理。
