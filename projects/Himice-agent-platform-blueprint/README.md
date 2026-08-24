# Himice Agent Platform Blueprint

面向 Himice 同事的企业 Agent 平台参考项目。它不替代现有 SOP Skills，也不复制大型 Agent 框架源码；它规定现有 Skills 如何被 Codex、DeepSeek Harness（DSH）、Claude Code、千问及钉钉等入口安全调用。

## 设计结论

- 现有 `himice-*` Skills 继续作为业务规则与模板的唯一事实来源。
- Codex、DSH、Claude Code 和后续千问适配层只负责运行时差异，不重复编写公司规则。
- 钉钉是员工入口、身份与协同层，不是业务规则存储层。
- 千问办公会员是员工交互与办公能力权益；模型 API、钉钉开放平台权限和生产自动化授权必须分别确认。
- 客户资料、税号、发票、录音、联系人和内部报价默认本地处理；任何云端传输都必须经过公司授权。
- 外部写入、发消息、建待办、提交审批和共享文件必须先预览并确认。

## 文档导航

| 文档 | 用途 |
| --- | --- |
| [architecture.md](architecture.md) | 分层架构、数据流和不变原则 |
| [technology-selection.md](technology-selection.md) | 框架选型与启用条件 |
| [deployment.md](deployment.md) | 从本地 Skills 到钉钉企业入口的分阶段部署 |
| [integrations/dingtalk-qwen.md](integrations/dingtalk-qwen.md) | 千问会员与钉钉接入边界、试点方案和管理员核对清单 |
| [interfaces/skill-interface-v1.md](interfaces/skill-interface-v1.md) | 现有 Skills 与 Agent/钉钉适配器的统一接口规范 |
| [interfaces/skill-manifest.example.yaml](interfaces/skill-manifest.example.yaml) | Skill 能力清单示例 |
| [security-and-governance.md](security-and-governance.md) | 数据分类、权限、审计与审批要求 |

## 推荐路线

当前先采用轻量方案：

```text
钉钉群 / 钉钉工作台
        ↓ 企业身份、用户/群白名单
DingTalk Workspace CLI / 企业机器人（Stream 模式）
        ↓ 标准化调用请求
Codex / DSH / Claude Code / 经批准的千问运行时
        ↓
Himice Skills（预算、备用金、报销、会议转录等）
        ↓
本地 Office 工具与模板 → 本地生成结果
        ↓
钉钉仅返回摘要、状态和经批准的文件/链接
```

暂不部署统一服务端 Agent 平台。只有在出现跨部门并发、长任务恢复、统一审批、集中审计或知识库权限检索需求时，再按 [technology-selection.md](technology-selection.md) 引入编排、知识与可观测组件。

## 上游参考

- [DingTalk Workspace CLI](https://github.com/DingTalk-Real-AI/dingtalk-workspace-cli)
- [钉钉开放平台：自定义机器人](https://open.dingtalk.com/document/orgapp/custom-robot-access)
- [钉钉 Stream SDK（Python）](https://github.com/open-dingtalk/dingtalk-stream-sdk-python)
- [Microsoft Agent Framework](https://github.com/microsoft/agent-framework)
- [OpenAI Agents SDK](https://github.com/openai/openai-agents-python)
- [Google Agent Development Kit](https://github.com/google/adk-python)
- [LangGraph](https://github.com/langchain-ai/langgraph)
- [Langfuse](https://github.com/langfuse/langfuse)
- [Onyx](https://github.com/onyx-dot-app/onyx)
- [PipesHub](https://github.com/pipeshub-ai/pipeshub-ai)
- [RAGFlow](https://github.com/infiniflow/ragflow)
- [Dify](https://github.com/langgenius/dify)
- [n8n](https://github.com/n8n-io/n8n)

所有上游仅作为选型与接口参考。正式引入前重新核对许可证、版本、安全公告、数据处理条款与公司采购授权。
