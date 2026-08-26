# Core SOP Skills

这里是可直接部署的 Himice 核心活动执行 Skills。三套平台均有相同的五个业务 Skill；业务规则、空白模板和 reference 随各平台副本一起部署，避免同事因本地相对路径缺失而无法运行。

## 业务分类视图

- [全部门通用](all-department/README.md)：四个部门均可直接调用。
- [公司通用](company-common/README.md)：覆盖两个及以上部门或公司级协作流程。
- [各部门适配](departments/README.md)：展示部门专属 Skill 和该部门可调用的通用 Skill。

分类目录负责业务发现；下方 runtime 目录负责实际部署。分类版 Skill 当前为 Codex 结构预览，不替代已有三平台安装包。

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

使用仓库根目录的 [`scripts/install.sh`](../scripts/install.sh) 安装：核心流程使用 `--bundle core`，通用办公与 DSH 上游工具包装使用 `--bundle general`。实际插件安装与凭据配置见 [`../integrations/`](../integrations/)。
