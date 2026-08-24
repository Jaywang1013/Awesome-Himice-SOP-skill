# Anthropic Document Skills

官方仓库：[anthropics/skills](https://github.com/anthropics/skills)

四个官方文档 Skill：

- [DOCX](https://github.com/anthropics/skills/tree/main/skills/docx)
- [PDF](https://github.com/anthropics/skills/tree/main/skills/pdf)
- [PPTX](https://github.com/anthropics/skills/tree/main/skills/pptx)
- [XLSX](https://github.com/anthropics/skills/tree/main/skills/xlsx)

Anthropic 官方说明：这些 document creation & editing skills 是 Claude 文档能力使用的实现，属于 **source-available，并非 open source**。本项目不复制、不修改、不再发布上游文件，只挂官方入口并在 `claude-code/skills/himice-office-files` 中进行 Himice 工作流编排。使用前应阅读各目录的 `LICENSE.txt`。

在 Claude Code 中按官方方式安装：

```text
/plugin marketplace add anthropics/skills
/plugin install document-skills@anthropic-agent-skills
```

安装后可直接让 Claude 使用 PDF、DOCX、PPTX 或 XLSX Skill；涉及公司模板时，再叠加本仓库的 `/himice-office-files` 规则与 OfficeCLI 校验。
