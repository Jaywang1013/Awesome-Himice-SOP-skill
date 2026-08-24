# Awesome Himice SOP Skill

<p align="center">
  <img src="assets/himice-hero.png" alt="Awesome Himice SOP Skill" width="100%">
</p>

Himice 内部 SOP Skill 合集，同时提供 OpenAI Codex、DeepSeek Harness（DSH）与 Claude Code 三套可独立部署的版本。三套目录均包含同样的五项能力，但遵循各自的发现与调用规范。另附 DSH 通用能力项目、跨 Agent 企业办公能力项目，以及不改变现有 Skill 设计逻辑的企业 Agent 平台 Blueprint。

## 目录

```text
.
├── openai-codex/                         # 已有 Codex Skill 版本
│   ├── Himice-budget-process/
│   ├── Himice-OfficeCLI/
│   ├── Himice-vibevoice/
│   ├── Himice-Operating-expense-reimbursement-process/
│   └── Himice-advance-fund-application-process/
├── deepseek-harness/                      # 原生 DSH Skill 版本
│   └── skills/
│       ├── himice-budget-process/
│       ├── himice-officecli/
│       ├── himice-vibevoice/
│       ├── himice-operating-expense-reimbursement-process/
│       ├── himice-advance-fund-application-process/
│       ├── dsh-file-upload/               # 文件识别
│       ├── dsh-vision-router/             # 图片识别
│       ├── dsh-dingtalk/                  # 钉钉群通知
│       ├── dsh-notifier/                  # 统一通知推送
│       ├── open-design/                   # 创意设计工作台
│       └── pptfast/                       # PPT 生成
├── claude-code/                            # Claude Code 专用 Skill 版本
│   └── skills/
│       ├── himice-budget-process/
│       ├── himice-officecli/
│       ├── himice-vibevoice/
│       ├── himice-operating-expense-reimbursement-process/
│       └── himice-advance-fund-application-process/
├── dsh-file-upload/                        # 文件识别 Skill
├── dsh-vision-router/                      # 图片识别 Skill
├── dingtalk-office/                        # 钉钉办公（dsh-dingtalk + dsh-notifier）
├── open-design/                            # 创意设计 Skill
├── pptfast/                                # PPT 生成 Skill
└── projects/
    ├── enterprise-productivity-stack/      # Codex / DSH / Claude Code 企业办公能力矩阵
    └── Himice-agent-platform-blueprint/    # 架构、选型、部署与 Skill 接口规范
```

