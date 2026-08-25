# Awesome Himice SOP Skills：项目交接与续开发说明

> 用途：本文件是给新对话、新同事或新的开发 Agent 的上下文交接包。继续开发前先阅读本文件、根目录 `AGENTS.md`、`README.md` 和目标 Skill 的 `SKILL.md`。

## 1. 项目定位

仓库：[Jaywang1013/Awesome-Himice-SOP-skill](https://github.com/Jaywang1013/Awesome-Himice-SOP-skill)

这是 Himice 面向活动会展项目的**本地优先 Skill 库**。目标不是做一个单体应用，而是把可复用的公司 SOP、模板处理规则和行业知识沉淀为可部署的 Agent Skills，并同时适配：

- OpenAI Codex：`~/.codex/skills/`
- DeepSeek Harness（DSH）：`~/.dsh/skills/`
- Claude Code：`~/.claude/skills/`

核心设计是：**业务规则只维护一套逻辑；不同 Agent 只做运行时适配；所有真实项目资料默认本地处理。**

## 2. 设计不变原则

1. **本地优先。** 客户报价、预算、税号、发票、支付截图、录音、联系人、员工信息和内部评分不上传未授权云端。
2. **模板优先。** Excel/Word/PPT 模板的布局、公式、冻结、数据验证、金额格式等属于交付要求，不可为了“填完内容”而破坏。
3. **规则可追溯。** 每个生成结果都应能说明输入、公式、来源、假设、人工待确认项和校验结果。
4. **三端同名同步。** 业务 Skill 的 `name` 在 Codex、DSH、Claude Code 中保持一致。改变业务规则或模板时，必须同步三端。
5. **先预览，后外写。** 对外消息、审批、共享、通知、云端写入和权限变更必须先确认目标与内容。
6. **目录不是结论。** 行业企业库可用于线索与候选池，不能自动证明供应商已准入、资质有效或应中标。
7. **不复制第三方源码。** 上游能力只写接入说明与链接；正式引入时重新检查许可证、版本和数据条款。

## 3. 目录与职责

```text
.
├── skills/                             # 核心 SOP 的可部署版本
│   ├── codex/
│   ├── deepseek-harness/skills/
│   └── claude-code/skills/
├── projects/                           # 通用能力项目、行业数据与架构蓝图
│   ├── enterprise-productivity-stack/
│   ├── himice-agent-platform-blueprint/
│   └── mice-bid-enterprise-directory/
├── integrations/                       # OfficeCLI、DSH 插件、OpenDesign、PPT 等上游接入说明
├── docs/                               # 维护、安全和本交接文档
├── scripts/install.sh                  # 多平台安全安装器
├── scripts/validate.sh                 # 结构与元数据检查
├── assets/                             # README 展示素材
└── AGENTS.md                           # 仓库变更约定
```

`skills/` 放置公司核心业务 SOP；`projects/` 放置可选、通用或跨 Skill 的能力。新能力先判断它是否属于活动项目的必经流程：是则进入核心 SOP；否则进入项目并归为通用能力。

## 4. 已有 Skill 总表

目前有 **18 个独立 Skill**；同名的三端副本只算一个 Skill。

### 核心 SOP（`--bundle core`）

| Skill | 作用 | 关键边界 |
| --- | --- | --- |
| `himice-budget-process` | 从客户报价生成项目预算表；处理板块、数量、收入/成本、代付服务费、现金项、合计和公式校验。 | 代付服务费仅限场地/会场、住宿、餐饮、机票/动车等既定项；茶歇不计。必须保留人民币两位小数格式与公式。 |
| `himice-advance-fund-application-process` | 从预算表生成预估协作人审批表/备用金申请表。 | 填营业额、毛利率、客户名称、税号、报账人；客户与税号本地处理。每次先确认部门默认信息。 |
| `himice-operating-expense-reimbursement-process` | 将发票、行程单、支付截图和经手人填入单表操作收支明细。 | 只改“结算-项目收支明细”/最新单表；滴滴、货拉拉逐笔拆分，备注为“平台：出发地-目的地”；有发票勾选，支付截图不能当发票。 |
| `himice-vibevoice` | 已授权录音的会议/会展转写与纪要。 | 结合 Himice、会展、厦门术语；输出转写、行动项、待确认项；录音默认本地。 |
| `himice-officecli` | Office 文件读取、修改、校验和渲染。 | 参考 OfficeCLI；保护格式、公式和模板结构。 |

### 通用办公与行业数据（`--bundle general`）

| Skill | 作用 | 所在项目 |
| --- | --- | --- |
| `himice-office-files` | Excel/Word/PPT/PDF 的创建、读取、编辑与校验路由。 | `enterprise-productivity-stack` |
| `himice-file-intake` | PDF、Office、图片、网页、压缩包等附件读取与整理。 | `enterprise-productivity-stack` |
| `himice-online-office` | 已授权的 Drive、Docs、Sheets、Slides、Gmail、Calendar 操作。 | `enterprise-productivity-stack` |
| `himice-notification-approval` | 通知、人工确认、审批状态与连接器对接。 | `enterprise-productivity-stack` |
| `himice-design-proposals` | 主视觉、提案、原型、演示和设计交付。 | `enterprise-productivity-stack` |
| `himice-enterprise-knowledge` | Notion、Drive、SharePoint 等知识源的检索、汇总与维护。 | `enterprise-productivity-stack` |
| `himice-mice-bid-directory` | 本地检索会展产业链企业库，生成招投标候选池、来源说明和核验待办。 | `mice-bid-enterprise-directory` |

### DSH 专用集成（同属 `--bundle general`）

| Skill | 作用 |
| --- | --- |
| `dsh-file-upload` | 文件上传、解析与 MarkItDown 转换。 |
| `dsh-vision-router` | OCR、看图、元素定位、图像处理。 |
| `dsh-dingtalk` | 钉钉群 Markdown/文本通知。 |
| `dsh-notifier` | 钉钉、飞书、企业微信等任务通知。 |
| `open-design` | 活动视觉、原型、图片/视频/动效设计。 |
| `pptfast` | 大纲/文档生成原生可编辑 PPTX。 |

## 5. 已确认的业务规则

### 预算表

- 客户报价是预计收入；预计成本初始可与预计收入相同，后续人工调整。
- 同一板块名称需合并；报价没有的行删除，有新增或对不上的内容插行并保证公式合计覆盖新增行。
- 金额保持 `¥` 加两位小数，不更改模板数字格式。
- 客户报价为 0 的项目，在预算表填 0，不留空。
- 会议服务商代付归入酒店相关的既定代付项；茶歇不收取代付服务费。
- 代付服务费为代付费用合计的 6%；模板已确认的示例逻辑为 `C62=B62`，`B62=SUM(F57:F61)*0.06`，具体单元格仍应以当前模板为准。
- 黄色填充表示提取现金部分，在预计成本中只标黄对应物料总价。
- 默认操作费用：餐饮 70 元/人/天；交通往返 1,000 元/人（次数 2）；住宿双人间 300 元/间/晚（2 人一间）；正式工人补 120 元/人/天，试用期和实习生 70 元/人/天，管理层级 M 无人补；B1–B6 为项目助理/项目专员。实际项目若已有报价或明确规则，应以项目输入优先。

### 备用金申请

- 输入：项目预算表、营业额、毛利率、客户名称、纳税人识别号、报账人。
- 客户名称与纳税人识别号只在本地保存与处理，禁止上传云端。
- 默认部门信息的交互是强制步骤：先提示“这是厦门公司项目二部的默认信息”，由用户选用默认、提交修改、或更新新的部门默认信息。
- 厦门公司项目二部当前默认值：活动类型差旅；业务类型其他类型；非竞标；非本地客户；客户联系人黄少雄 13225932008；客户来源已有客户；客户类型普通直客；销售黄少雄 100%；谈判李蒙 100%；执行李蒙 80%、王锦燦 20%。其他字段根据预算表提取。

### 操作费用报销

- 当前模板是一张表，用户部署后上传本次项目的发票、行程单、支付截图与经手人信息即可填表。
- 仅填指定的收支明细表，不修改预算/清算/人补等其他子表；模板变成单表时同步更新说明。
- 滴滴行程单的每笔行程必须拆成独立行；备注格式 `滴滴：出发地-目的地`。货拉拉同理：`货拉拉：出发地-目的地`。
- 有对应发票的记录，在可选单元格中勾选；支付截图仅能证明支付，不可勾选发票。
- 金额、日期、摘要、经手人和票据必须交叉校验；无法匹配的记录明确标待确认。

## 6. 企业 Agent 与钉钉设计

详见 `projects/himice-agent-platform-blueprint/`。

推荐的当前路线：

```text
钉钉群 / 钉钉工作台
        ↓ 身份、白名单、协同入口
DingTalk Workspace CLI / 企业机器人（Stream）
        ↓ 标准化请求
Codex / DSH / Claude Code / 经批准的千问运行时
        ↓
Himice Skills + 本地 Office 工具/模板
        ↓
本地结果；钉钉只返回摘要、状态和经批准的文件/链接
```

千问办公会员、千问 API/百炼额度、钉钉开放平台权限是三种独立授权。会员有助于员工使用 AI 办公，但不会自动获得钉钉组织数据、机器人权限或生产 API 权限。当前不应急于搭建统一云端 Agent 平台；只在出现跨部门并发、长任务恢复、统一审批、集中审计或知识库权限检索需求时，再评估编排平台。

## 7. MICE 招投标企业库

项目目录：`projects/mice-bid-enterprise-directory/`。

- 基线文件：`data/全量企业名录_15050条.csv`
- 当前规模：15,050 条，37 字段；SHA-256：`6bb1385ee5667815872e2bffc15672bc2aa863591fd01e5e77baff2eb89db75e`
- 关键字段：`company_id`、`company_name`、地域字段、`unit_type`、`industry_chain_position`、`tags`、`service_scope`、`trust_level`、`verification_status`、`confidence`、`data_source_summary`、`source_types`、`updated_at`。
- 行业基线为项目负责人确认可公开使用的企业级数据；公开联系电话、邮箱、地址仅限获授权的核验和业务联系，禁止导出营销名单。
- 使用 CSV 时按文本读取。少量电话/传真以 `+` 或 `-` 开头，直接导入 Excel/Sheets 可能触发公式解释。
- 候选池输出必须包含企业 ID、匹配理由、来源、可信度、核验状态、更新时间和待核验项；不输出自动中标建议或资格结论。
- 不直接改原始 CSV。增量表必须记录旧值、新值、来源、核验日期、经办人和审核状态。

## 8. 安装、验证与提交

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

# 核心流程
bash scripts/install.sh --platform codex --bundle core --dry-run
bash scripts/install.sh --platform codex --bundle core

# 通用办公能力与招投标企业库
bash scripts/install.sh --platform codex --bundle general

# 三平台都可用：codex / dsh / claude-code
bash scripts/validate.sh
git diff --check
```

`--bundle general` 会把 MICE CSV 安装至 `~/.himice/mice-bid-enterprise-directory/data/`。安装器不覆盖已有 Skill 或数据库，更新前应备份、核对记录数与 SHA-256。

提交前最低检查：

```bash
bash scripts/validate.sh
git diff --check
git status --short
```

## 9. 后续开发方式

1. 先读目标 Skill 的三端副本与对应 `references/`；确认新要求是业务规则、模板变化、平台适配还是集成能力。
2. 业务规则改变时，同时改 Codex、DSH、Claude Code，保持 `name` 不变；Codex Skill 同时维护 `agents/openai.yaml`。
3. 涉及 Excel/PDF/Word/PPT 时先读取当前模板结构，尽量复制邻近行/公式/格式，并以真实或脱敏样例回读校验。
4. 涉及外部系统、钉钉、消息、审批、共享、云端模型时，先确认授权与实际可用工具，不得假定凭据或连接器已经可用。
5. 新建项目应放在 `projects/<lowercase-hyphen-name>/`，包含独立 README、数据边界、平台适配和安装说明；若成为活动项目的必经步骤，再提升为核心 SOP。
6. 添加数据前检查公开范围、来源条款、数据质量和公式注入风险；客户业务资料和个人资料不能进入公开仓库。

## 10. 可直接用于新对话的提示词

```text
请继续开发 GitHub 仓库 https://github.com/Jaywang1013/Awesome-Himice-SOP-skill 。
先阅读 docs/project-handoff.md、AGENTS.md、README.md，以及本次目标 Skill/项目的 README 和 SKILL.md。

仓库是 Himice 本地优先的活动会展 SOP Skill 库，需同时维护 Codex、DSH、Claude Code 三端；真实客户资料、发票、录音、税号、联系人和内部评分不得上传云端或提交公开仓库。业务规则变动必须同步三端，并保留模板格式、公式与数据验证。

本次要继续开发的内容是：<在这里填写具体需求>。
请先检查当前仓库状态与相关模板/数据，再实施、运行 bash scripts/validate.sh 和 git diff --check，最后提交并推送 main。
```

