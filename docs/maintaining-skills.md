# 维护 Skill

## 规则归属

| 变更类型 | 更新位置 |
| --- | --- |
| 预算标准、代付、人补、金额和公式规则 | 三个平台的 `himice-budget-process/references/` |
| 报销票据、行程拆分、发票勾选和核验规则 | 三个平台的 `himice-operating-expense-reimbursement-process/` |
| 备用金申请字段、部门默认信息和隐私约束 | 三个平台的 `himice-advance-fund-application-process/` |
| 会展/厦门术语和录音处理规则 | 三个平台的 `himice-vibevoice/references/` |
| OfficeCLI、DSH 插件、钉钉、设计或 PPT 上游说明 | `integrations/` 与对应 DSH 可部署包装 |
| 平台架构、钉钉/千问接入、统一接口 | `projects/himice-agent-platform-blueprint/` |
| 跨 Agent 企业办公能力矩阵 | `projects/enterprise-productivity-stack/` |

## 更新流程

1. 在一个平台版本中完成最小修改，并明确它是业务规则、平台适配还是上游说明。
2. 同步同名 Skill 的其他两个运行时版本；只保留确有必要的平台差异。
3. 若模板改变，同步对应 `assets/` 文件并用真实结构、脱敏数据完成一次渲染或公式检查。
4. 修改 README 中的能力、安装方式或上游来源。
5. 运行 `bash scripts/validate.sh` 与 `git diff --check`。
6. 确认 Git 暂存区不包含客户数据或运行产物后再提交。

## 版本与兼容性

- 新增 Skill：使用全小写连字符 ID，并同时建立三个运行时版本，或明确标记为单平台能力。
- 非兼容的输入、模板或输出变化：在对应 reference 中写明迁移说明，并更新 Blueprint 的接口示例（如适用）。
- 上游插件更新：重新核对安装命令、许可证、数据条款和官方文档；不要复制其源码进本仓库。
- 公开仓库中的文本要避免写死星标数、限时优惠或会变化的产品承诺。
