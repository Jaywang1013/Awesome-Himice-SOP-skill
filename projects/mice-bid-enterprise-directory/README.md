# 招投标 MICE 行业上下游企业一览（仍在补充）

`mice-bid-enterprise-directory` 是 Himice 的行业数据项目：以全国会展产业链企业/机构主表为基线，为项目招投标、供应商寻源、资质复核和竞品/合作方研究提供本地可检索的候选池。

它是 **通用行业数据能力**，可与 `himice-budget-process`、`himice-office-files` 和 `himice-enterprise-knowledge` 配合使用，但不替代采购审批、法务审查或人工尽调。

## 当前基线

| 项目 | 内容 |
| --- | --- |
| 数据文件 | `data/全量企业名录_15050条.csv` |
| 规模 | 15,050 条企业/机构记录，37 个字段 |
| 基线校验和 | `SHA-256 6bb1385ee5667815872e2bffc15672bc2aa863591fd01e5e77baff2eb89db75e` |
| 覆盖 | 会展产业链上游、中游、支持机构；企业、协会、场馆、酒店商旅、政府/公共机构和少量海外单位 |
| 核验口径 | 以 `可信度 / 核验状态 / 来源摘要`（CSV 对应 `trust_level`、`verification_status`、`data_source_summary`）保留公开来源与待复核说明 |
| 状态 | 仍在补充；目录候选不等于已准入供应商或已通过招标资格审查 |

字段及质量摘要见 [`data/schema.md`](data/schema.md) 和 [`data/data-quality-report.md`](data/data-quality-report.md)。

## 能做什么

1. 根据项目城市、活动类型、产业链环节、服务范围和标签筛出候选企业。
2. 用可信度、核验状态、来源摘要和更新时间标出“可优先复核”与“仅作线索”的记录。
3. 输出可追溯的候选清单、复核待办和招投标研究摘要；不能虚构资质、案例、报价、获奖、履约能力或中标记录。
4. 将已人工确认的补充信息作为增量记录维护，但不得覆盖原始来源口径。

## 三个平台的 Skill

| 平台 | Skill | 使用方式 |
| --- | --- | --- |
| Codex | [`codex/skills/himice-mice-bid-directory/`](codex/skills/himice-mice-bid-directory/) | `$himice-mice-bid-directory` |
| DeepSeek Harness | [`deepseek-harness/skills/himice-mice-bid-directory/`](deepseek-harness/skills/himice-mice-bid-directory/) | 点名 Skill 或描述招投标检索任务 |
| Claude Code | [`claude-code/skills/himice-mice-bid-directory/`](claude-code/skills/himice-mice-bid-directory/) | `/himice-mice-bid-directory` |

从仓库根目录安装通用能力时，Skill 和 CSV 会一起写入同事本地：

```bash
bash scripts/install.sh --platform codex --bundle general
# 数据库安装位置：~/.himice/mice-bid-enterprise-directory/data/
```

安装器不覆盖已有数据库文件。若需要更新基线，应先备份旧文件、核验新文件的记录数和校验和，再替换并提交更新说明。

## 推荐调用格式

```text
使用 himice-mice-bid-directory 为以下项目建立候选池：
- 项目/标段：
- 举办城市与服务半径：
- 活动类型与规模：
- 需要的产业链环节：
- 必备资质或准入条件：
- 希望优先的服务范围/标签：
- 排除条件：
- 需要的输出：候选清单 / 核验待办 / 招投标研究摘要
```

Skill 会先区分“目录筛选条件”和“必须从招标文件或官网再次核验的资格条件”。没有给出资格条件时，不把目录字段当作资格证明。

## 数据与使用边界

- 本基线由项目数据工程沉淀，来源摘要、可信度、核验状态和来源类型随记录保存；企业公开联系方式仅用于核验或在获授权的业务流程中联系，不用于批量营销触达。
- 列表中可能存在待核验、重复主体、旧名称、旧地址或旧联系方式。`trust_level=A` 或 `confidence=高` 也不等同于当前有效资质。
- 生成候选池后，仍须按招标文件、企业官网、权威协会/场馆/酒店页面及公司采购制度做最终复核；复核结论应写明日期和来源。
- 不导入客户资料、投标报价、内部评分、采购决策、个人隐私信息或未获授权的第三方数据。增量维护规则见 [`references/verification-and-update-rules.md`](references/verification-and-update-rules.md)。

