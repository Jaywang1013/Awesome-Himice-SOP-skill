# Awesome Himice SOP Skill

Himice 内部 SOP Skill 合集，同时提供 OpenAI Codex 与 DeepSeek Harness（DSH）两套可独立部署的版本。两套目录均包含同样的五项能力，但遵循各自的发现与调用规范。

## 目录

```text
.
├── openai-codex/                         # 已有 Codex Skill 版本
│   ├── Himice-budget-process/
│   ├── Himice-OfficeCLI/
│   ├── Himice-vibevoice/
│   ├── Himice-Operating-expense-reimbursement-process/
│   └── Himice-advance-fund-application-process/
└── deepseek-harness/                      # 原生 DSH Skill 版本
    └── skills/
        ├── himice-budget-process/
        ├── himice-officecli/
        ├── himice-vibevoice/
        ├── himice-operating-expense-reimbursement-process/
        └── himice-advance-fund-application-process/
```

| 功能 | 内容 |
| --- | --- |
| `himice-budget-process` | 从客户报价、供应商成本与模板生成项目预算表，执行表头、代付、操作费用、现金项与公式核验。 |
| `himice-officecli` | 使用 OfficeCLI 安全编辑、校验和渲染 Excel、Word、PowerPoint。 |
| `himice-vibevoice` | 使用 VibeVoice-ASR 转写已获授权的会议/展览录音，结合会展和厦门术语生成纪要与行动项。 |
| `himice-operating-expense-reimbursement-process` | 使用内置的单表《项目操作收支明细表》，将发票、行程单、支付截图与经手人自动录入；逐笔拆分滴滴/货拉拉行程、按路线写备注、勾选实际发票并核对付款路径与合计。 |
| `himice-advance-fund-application-process` | 使用内置《预估协作人审批表》（内部亦称备用金申请表），从预算表生成预计营业额、毛利率、毛利润和活动信息，并本地填写客户名称、税号与报账人。 |

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

## 上游来源与边界

- DSH 版本遵循 [DeepSeek Harness 官方 Skill 目录规范](https://github.com/deepseek-ai/deepseek-harness)：原生目录为 `~/.dsh/skills/<skill>/SKILL.md`，仅支持一层 Skill 发现。DSH 当前处于开发者预览，后续可能有不兼容变更。
- `himice-officecli` 基于 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 的工作流，不包含其源码或二进制；请按上游说明单独安装。
- `himice-vibevoice` 基于 [microsoft/VibeVoice](https://github.com/microsoft/VibeVoice) 的 ASR 能力，不包含其模型或源码；请遵循上游安装说明与 MIT 许可证。
- 预算模板、客户报价、录音和人员信息仅供已获授权的公司同事处理。不要将未公开资料上传至未获授权的外部服务。
- `himice-advance-fund-application-process` 中的客户名称、纳税人识别号、联系人和原始预算表只允许在本地处理；仓库仅保存空白模板和通用规则，禁止上传任何真实客户资料。

## 维护

同一规则变更应同时更新两套目录。预算标准更新到两侧 `himice-budget-process/references/budget-rules.md`；操作费用报销标准更新到两侧 `himice-operating-expense-reimbursement-process/references/operation-expense-rules.md`，并同步两侧 `assets/【模板】项目操作收支明细表.xlsx`；备用金申请规则更新到两侧 `himice-advance-fund-application-process/references/advance-fund-rules.md`，并同步两侧空白审批表模板；会展/客户/场地热词更新到两侧 `himice-vibevoice/references/meeting-glossary.md`。更新上游工具前，先核对其版本和许可变化。
