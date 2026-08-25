---
name: himice-mice-bid-directory
description: 使用本地 MICE 行业上下游企业名录，为会展项目招投标、供应商寻源和资质复核生成可追溯候选池。适用于按地域、产业链、服务范围、标签和公开来源筛选企业，并显式标记待核验项。
---

# Himice MICE Bid Directory — DeepSeek Harness

先检查本机 `~/.himice/mice-bid-enterprise-directory/data/全量企业名录_15050条.csv`；未找到时提示用户在仓库根目录执行 `bash scripts/install.sh --platform dsh --bundle general`，或提供获授权的本地 CSV。不要把名录上传至第三方服务，也不要假设 DSH 已获得企业系统权限。

1. 向用户确认项目/标段、举办城市与服务半径、活动类型和规模、需要的产业链环节、必备资格、优先标签/服务范围、排除条件与输出形式。
2. 在本地按 `country`、`region`、`province`、`city`、`unit_type`、`industry_chain_position`、`tags`、`service_scope` 筛选，名称与案例关键词仅用于补充。使用文件上传、表格或搜索插件前，先确认插件可用且不会将数据外发。
3. 结果逐条保留 `company_id`、名称、匹配理由、`trust_level`、`confidence`、`verification_status`、`data_source_summary`、`updated_at` 和待核验项。
4. 不将目录结果写成已准入、已通过资格审查或中标建议。核验状态包含待核验、待主体核验或待补充时必须显著标记；最终资格回查招标文件、官网和权威公告/材料。
5. 企业公开联络信息仅用于用户授权的核验或业务联系，不做营销名单、不推断个人信息。更新时保留原始 CSV，并用有来源、日期和审核状态的增量表记录变更。

