# 字段说明与招投标用途

| 字段 | 含义 | 招投标使用方式 |
| --- | --- | --- |
| `company_id` | 记录唯一标识 | 作为引用、去重和复核键。 |
| `company_name` / `normalized_name` | 企业原名称 / 规范名称 | 展示候选、识别同名与名称变更。 |
| `editions` / `booths` | 参展届次 / 展位信息 | 仅作会展参与线索，不等同于履约资质。 |
| `unit_type` | 单位类型 | 初步筛选企业、协会、场馆、酒店商旅或公共机构。 |
| `tags` | 业务标签 | 与项目所需服务作关键词匹配。 |
| `industry_chain_position` | 上游、中游、支持机构或待判定 | 先定位招标需求所在环节。 |
| `country` / `province` / `city` / `district` / `region` | 地理范围 | 按举办城市、服务半径、属地响应筛选。 |
| `organization_nature` | 机构性质 | 作为组织背景线索，不能替代资格文件。 |
| `service_scope` | 服务范围 | 与标段服务内容做初筛和差距提示。 |
| `representative_projects` | 代表项目摘要 | 仅作案例线索，须回到公开来源或供应商材料核验。 |
| `association_member` / `ufi_related` / `icca_related` / `international_memberships` | 行业关联信息 | 作为待核验线索，需检查当前有效性。 |
| `website` | 官网链接 | 优先用于回查企业主体、服务与资质公告。 |
| `address` / `phone` / `email` / `fax` | 公开企业联络信息 | 只用于授权的核验或业务联系，禁止批量营销导出。 |
| `data_source_summary` | 来源摘要 | 每条结论的来源说明和复核起点。 |
| `trust_level` | 来源可信等级 | 排序与复核优先级的辅助信号，非资格结论。 |
| `updated_at` | 记录更新时间 | 判断是否需要优先回查。 |
| `contact_policy` | 联系方式使用说明 | 联系前检查是否存在限制。 |
| `verification_status` | 核验状态 | 输出中必须展示或归纳，避免将待核验记录当作确认事实。 |
| `confidence` | 信息可信度 | 与 `trust_level` 一起作为候选排序的辅助信号。 |
| `location_method` | 地理信息取得方式 | 判断地域筛选是否需地图/官网复核。 |
| `source_ids` / `source_types` | 上游来源标识和类型 | 用于追溯、抽样复查和后续增量合并。 |
| `notes` | 备注 | 提取限制、异常或人工待办，不把空值作负面判断。 |

