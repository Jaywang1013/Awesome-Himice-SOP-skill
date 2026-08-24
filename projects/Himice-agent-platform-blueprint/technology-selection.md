# 技术选型

## 当前推荐

| 层 | 当前选择 | 原因 | 何时升级 |
| --- | --- | --- | --- |
| 业务能力 | 现有 Himice Skills | 已沉淀公司规则、模板和三平台版本 | 保持，不替换 |
| 本地运行时 | Codex / DSH / Claude Code | 同事可独立部署，敏感文件可本地处理 | 保持多运行时 |
| 钉钉连接 | DingTalk Workspace CLI；必要时企业机器人 Stream 模式 | 官方 CLI 面向 Agent，支持结构化输出、Skill、OAuth 和权限控制 | 完成企业管理员授权后试点 |
| 千问 | 可选交互运行时/模型 | 公司已有合作权益，适合降低员工使用门槛 | 先确认会员、API、数据条款和钉钉权限边界 |
| 编排 | 暂不集中部署 | 当前 SOP 以单人文件任务为主，集中服务会过早增加运维和数据风险 | 跨部门、长任务、统一审批出现后再引入 |
| 可观测 | 本地任务清单；后续评估自托管 Langfuse | 先记录最小审计元数据 | 有稳定多人调用量后启用 |

## 候选项目的定位

- [Microsoft Agent Framework](https://github.com/microsoft/agent-framework)：首选的企业编排参考，用于检查点、人工审批、任务恢复和 OpenTelemetry；不放入 Skill 仓库源码。
- [OpenAI Agents SDK](https://github.com/openai/openai-agents-python)：Codex/OpenAI 运行时的工具、handoff、guardrail、会话和 tracing 参考。
- [Google ADK](https://github.com/google/adk-python)：工具确认、评测、多 Agent 与部署规范参考。
- [LangGraph](https://github.com/langchain-ai/langgraph)：需要长任务状态、分支和恢复时的备选编排框架。
- [Langfuse](https://github.com/langfuse/langfuse)：自托管追踪、提示词版本、数据集与评测候选；它不是 Agent 运行时。
- [Onyx](https://github.com/onyx-dot-app/onyx)：需要企业搜索入口、连接器、SSO/RBAC 和内部 Agent 门户时评估。
- [PipesHub](https://github.com/pipeshub-ai/pipeshub-ai)：需要继承源系统权限的企业上下文层时优先评估。
- [RAGFlow](https://github.com/infiniflow/ragflow)：大量 PDF、Office、合同与制度文档需要解析和可追溯引用时评估。
- [Dify](https://github.com/langgenius/dify)：需要让非技术管理员可视化编排时评估；业务规则仍归 Himice Skills。
- [n8n](https://github.com/n8n-io/n8n)：仅作为通知和系统集成总线；正式使用前核对 fair-code 许可和安全配置。

## 选型门槛

引入任何新平台前必须同时回答：

1. 它解决了当前已发生的什么问题？
2. 是否能自托管，数据会传到哪里？
3. 是否支持企业身份、最小权限、审计和删除？
4. 是否允许当前公司的商业使用和部署方式？
5. 停用后能否导出任务、提示词、知识和日志？
6. 能否通过 [Skill Interface v1](interfaces/skill-interface-v1.md) 调用现有 Skills，而不复制业务规则？

若问题仅是“从钉钉触发本地 Skill 并返回结果”，不要部署完整 Dify、RAG 或多 Agent 平台，优先使用 DingTalk Workspace CLI/企业机器人加本地运行时。
