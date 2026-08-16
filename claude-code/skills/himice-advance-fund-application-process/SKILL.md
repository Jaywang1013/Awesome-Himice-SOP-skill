---
name: himice-advance-fund-application-process
description: 根据 Himice 项目预算表生成预估协作人审批表（备用金申请表），本地填写项目、报账人、营业额、毛利率、毛利润、活动信息、客户名称和纳税人识别号。
when_to_use: Use when a user needs a Himice advance-fund application workbook from a project budget and provides client name and taxpayer identification number.
argument-hint: "<项目预算表> <客户名称> <纳税人识别号> [报账人]"
disable-model-invocation: true
---

# Himice 备用金申请表

仅在用户明确调用 `/himice-advance-fund-application-process` 后执行。先读取 `${CLAUDE_SKILL_DIR}/references/advance-fund-rules.md`，默认复制 `${CLAUDE_SKILL_DIR}/assets/【预估协作人审批表模板】鱼鹰号+活动名称.xlsx`。本 Skill 只生成表格，不替代审批、付款或税务判断。

## 严格本地处理

- 客户名称、纳税人识别号、联系人、个人姓名和原始预算表仅能在用户本机处理和保存。
- 禁止通过网页、API、云盘、外部服务或 GitHub 上传这些资料；不得在 Skill、README、测试样例、提交信息或日志中写入真实客户资料。
- 代码仓库只允许保存空白模板和通用规则；生成文件保存到本地 `outputs/`。

## 填写

收集项目预算表、客户名称和纳税人识别号；优先提取会议名称、报账人、日程、会议人数、预计收入、预计毛利率和预计毛利。缺少客户名称、税号或报账人时写 `[待确认]`，不得使用模板示例值。

1. 仅编辑审批表第 4 行，保留所有工作表、列、颜色、格式、下拉选项和备注。
2. 写入项目名称、报账人、预计营业额、预计毛利率；毛利润使用 `营业额×毛利率` 公式，金额两位小数、毛利率两位百分比。
3. 从日程写活动起止、从预算写会议人数；可确认的活动内容与城市可填写。地点、业务类型、竞标状态、客户来源/类型、联系人及比例无法确认时保持空白或标 `[待确认]`。
4. 写入客户名称和纳税人识别号，但只留在本地输入/输出工作簿，绝不写入仓库或云端。

核验营业额、毛利率、毛利润与预算表一致；扫描目标表公式错误并渲染检查格式。预算表其他工作表已有的历史公式错误不得修复。交付时只说明已填字段与待确认字段，不复述客户名称、税号或其他敏感资料。
