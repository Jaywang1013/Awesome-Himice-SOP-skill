# Core SOP Skills

这里是可直接部署的 Himice 核心活动执行 Skills。三套平台均有相同的五个业务 Skill；业务规则、空白模板和 reference 随各平台副本一起部署，避免同事因本地相对路径缺失而无法运行。

| Skill ID | 业务阶段 | 内置资产 |
| --- | --- | --- |
| `himice-budget-process` | 活动前预算 | 项目预算表模板、预算规则 |
| `himice-advance-fund-application-process` | 活动前备用金申请 | 预估协作人审批表模板、申请规则 |
| `himice-operating-expense-reimbursement-process` | 活动后操作费用报销 | 项目操作收支明细表模板、报销规则 |
| `himice-vibevoice` | 会议与活动复盘 | 会展与厦门术语、上游来源说明 |
| `himice-officecli` | 全流程 Office 文件处理 | OfficeCLI 安装与核验说明 |

## Runtime mapping

| Runtime | Source directory | Target directory |
| --- | --- | --- |
| Codex | `codex/` | `~/.codex/skills/` |
| DeepSeek Harness | `deepseek-harness/skills/` | `~/.dsh/skills/` |
| Claude Code | `claude-code/skills/` | `~/.claude/skills/` |

使用仓库根目录的 [`scripts/install.sh`](../scripts/install.sh) 安装。DSH 目录额外含上游工具包装，实际插件安装与凭据配置见 [`../integrations/`](../integrations/)。
