# 数据目录

此目录保存“招投标 MICE 行业上下游企业一览”的公开企业/机构基线数据。当前文件为 `全量企业名录_15050条.csv`，原始字段名保持不变，以便数据工程增量更新、审计和同事间复现。

## 数据版本

| 指标 | 当前值 |
| --- | --- |
| 记录数 | 15,050 |
| 字段数 | 37 |
| 文件编码 | UTF-8（含 BOM） |
| 基线日期 | 2026-08-11（源文件时间戳） |
| SHA-256 | `6bb1385ee5667815872e2bffc15672bc2aa863591fd01e5e77baff2eb89db75e` |

## 使用约束

- 读取和检索时，以 `company_id` 作为行级稳定标识；展示时优先使用 `company_name`，合并/去重时辅助使用 `normalized_name`。
- `data_source_summary`、`source_types`、`source_ids`、`trust_level`、`verification_status`、`confidence` 和 `updated_at` 是必读字段，不能为了输出简洁而丢失核验口径。
- `phone`、`email`、`address` 和 `fax` 是公开企业联络信息，但只能用于已获授权的业务核验或联系；不得导出为营销名单、不得补充个人敏感信息。
- CSV 中少量电话或传真以 `+`、`-` 开头。导入 Excel/Sheets 时必须按**文本**读取，不能直接双击导入或把这些字段写入公式单元格；导出为表格时同样保持文本格式。
- 不直接修改原始 CSV。人工核验产生的更新应保留原值、变更日期、变更人、核验来源和结论，并在合并前接受复核。

详细字段定义见 [`schema.md`](schema.md)，基线统计见 [`data-quality-report.md`](data-quality-report.md)。
