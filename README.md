# Awesome Himice SOP Skills

<p align="center">
  <img src="assets/himice-hero.png" alt="Awesome Himice SOP Skills" width="100%">
</p>

面向 Himice 同事的本地优先活动执行 Skill 库。它将项目预算、备用金申请、操作费用报销、会议转录和 Office 文件处理，分别适配到 OpenAI Codex、DeepSeek Harness（DSH）与 Claude Code。

客户报价、发票、录音、税号、联系人和员工信息默认只在本地处理。仓库只保存空白模板、通用规则和上游工具说明。

## 快速开始

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

# 先预览，再安装核心 SOP Skills（任选一个平台）
bash scripts/install.sh --platform codex --bundle core --dry-run
bash scripts/install.sh --platform codex --bundle core

# DSH 或 Claude Code
bash scripts/install.sh --platform dsh --bundle core
bash scripts/install.sh --platform claude-code --bundle core
```

安装脚本不会覆盖已有本地 Skill；同事更新前请先备份或手动移除旧目录。重新启动所用 Agent 后，即可调用对应的 `himice-*` Skill。

若还需 Excel/Word/PPT/PDF、文件读取、在线办公、通知审批、设计提案和企业知识库能力：

```bash
bash scripts/install.sh --platform codex --bundle productivity
# 或 --bundle all 同时安装核心 SOP 与企业办公能力
```

## 核心 SOP Skills

| Skill | 场景 | 主要输出 |
| --- | --- | --- |
| `himice-budget-process` | 将客户报价和供应商成本填入预算模板 | 项目预算表、公式与金额核验 |
| `himice-advance-fund-application-process` | 从预算表生成备用金申请 | 预估协作人审批表/备用金申请表 |
| `himice-operating-expense-reimbursement-process` | 汇总发票、行程单、支付截图与经手人 | 项目操作收支明细表 |
| `himice-vibevoice` | 转写已获授权的会展/会议录音 | 转写、纪要、行动项、待确认项 |
| `himice-officecli` | 安全读取、修改、校验和渲染 Office 文件 | 保持格式与公式的 Office 文件 |

DSH 的核心安装包还包括文件识别、图片识别、钉钉通知、设计工作台和 PPT 生成等上游插件包装；详见 [integrations/](integrations/)。

## 仓库结构

```text
.
├── skills/                           # 可部署的核心 SOP Skills
│   ├── codex/                        # ~/.codex/skills/<skill>/
│   ├── deepseek-harness/skills/      # ~/.dsh/skills/<skill>/
│   └── claude-code/skills/           # ~/.claude/skills/<skill>/
├── integrations/                     # 上游插件与外部办公工具的接入说明
│   ├── deepseek-harness/
│   ├── dingtalk/
│   ├── design/
│   └── presentations/
├── projects/                         # 可选能力项目，不影响核心 SOP
│   ├── enterprise-productivity-stack/
│   └── himice-agent-platform-blueprint/
├── scripts/                          # 安装与校验脚本
├── docs/                             # 维护与公开仓库安全规范
├── AGENTS.md                         # 给维护者与编码 Agent 的仓库约定
└── assets/                           # README 展示素材
```

目录采用 Agent Skills 的通用组织方式：每个 Skill 是一个独立文件夹，必含 `SKILL.md`，并按需包含 `agents/`、`references/`、`assets/` 或 `scripts/`。详细的处理规则不堆在入口文件中，而由 `SKILL.md` 按需指向 reference，避免无关上下文进入每次调用。

## 平台与安装位置

| 平台 | 源目录 | 本地安装目录 | 调用方式 |
| --- | --- | --- | --- |
| Codex | `skills/codex/` | `~/.codex/skills/` | `$himice-budget-process` 等 |
| DSH | `skills/deepseek-harness/skills/` | `~/.dsh/skills/` | 直接描述任务或点名 Skill |
| Claude Code | `skills/claude-code/skills/` | `~/.claude/skills/` | `/himice-budget-process` 等 |

企业办公能力矩阵位于 [`projects/enterprise-productivity-stack/`](projects/enterprise-productivity-stack/)，覆盖三平台的办公文件、附件读取、在线办公、通知审批、设计提案与企业知识库六类能力。

## DSH 上游插件

DSH 的 Skill 说明会随本仓库安装；下列插件本体仍需按上游说明单独安装、配置凭据并重启 DSH：

```bash
dsh plugin --profile web add dsh-file-upload
dsh plugin --profile web add dsh-vision-router
dsh plugin --profile web add dsh-dingtalk
dsh plugin --profile web add dsh-notifier
dsh plugin --profile web add pptfast
```

`open-design` 是桌面应用，不是 DSH 内置插件。请从其官方项目安装后，再将 DSH 配置为可用运行时。安装前请阅读对应 [integration guide](integrations/)。

## 企业 Agent 与钉钉

[`projects/himice-agent-platform-blueprint/`](projects/himice-agent-platform-blueprint/) 记录现有 Skills 如何连接 Codex、DSH、Claude Code、千问和钉钉：包括架构、选型、分阶段部署、统一接口和安全治理。

千问办公会员、千问 API/百炼额度与钉钉开放平台权限是三种独立授权。会员可降低员工的 AI 办公使用门槛，但不会自动授予钉钉机器人、组织数据或生产 API 权限。钉钉接入优先参考官方 [DingTalk Workspace CLI](https://github.com/DingTalk-Real-AI/dingtalk-workspace-cli) 与企业机器人 Stream 模式；先在脱敏测试群试点，再处理真实业务资料。

## 上游与使用边界

- `himice-officecli` 参考 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI)，不包含其源码或二进制。
- `himice-vibevoice` 参考 [microsoft/VibeVoice](https://github.com/microsoft/VibeVoice)，不包含其模型或源码。
- DSH 文件、视觉、钉钉通知、设计和 PPT 能力都只是上游项目的接入说明；具体来源见 [`integrations/`](integrations/)。
- Anthropic 的 `docx`、`xlsx`、`pptx`、`pdf` 能力入口见 [`projects/enterprise-productivity-stack/anthropic-document-skills/`](projects/enterprise-productivity-stack/anthropic-document-skills/)，不在本仓库复制上游内容。
- 本仓库未声明开放源码许可。公开可见不等于可任意再发布；公司内部使用和第三方内容使用均应遵循公司授权及各上游许可证。

## 维护与安全

- 维护规则见 [docs/maintaining-skills.md](docs/maintaining-skills.md)。
- 公开仓库安全边界见 [docs/public-repository-safety.md](docs/public-repository-safety.md)。
- 提交前运行：`bash scripts/validate.sh && git diff --check`。
- 每次修改业务规则、内置模板或金额处理时，必须同步三套运行时版本，并使用脱敏样例进行核验。
