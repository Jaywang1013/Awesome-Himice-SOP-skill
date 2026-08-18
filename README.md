# Awesome Himice SOP Skill

<p align="center">
  <img src="assets/himice-hero.png" alt="Awesome Himice SOP Skill" width="100%">
</p>

Himice 内部 SOP Skill 合集，同时提供 OpenAI Codex、DeepSeek Harness（DSH）与 Claude Code 三套可独立部署的版本。三套目录均包含同样的五项能力，但遵循各自的发现与调用规范。另附两个 DSH 通用能力项目（文件识别、图片识别），随 DeepSeek 版本一起部署。

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
│       └── dsh-vision-router/             # 图片识别
├── claude-code/                            # Claude Code 专用 Skill 版本
│   └── skills/
│       ├── himice-budget-process/
│       ├── himice-officecli/
│       ├── himice-vibevoice/
│       ├── himice-operating-expense-reimbursement-process/
│       └── himice-advance-fund-application-process/
├── dsh-file-upload/                        # 文件识别 Skill
└── dsh-vision-router/                      # 图片识别 Skill
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

随 `deepseek-harness/skills/*` 一并部署的两个通用能力（文件识别 `dsh-file-upload`、图片识别 `dsh-vision-router`）是**上游插件的能力封装**：SKILL.md 随克隆包自动就位，但对应的插件本体需单独安装一次（两者均一行命令，详见各 SKILL.md）：

```bash
dsh plugin --profile web add dsh-file-upload     # 文件上传 + 文档识别（MarkItDown）
dsh plugin --profile web add dsh-vision-router   # 图片粘贴即识别（免费视觉链）
# 重启 dsh web 后生效
```

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
- `himice-officecli` 基于 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 的工作流，不包含其源码或二进制；请按上游说明单独安装。
- `himice-vibevoice` 基于 [microsoft/VibeVoice](https://github.com/microsoft/VibeVoice) 的 ASR 能力，不包含其模型或源码；请遵循上游安装说明与 MIT 许可证。
- `dsh-file-upload` 封装自 [HongMing-Huang/dsh-file-upload](https://github.com/HongMing-Huang/dsh-file-upload)（MIT，DSH 官方精选插件），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add dsh-file-upload` 安装。
- `dsh-vision-router` 封装自 [ysr666/dsh-vision-router](https://github.com/ysr666/dsh-vision-router)（MIT，DSH 官方精选插件），不包含上游源码或二进制；插件本体用 `dsh plugin --profile web add dsh-vision-router` 安装。
- 预算模板、客户报价、录音和人员信息仅供已获授权的公司同事处理。不要将未公开资料上传至未获授权的外部服务。
- `himice-advance-fund-application-process` 中的客户名称、纳税人识别号、联系人和原始预算表只允许在本地处理；仓库仅保存空白模板和通用规则，禁止上传任何真实客户资料。

## 维护

同一规则变更应同时更新三套目录。预算标准更新到各版本 `himice-budget-process/references/budget-rules.md`；操作费用报销标准更新到各版本 `himice-operating-expense-reimbursement-process/references/operation-expense-rules.md`，并同步各版本 `assets/【模板】项目操作收支明细表.xlsx`；备用金申请规则更新到各版本 `himice-advance-fund-application-process/references/advance-fund-rules.md`，并同步各版本空白审批表模板；会展/客户/场地热词更新到各版本 `himice-vibevoice/references/meeting-glossary.md`。OfficeCLI 安装引导与首次自检规则更新到各版本 `himice-officecli/SKILL.md`。`dsh-file-upload` 与 `dsh-vision-router` 的封装说明更新到各自的 SKILL.md，并同步 `deepseek-harness/skills/` 对应目录。更新上游工具前，先核对其版本和许可变化。
