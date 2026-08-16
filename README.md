# Awesome Himice SOP Skill

Himice 内部 SOP Skill 合集，同时提供 OpenAI Codex 与 DeepSeek Harness（DSH）两套可独立部署的版本。两套目录均包含同样的三项能力，但遵循各自的发现与调用规范。

## 目录

```text
.
├── openai-codex/                         # 已有 Codex Skill 版本
│   ├── Himice-budget-process/
│   ├── Himice-OfficeCLI/
│   ├── Himice-vibevoice/
│   └── himice-operation-expense-reimbursement/
└── deepseek-harness/                      # 原生 DSH Skill 版本
    └── skills/
        ├── himice-budget-process/
        ├── himice-officecli/
        ├── himice-vibevoice/
        └── himice-operation-expense-reimbursement/
```

| 功能 | 内容 |
| --- | --- |
| `himice-budget-process` | 从客户报价、供应商成本与模板生成项目预算表，执行表头、代付、操作费用、现金项与公式核验。 |
| `himice-officecli` | 使用 OfficeCLI 安全编辑、校验和渲染 Excel、Word、PowerPoint。 |
| `himice-vibevoice` | 使用 VibeVoice-ASR 转写已获授权的会议/展览录音，结合会展和厦门术语生成纪要与行动项。 |
| `himice-operation-expense-reimbursement` | 整理实际操作费用报销资料，核对预算差异、重复付款风险、缺凭证与待财务确认项。 |

## 安装 Codex 版本

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

cp -R openai-codex/Himice-budget-process ~/.codex/skills/himice-budget-process
cp -R openai-codex/Himice-OfficeCLI ~/.codex/skills/himice-officecli
cp -R openai-codex/Himice-vibevoice ~/.codex/skills/himice-vibevoice
cp -R openai-codex/himice-operation-expense-reimbursement ~/.codex/skills/himice-operation-expense-reimbursement
```

重新打开 Codex 后可调用 `$himice-budget-process`、`$himice-officecli`、`$himice-vibevoice`、`$himice-operation-expense-reimbursement`。

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

## 维护

同一规则变更应同时更新两套目录。预算标准更新到两侧 `himice-budget-process/references/budget-rules.md`；操作费用报销标准更新到两侧 `himice-operation-expense-reimbursement/references/operation-expense-rules.md`；会展/客户/场地热词更新到两侧 `himice-vibevoice/references/meeting-glossary.md`。更新上游工具前，先核对其版本和许可变化。
