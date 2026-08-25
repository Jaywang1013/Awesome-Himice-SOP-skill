---
name: himice-mice-bid-directory
description: 使用本地 MICE 行业上下游企业名录，为会展项目招投标、供应商寻源和资质复核生成可追溯候选池。适用于按地域、产业链、服务范围、标签和公开来源筛选企业，并显式标记待核验项。
---

# Himice MICE Bid Directory — Codex

使用本 Skill 前，先读取本机数据库 `~/.himice/mice-bid-enterprise-directory/data/全量企业名录_15050条.csv`。若文件未安装，说明需要从本仓库根目录执行 `bash scripts/install.sh --platform codex --bundle general`，或由用户提供获授权的 CSV 本地路径。不得把名录、筛选结果或联系方式上传到未获授权的云端。

1. 先收集项目/标段、举办城市与服务半径、活动类型与规模、需要的产业链环节、必备资格、优先服务范围/标签、排除条件和希望的输出格式。资格条件缺失时，明确目录只能提供线索。
2. 仅在本地检索 CSV。优先使用 `country`、`region`、`province`、`city`、`unit_type`、`industry_chain_position`、`tags`、`service_scope`，再以名称或代表项目关键词辅助；不要凭空补全企业能力。
3. 每条候选至少输出 `company_id`、企业名称、匹配理由、`trust_level`、`confidence`、`verification_status`、`data_source_summary`、`updated_at` 与待核验项。不得把名录记录称作“已准入”“符合资质”或“推荐中标”。
4. `trust_level`、`confidence` 和来源丰富度只能帮助安排复核顺序。只要核验状态包含待核验、待主体核验或待补充，就在结果中突出标记；最终资格必须回查招标文件、企业官网和权威公告/材料。
5. `phone`、`email`、`address`、`fax` 为公开企业联络信息，仅在用户明确授权的核验或业务联系任务中使用；不要导出营销名单或推断个人信息。
6. 需要更新数据库时，保留原始 CSV，另建可审计增量表并记录旧值、新值、公开来源、核验日期、经办人与审核状态。详细规则见项目的 `references/verification-and-update-rules.md`。

