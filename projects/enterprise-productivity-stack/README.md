# Himice Enterprise Productivity Stack

面向 Himice 同事的跨 Agent 企业办公能力项目。项目把同一组业务能力分别封装为 Codex、DeepSeek Harness（DSH）和 Claude Code Skill；这里只保存编排规则与上游链接，不复制 OfficeCLI、MarkItDown、OpenDesign、Univer 或 Anthropic document-skills 的源码。

## 能力矩阵

| 能力 | Codex | DSH | Claude Code |
| --- | --- | --- | --- |
| Excel / Word / PPT / PDF | OpenAI 官方办公 Skills + OfficeCLI | Univer Office + OfficeCLI | Anthropic document-skills + OfficeCLI |
| 文件读取 | 官方附件能力 + MarkItDown | dsh-file-upload + MarkItDown | 官方附件能力 + MarkItDown |
| 在线办公 | Google Workspace CLI / MCP | Google Workspace CLI / DSH 插件 | Google Workspace CLI / MCP |
| 通知与审批 | Codex Connectors | dsh-im / notifier | MCP / Connectors |
| 设计与提案 | OpenDesign / Canva | OpenDesign | OpenDesign / Claude Skills |
| 企业知识库 | Notion / Drive / SharePoint | MCP | Notion / Drive MCP |

## 目录

```text
enterprise-productivity-stack/
├── anthropic-document-skills/       # Anthropic 官方仓库与四个文档 Skill 入口
├── codex/skills/                    # 6 个 Codex Skill
├── deepseek-harness/skills/         # 6 个 DSH Skill
└── claude-code/skills/              # 6 个 Claude Code Skill
```

六个 Skill 名称在三套平台保持一致：

- `himice-office-files`
- `himice-file-intake`
- `himice-online-office`
- `himice-notification-approval`
- `himice-design-proposals`
- `himice-enterprise-knowledge`

## 安装

在仓库根目录按所用平台复制：

```bash
mkdir -p ~/.codex/skills
cp -R projects/enterprise-productivity-stack/codex/skills/* ~/.codex/skills/

mkdir -p ~/.dsh/skills
cp -R projects/enterprise-productivity-stack/deepseek-harness/skills/* ~/.dsh/skills/

mkdir -p ~/.claude/skills
cp -R projects/enterprise-productivity-stack/claude-code/skills/* ~/.claude/skills/
```

Skill 只负责编排已安装或已授权的工具。首次运行时先检查对应 CLI、插件、MCP 或 Connector 是否可用；缺失时按上游说明安装，不得声称不存在的集成已就绪。

## 主要上游

- [Anthropic Agent Skills](https://github.com/anthropics/skills)
- [OpenAI Plugins](https://github.com/openai/plugins)
- [OfficeCLI](https://github.com/iOfficeAI/OfficeCLI)
- [Univer](https://github.com/dream-num/univer)
- [Microsoft MarkItDown](https://github.com/microsoft/markitdown)
- [Google Workspace CLI](https://github.com/googleworkspace/cli)
- [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)
- [OpenDesign](https://github.com/nexu-io/open-design)

外部写入、共享、发消息、发起审批或修改权限前，必须确认目标、内容和授权范围；完成后回读验证。客户资料、税号、发票、录音和内部文档不得发送到未获授权的云端或第三方服务。
