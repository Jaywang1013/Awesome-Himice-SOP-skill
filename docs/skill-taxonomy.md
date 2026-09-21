# Himice Skill 分类与收敛方案

本仓库同时服务业务流程和多个运行环境。`SKILL.md` 文件数量不能直接代表业务能力数量：同一个业务能力可能有 Codex、Claude Code、DeepSeek Harness 三份运行时适配；一个工具集成也可能被不同项目包重新包装。

## 先看结论

当前 `origin/main` 有 56 个 `SKILL.md`，建议按四层理解：

| 层级 | 目录 | 作用 | 是否算新的业务 Skill |
| --- | --- | --- | --- |
| 业务规范层 | `skills/all-department/`、`skills/company-common/`、`skills/departments/` | 描述 Himice 的工作方法、输入、边界、交付和验收；是唯一事实来源 | 是 |
| 运行时适配层 | `skills/codex/`、`skills/claude-code/skills/`、`skills/deepseek-harness/skills/` | 把业务规范翻译成某个平台能直接调用的版本 | 否 |
| 工具/连接器层 | `integrations/` | 文件上传、办公编辑、通知、视觉、设计和演示等可复用工具能力 | 否，除非它本身形成完整业务流程 |
| 项目包/数据层 | `projects/` | 某个专项项目的资料、数据集、知识库和跨平台交付包 | 否；属于项目资产 |

因此，今后不要把每一份运行时副本都当成一项新 SOP，也不要把插件能力和业务流程放到同一张部门清单里。

## 按项目生命周期看业务能力

下面是给同事使用的业务导航，不是物理目录；一个业务 Skill 只保留一个 canonical 目录。

| 阶段 | 业务问题 | 当前或应保留的业务 Skill | 备注 |
| --- | --- | --- | --- |
| 投标、寻源 | 解析招标条件、寻找供应商、复核企业资质 | `himice-tender-simulation`、`himice-mice-bid-directory` | 目前主要藏在 DSH/项目包，后续应分别建立投资部或公司通用 canonical 入口 |
| 方案、创意 | 定位、传播、品牌片、活动视觉延展 | `himice-integrated-marketing-sop`、`himice-brand-commercial-director-sop`、`himice-event-material-prompt-sop` | 已经是公司通用业务 Skill；`open-design` 和 `pptfast` 是工具层 |
| 预算、审批 | 报价转预算、协作人分配、备用金申请 | `himice-budget-sop`、`himice-collaborator-allocation-sop`、待补 canonical 的 `himice-advance-fund-application-process` | `budget-process` 和 `advance-fund...` 的平台副本不应被误认为独立业务流程 |
| 执行、办公 | 创建/读取 Office 文件、在线协作、批量接收资料 | 待补一个办公文件路由入口；底层使用 `himice-officecli`、`himice-office-files`、`himice-online-office`、`dsh-univer-office`、`dsh-file-upload` | 工具选择应由运行环境和文件类型决定，不进入部门业务清单 |
| 结算、报销 | 整理票据、核对实际成本、将实际结算融入中标报价 | `himice-expense-reimbursement-sop`；另有待合并的 `himice-settlement-quote-integration-sop` 分支 | 报销、实际成本更新和中标报价融入要保持边界，不合并成万能财务 Skill |
| 会议、复盘 | 录音转写、纪要、行动项、待确认事项 | 待补 canonical 的 `himice-vibevoice` | 运行时版本已有三份，业务边界基本明确 |
| 通知、审批 | 发送消息、请求确认、记录审批状态 | 待补一个通知/审批 canonical 入口 | `dsh-dingtalk`、`dsh-notifier` 是连接器；`himice-notification-approval` 是项目包中的跨平台业务包装 |

## 当前重复与边界问题

### 1. 同一业务能力的三平台复制

以下名称在 Codex、Claude Code、DeepSeek Harness 各有一份：

- `himice-advance-fund-application-process`
- `himice-budget-process`
- `himice-officecli`
- `himice-operating-expense-reimbursement-process`
- `himice-vibevoice`

这五组应被视为“一个业务能力 + 三个适配包”。修改规则时先改 canonical，再同步适配；不能只改某个平台版本。

### 2. 报销存在两套命名和边界

- `skills/all-department/himice-expense-reimbursement-sop`：公司业务入口，覆盖票据、支付凭证、行程单、实际成本和决算更新。
- `himice-operating-expense-reimbursement-process`：平台目录中的项目操作费用录入流程。

建议将后者降级为前者的运行时适配或子流程，避免同事不知道该调用哪一个。两者都不应承担客户报价或中标报价融入。

### 3. 预算存在 SOP 与平台流程两套命名

- `himice-budget-sop`：当前 canonical，描述业务规则和模板验收。
- `himice-budget-process`：Codex/Claude/DSH 的运行时版本。

后者建议统一命名为适配包，而不是继续增加新的预算业务入口。

### 4. 设计、演示和办公工具混入业务目录

`open-design`、`pptfast`、`himice-officecli`、`dsh-univer-office`、`dsh-file-upload`、`dsh-vision-router` 主要解决“用什么工具完成任务”，不是“公司如何完成业务”。它们应留在 `integrations/` 或运行时适配层，并由业务 Skill 按需引用。

### 5. 项目包与公共 SOP 混在同一认知层

`projects/enterprise-productivity-stack/` 是跨平台能力打包项目，`projects/mice-bid-enterprise-directory/` 是企业名录与供应商寻源数据项目。它们可以包含 `SKILL.md`，但不应直接出现在“公司业务 Skill 总览”里；总览只列 canonical 业务入口，并链接到项目包的实现说明。

## 推荐的长期目录语义

不建议立即大规模移动目录，以免破坏安装脚本和历史链接；先统一语义，再分批迁移：

```text
skills/
├── all-department/          # 业务规范：四个部门都能直接用
├── company-common/          # 业务规范：跨两个及以上部门
├── departments/             # 业务规范：部门专属与部门导航
├── codex/                   # Codex 运行时适配，不新增业务事实
├── claude-code/skills/      # Claude Code 运行时适配
└── deepseek-harness/skills/ # DSH 运行时适配

integrations/                # 工具、连接器、插件封装
projects/                    # 专项项目、数据集、跨平台项目包
```

## 收敛顺序

1. 先建立一份业务 catalog：每个业务能力只有一个 ID、一个 canonical 路径，并列出可用运行时适配。
2. 把 `advance-fund`、`vibevoice`、`tender-simulation`、`mice-bid-directory`、通知/审批补齐 canonical 入口；在此之前只标为“平台/项目能力”，不在部门页重复宣传。
3. 将 `budget-process`、`operating-expense-reimbursement-process` 等平台副本改成薄适配：保留工具调用差异，删除重复业务规则，并在文件头注明 canonical 来源。
4. 统一办公、设计、通知等工具的 integrations 入口；业务 Skill 只引用工具能力，不复制工具说明。
5. 最后再考虑目录迁移或安装脚本重写；迁移前先验证所有本地安装路径、GitHub 链接和 CI。

## 新 Skill 的判断规则

- 如果交付物是报价、预算、报销、投标分析、纪要等公司工作成果，先建 canonical 业务 Skill。
- 如果交付物是“调用某个插件/CLI/Connector”，放在 `integrations/` 或对应运行时适配目录。
- 如果内容依赖一个专项数据集、企业名录或项目蓝图，放在 `projects/`。
- 如果只是同一业务流程在 Codex、Claude Code、DSH 的写法不同，新增适配包，不新增业务 Skill。
- 新建或调整 canonical Skill 时，必须同步脱敏 fixture、验收清单、分类索引和适用部门导航。
