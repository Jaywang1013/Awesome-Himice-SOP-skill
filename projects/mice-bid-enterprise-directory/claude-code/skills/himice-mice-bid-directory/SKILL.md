---
name: himice-mice-bid-directory
description: 使用本地 MICE 行业上下游企业名录，为会展项目招投标、供应商寻源和资质复核生成可追溯候选池。适用于按地域、产业链、服务范围、标签和公开来源筛选企业，并显式标记待核验项。
---

# Himice MICE Bid Directory — Claude Code

先读取本机 `~/.himice/mice-bid-enterprise-directory/data/全量企业名录_15050条.csv`。如果没有该文件，提示用户从仓库根目录执行 `bash scripts/install.sh --platform claude-code --bundle general`，或提供获授权的本地 CSV；不得将名录或筛选结果上传到未获授权的远端服务。

1. 明确项目/标段、城市与服务半径、活动类型/规模、产业链环节、必备资格、优先服务范围/标签、排除条件和输出格式。
2. 本地筛选字段优先级为地域、单位类型、产业链位置、标签和服务范围；名称与代表项目关键词只作辅助。不得虚构企业能力、资质、报价、案例、履约记录或中标情况。
3. 每条候选输出 `company_id`、名称、匹配理由、`trust_level`、`confidence`、`verification_status`、`data_source_summary`、`updated_at` 和下一步核验项。
4. `trust_level` 与 `confidence` 仅代表复核优先级。名录出现不等于已准入，任何待核验/待主体核验/待补充记录都必须明确标示；最终资格以招标文件、官网和权威公告/供应商材料为准。
5. `phone`、`email`、`address`、`fax` 只用于已授权的核验或业务联系，不生成营销名单。更新使用可审计增量表，保留原始 CSV 和来源口径。

