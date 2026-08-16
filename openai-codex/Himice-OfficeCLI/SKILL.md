---
name: himice-officecli
description: 使用 OfficeCLI 创建、读取、修改、校验和渲染 Himice 的 Excel、Word 与 PowerPoint 文件。适用于项目预算、客户报价、会议方案、执行清单、复盘和其他需要保留 Office 格式的文件工作。
---

# Himice OfficeCLI

使用 [OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 作为 Office 文件操作工具。本 Skill 是 Himice 的工作流封装，不复制 OfficeCLI 源代码、二进制或其依赖；安装、版本与许可证以 [上游仓库](https://github.com/iOfficeAI/OfficeCLI) 为准。

## 工作方式

1. 先运行 `officecli --version`，确认上游工具可用；只加载当前文件类型所需的专项规则。
2. 先查看和提取结构，再编辑：保留原文件、样式、公式、合并单元格、列宽、冻结窗格、批注和数字格式，除非用户明确要求改变。
3. Excel 修改需要行列增删时，先查询对应帮助；复制相邻行或列的样式、公式和校验规则。报价与预算的具体规则优先使用 `$himice-budget-process`。
4. 修改后运行 OfficeCLI 校验，并渲染/截图复核关键页面。重点检查公式错误、分页、表头、金额格式、合并关系和内容溢出。
5. 交付时说明输出文件、已做的校验和仍需人工确认的项目；不要声称 OfficeCLI 未实际验证的结果。

## Himice 文件处理原则

- 预算、报价和结算表：金额必须保持为数值，显示格式遵从原模板；不得用文本替换公式。
- 会议与展览方案：优先保留客户品牌、版本标识、日期、场地和责任人；没有原始资料时明确标注待确认。
- 内部或客户资料仅在已授权范围内处理；不要把文件内容、客户信息或会议录音发送到未授权服务。

## 交叉使用

- 制作活动预算表：调用 `$himice-budget-process`，并按该 Skill 的模板、代付和费用规则执行。
- 转写会议音频并产出纪要：调用 `$himice-vibevoice`；需要将纪要写入 Office 文件时，再使用本 Skill。
- 整理实际操作费用报销：调用 `$himice-operation-expense-reimbursement`；需要把已确认报销明细写入公司模板时，再使用本 Skill。