| 功能 | 内容 |
| --- | --- |
| `himice-budget-process` | 从客户报价、供应商成本与模板生成项目预算表，执行表头、代付、操作费用、现金项与公式核验。 |
| `himice-officecli` | 使用 OfficeCLI 安全编辑、校验和渲染 Excel、Word、PowerPoint。克隆后先按引导安装 OfficeCLI，首次调用先自检、跑通后再处理。 |
| `himice-vibevoice` | 使用 VibeVoice-ASR 转写已获授权的会议/展览录音，结合会展和厦门术语生成纪要与行动项。 |
| `himice-operating-expense-reimbursement-process` | 使用内置的单表《项目操作收支明细表》，将发票、行程单、支付截图与经手人自动录入；逐笔拆分滴滴/货拉拉行程、按路线写备注、勾选实际发票并核对付款路径与合计。 |
| `himice-advance-fund-application-process` | 使用内置《预估协作人审批表》（内部亦称备用金申请表），从预算表生成预计营业额、毛利率、毛利润和活动信息，并本地填写客户名称、税号与报账人。 |
| `dsh-file-upload` | 文件识别：上传并识别任意文件（PDF/Word/Excel/PPT/图片/压缩包等），内置 MarkItDown 文档转 Markdown，供模型用 `read_document` 读取。封装自 [HongMing-Huang/dsh-file-upload](https://github.com/HongMing-Huang/dsh-file-upload)。 |
| `dsh-vision-router` | 图片识别：粘贴/上传图片即可看图问答、OCR、元素定位、像素对比、取色、抠图、SVG 矢量化。封装自 [ysr666/dsh-vision-router](https://github.com/ysr666/dsh-vision-router)。 |
| `dsh-dingtalk` | 钉钉办公·群通知：agent 向钉钉群推送 Markdown/纯文本消息（加签安全、零依赖），对接钉钉项目群/执行群。封装自 [STARDUSTLC666/dsh-dingtalk](https://github.com/STARDUSTLC666/dsh-dingtalk)。 |
| `dsh-notifier` | 钉钉办公·统一通知：27 渠道（钉钉/飞书/企业微信/Telegram 等），回合结束/等待确认/出错自动推送，手机可远程审批与遥控。封装自 [THEWOLFWALKER/dsh-notifier](https://github.com/THEWOLFWALKER/dsh-notifier)。 |
| `open-design` | 创意设计：AI 生成活动主视觉/海报/H5 原型/提案 deck/视频分镜，HTML/PDF/PPTX/MP4 导出，支持品牌 DESIGN.md 设计系统。封装自 [nexu-io/open-design](https://github.com/nexu-io/open-design)。 |
| `pptfast` | PPT 生成：从大纲/文档生成原生可编辑 PPTX，17 种主题，可抽取公司 PPT 品牌配色，本地渲染无 API key。封装自 [liustack/pptfast](https://github.com/liustack/pptfast)。 |
| [`enterprise-productivity-stack`](projects/enterprise-productivity-stack/) | 独立子项目：为 Codex、DSH、Claude Code 分别提供办公文件、文件读取、在线办公、通知审批、设计提案、企业知识库六项 Skill。 |
| [`Himice-agent-platform-blueprint`](projects/Himice-agent-platform-blueprint/) | 企业 Agent 参考项目：记录分层架构、框架选型、部署路线、钉钉/千问接入边界、安全治理及现有 Skills 的统一接口。 |

## 企业 Agent 平台 Blueprint

详见 [`projects/Himice-agent-platform-blueprint/`](projects/Himice-agent-platform-blueprint/)。Blueprint 不复制 Microsoft Agent Framework、OpenAI Agents SDK、Dify、RAGFlow 等上游源码，也不把 Himice SOP 绑定到单一模型；现有 Skills 继续作为业务规则唯一来源。

钉钉接入优先参考官方 [DingTalk Workspace CLI](https://github.com/DingTalk-Real-AI/dingtalk-workspace-cli) 和企业机器人 Stream 模式。千问办公会员可降低同事使用门槛，但会员、百炼/API 调用和钉钉开放平台权限是三组独立授权，必须按公司合作合同和管理员控制台分别确认。

## 跨 Agent 企业办公能力项目

详见 [`projects/enterprise-productivity-stack/`](projects/enterprise-productivity-stack/)。其中 [`anthropic-document-skills/`](projects/enterprise-productivity-stack/anthropic-document-skills/) 直接挂接 Anthropic 官方 `docx`、`pdf`、`pptx`、`xlsx` 仓库入口；不复制上游代码。

```bash
# 按平台任选一套部署
cp -R projects/enterprise-productivity-stack/codex/skills/* ~/.codex/skills/
cp -R projects/enterprise-productivity-stack/deepseek-harness/skills/* ~/.dsh/skills/
cp -R projects/enterprise-productivity-stack/claude-code/skills/* ~/.claude/skills/
```

## 安装 Codex 版本

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

cp -R openai-codex/Himice-budget-process ~/.codex/skills/himice-budget-process
cp -R openai-codex/Himice-OfficeCLI ~/.codex/skills/himice-officecli
cp -R openai-codex/Himice-vibevoice ~/.codex/skills/himice-vibevoice
cp -R openai-codex/Himice-Operating-expense-reimbursement-process ~/.codex/skills/himice-operating-expense-reimbursement-process
cp -R openai-codex/Himice-advance-fund-application-process ~/.codex/skills/himice-advance-fund-application-process
```

重新打开 Codex 后可调用 `$himice-budget-process`、`$himice-officecli`、`$himice-vibevoice`、`$himice-operating-expense-reimbursement-process`、`$himice-advance-fund-application-process`。

## 安装 DeepSeek Harness（DSH）版本

先安装并启动官方 DSH；官方说明允许通过 `npx @deepseek-ai/dsh web` 启动。然后复制 DSH 原生 Skill 目录：

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

mkdir -p ~/.dsh/skills
cp -R deepseek-harness/skills/* ~/.dsh/skills/
npx @deepseek-ai/dsh web
```

DSH 会自动发现 `~/.dsh/skills/<skill>/SKILL.md`。在 DSH 对话中直接写“使用 `himice-budget-process` 帮我把这份客户报价填进预算模板”即可；若表头信息或附件缺失，Skill 会先请求缺项。

随 `deepseek-harness/skills/*` 一并部署的通用能力（文件识别、图片识别、钉钉办公、创意设计、PPT 生成）都是**上游插件的能力封装**：SKILL.md 随克隆包自动就位，但对应的插件本体需单独安装一次（均为一行命令，详见各 SKILL.md）：

```bash
dsh plugin --profile web add dsh-file-upload     # 文件上传 + 文档识别（MarkItDown）
dsh plugin --profile web add dsh-vision-router   # 图片粘贴即识别（免费视觉链）
dsh plugin --profile web add dsh-dingtalk        # 钉钉群通知（需配置群机器人 webhook）
dsh plugin --profile web add dsh-notifier        # 统一通知推送（27 渠道，需配置渠道凭据）
dsh plugin --profile web add pptfast             # PPT 生成（需 Node ≥ 22.19）
# 重启 dsh web 后生效
```

`open-design` 是桌面应用（非 dsh 插件）：从 https://github.com/nexu-io/open-design/releases 下载桌面版，在 Settings → Execution mode 中把 `dsh` 添加为运行时即可。

> 小白一键部署：克隆 → `cp -R deepseek-harness/skills/* ~/.dsh/skills/` → 上面 5 条插件命令 → 重启 dsh web，即获得完整办公能力。

## 安装 Claude Code 版本

Claude Code 将个人 Skill 发现为 `~/.claude/skills/<skill>/SKILL.md`。克隆仓库后执行：

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

mkdir -p ~/.claude/skills
cp -R claude-code/skills/* ~/.claude/skills/
claude
```

在 Claude Code 中显式调用 `/himice-budget-process`、`/himice-officecli`、`/himice-vibevoice`、`/himice-operating-expense-reimbursement-process` 或 `/himice-advance-fund-application-process`。本版本特意设为手动调用，避免在包含客户资料、发票、录音或税号的工作中被自动触发。若只希望项目内可用，可将某个 Skill 放到项目根目录的 `.claude/skills/`。

## 配置备用金申请表的本地默认信息

`himice-advance-fund-application-process` 每次调用前都会要求选择“使用默认信息 / 有修改 / 更改默认信息”。厦门公司项目二部的非个人默认项已写在三套版本各自的 `references/department-defaults.example.md`；每位同事部署后都应复制为 `department-defaults.local.md`，再仅在本机补全联系人和人员信息。例如 Codex：

```bash
cp ~/.codex/skills/himice-advance-fund-application-process/references/department-defaults.example.md \
  ~/.codex/skills/himice-advance-fund-application-process/references/department-defaults.local.md
```

DSH 和 Claude Code 仅需将上例中的 `~/.codex/skills` 分别替换为 `~/.dsh/skills`、`~/.claude/skills`。`department-defaults.local.md` 已被 Git 忽略；它可包含联系人、员工姓名和比例，但禁止上传、提交或同步到云端。选择“更改默认信息”时，Skill 只更新这份本地文件，新部门（如项目一部、海口公司创意部）会成为后续确认时显示的默认部门。

## 上游来源与边界

- DSH 版本遵循 [DeepSeek Harness 官方 Skill 目录规范](https://github.com/deepseek-ai/deepseek-harness)：原生目录为 `~/.dsh/skills/<skill>/SKILL.md`，仅支持一层 Skill 发现。DSH 当前处于开发者预览，后续可能有不兼容变更。
- Claude Code 版本遵循 [Claude Code Skills 官方规范](https://code.claude.com/docs/en/slash-commands)：个人目录为 `~/.claude/skills/<skill>/SKILL.md`，项目目录为 `.claude/skills/<skill>/SKILL.md`；Skill 中使用 `${CLAUDE_SKILL_DIR}` 定位内置模板与规则文件。
- Anthropic 官方 [Agent Skills 仓库](https://github.com/anthropics/skills) 中的 `docx`、`pdf`、`pptx`、`xlsx` 为 source-available、并非开源；本仓库仅链接并编排其能力，使用时遵循各目录 `LICENSE.txt`。
- `himice-officecli` 基于 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 的工作流，不包含其源码或二进制；请按上游说明单独安装。
- `himice-vibevoice` 基于 [microsoft/VibeVoice](https://github.com/microsoft/VibeVoice) 的 ASR 能力，不包含其模型或源码；请遵循上游安装说明与 MIT 许可证。
- `dsh-file-upload` 封装自 [HongMing-Huang/dsh-file-upload](https://github.com/HongMing-Huang/dsh-file-upload)（MIT，DSH 官方精选插件），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add dsh-file-upload` 安装。
- `dsh-vision-router` 封装自 [ysr666/dsh-vision-router](https://github.com/ysr666/dsh-vision-router)（MIT，DSH 官方精选插件），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add dsh-vision-router` 安装。
- `dsh-dingtalk` 封装自 [STARDUSTLC666/dsh-dingtalk](https://github.com/STARDUSTLC666/dsh-dingtalk)（MIT），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add dsh-dingtalk` 安装，需在钉钉群配置自定义机器人。
- `dsh-notifier` 封装自 [THEWOLFWALKER/dsh-notifier](https://github.com/THEWOLFWALKER/dsh-notifier)（MIT），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add dsh-notifier` 安装，渠道凭据在 `cordis.patch.yml` 配置。
- `open-design` 封装自 [nexu-io/open-design](https://github.com/nexu-io/open-design)（Apache-2.0），是本地优先桌面应用，不包含上游源码或二进制；请按上游 QUICKSTART 安装桌面版并在 Settings 中挂接 dsh 运行时。
- `pptfast` 封装自 [liustack/pptfast](https://github.com/liustack/pptfast)（MIT），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add pptfast` 安装，需 Node ≥ 22.19。
- 预算模板、客户报价、录音和人员信息仅供已获授权的公司同事处理。不要将未公开资料上传至未获授权的外部服务。
- `himice-advance-fund-application-process` 中的客户名称、纳税人识别号、联系人和原始预算表只允许在本地处理；仓库仅保存空白模板和通用规则，禁止上传任何真实客户资料。

## 维护

同一规则变更应同时更新三套目录。预算标准更新到各版本 `himice-budget-process/references/budget-rules.md`；操作费用报销标准更新到各版本 `himice-operating-expense-reimbursement-process/references/operation-expense-rules.md`，并同步各版本 `assets/【模板】项目操作收支明细表.xlsx`；备用金申请规则更新到各版本 `himice-advance-fund-application-process/references/advance-fund-rules.md`，并同步各版本空白审批表模板；会展/客户/场地热词更新到各版本 `himice-vibevoice/references/meeting-glossary.md`。OfficeCLI 安装引导与首次自检规则更新到各版本 `himice-officecli/SKILL.md`。各通用能力的封装说明更新到各自的 SKILL.md（`dsh-file-upload/`、`dsh-vision-router/`、`dingtalk-office/`、`open-design/`、`pptfast/`），并同步 `deepseek-harness/skills/` 对应目录。企业办公能力矩阵的规则变更需同步 `projects/enterprise-productivity-stack/` 下三套同名 Skill；平台边界、选型、部署或统一接口变化更新 `projects/Himice-agent-platform-blueprint/`。更新上游工具前，先核对其版本和许可变化。
