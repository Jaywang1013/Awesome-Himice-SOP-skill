# Himice Skill Interface v1

本规范定义渠道、Agent 运行时与现有 Himice Skills 之间的最小合同。它不要求重写现有 `SKILL.md`；适配器可从现有目录生成或维护对应 manifest。

## 标识与版本

- `skill_id`：全局稳定的小写连字符名称，例如 `himice-budget-process`。
- `skill_version`：语义化版本；规则、模板或接口发生变化时更新。
- `interface_version`：当前为 `himice.ai/v1`。
- 三个平台的同一业务 Skill 使用相同 `skill_id`，平台目录大小写差异不影响标识。

## 请求

```json
{
  "request_id": "uuid",
  "skill_id": "himice-budget-process",
  "runtime": "codex|dsh|claude-code|qwen",
  "actor": {
    "organization_id": "...",
    "user_id": "...",
    "department_id": "...",
    "channel": "local|dingtalk",
    "conversation_id": "..."
  },
  "inputs": {
    "attachments": [],
    "fields": {}
  },
  "options": {
    "output_directory": "absolute-local-path",
    "dry_run": true,
    "allow_cloud_transfer": false
  }
}
```

### 请求规则

- `actor` 必须来自实际登录身份，禁止由聊天文本伪造。
- 附件进入独立本地任务目录，保留原文件名、SHA-256 和来源。
- 运行时在执行前检查 manifest 的必填字段、允许附件类型、数据等级和写操作。
- 信息缺失时返回 `needs_input`，不得猜测会改变结果的业务信息。
- `allow_cloud_transfer=false` 时不得上传原件或正文到钉钉、外部模型、知识库或其他云服务。

## 响应

```json
{
  "request_id": "uuid",
  "status": "completed|needs_input|needs_approval|failed|cancelled",
  "summary": "给员工看的最小必要摘要",
  "artifacts": [
    {
      "type": "xlsx",
      "local_path": "absolute-local-path",
      "sha256": "...",
      "classification": "confidential"
    }
  ],
  "checks": [],
  "pending_questions": [],
  "approval": null,
  "audit": {
    "skill_version": "...",
    "template_version": "...",
    "started_at": "...",
    "finished_at": "..."
  }
}
```

## 状态语义

- `completed`：任务和规定核验均完成。
- `needs_input`：缺少业务输入；列出缺项后停止。
- `needs_approval`：即将产生外部写入、共享、消息、待办或审批；提供预览后停止。
- `failed`：无法安全完成；保留原件并说明失败点，不声称成功。
- `cancelled`：用户或系统取消；不得继续后台执行。

## 外部写入确认

确认载荷至少包含：

- 目标组织、群、人员或审批实例；
- 将发送/写入的摘要和附件清单；
- 数据等级；
- 将使用的实际员工身份；
- 幂等键和预计副作用。

确认只能授权预览中列出的单次操作，不成为后续任务的永久授权。

## 现有 Skill 映射

| Skill | 主要输入 | 主要输出 | 默认数据等级 |
| --- | --- | --- | --- |
| `himice-budget-process` | 报价、预算表头信息 | 项目预算表 | confidential |
| `himice-advance-fund-application-process` | 预算表、客户/报账信息 | 备用金申请表 | restricted |
| `himice-operating-expense-reimbursement-process` | 发票、行程单、支付截图、经手人 | 操作收支明细表 | restricted |
| `himice-vibevoice` | 已授权录音、会议信息 | 转写、纪要、行动项 | confidential |
| `himice-officecli` | 本地 Office 文件和编辑要求 | 编辑后的 Office 文件 | inherit |

`restricted` 原件默认禁止回传钉钉；需要回传时必须取得明确授权并符合公司数据政策。
