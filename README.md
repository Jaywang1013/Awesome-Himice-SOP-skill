# Awesome Himice SOP Skill

Himice 内部 SOP 技能合集。每个一级目录都是一套可独立部署的 Codex Skill；请按项目需要安装其中一套或多套。

## 技能目录

| 目录 | 用途 | 上游来源 |
| --- | --- | --- |
| `Himice-budget-process` | 将客户报价、供应商成本和预算模板制作成项目预算表；包含已确认的代付、操作费用、表头和公式核验规则。 | Himice 内部 SOP |
| `Himice-OfficeCLI` | 使用 OfficeCLI 处理项目预算、报价、方案、复盘等 Office 文件，并在修改后校验与渲染。 | [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) |
| `Himice-vibevoice` | 将已获授权的会议、展览和活动录音转写为带说话人和时间戳的文本，并输出纪要、行动项和待确认项。 | [microsoft/VibeVoice](https://github.com/microsoft/VibeVoice)（使用其中 ASR 能力） |

## 部署

先克隆私有仓库；公司同事需先获得仓库访问权限。

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill

# 按需复制一个或多个 Skill 到 Codex Skills 目录
cp -R Himice-budget-process ~/.codex/skills/himice-budget-process
cp -R Himice-OfficeCLI ~/.codex/skills/himice-officecli
cp -R Himice-vibevoice ~/.codex/skills/himice-vibevoice
```

复制完成后重新打开 Codex；调用示例：`$himice-budget-process`、`$himice-officecli`、`$himice-vibevoice`。

## 上游依赖与边界

- `Himice-OfficeCLI` 是公司工作流封装，不含 OfficeCLI 的源代码；安装和更新请遵循 [OfficeCLI 原仓库](https://github.com/iOfficeAI/OfficeCLI)。
- `Himice-vibevoice` 是会议转录工作流与术语词表，不含 VibeVoice 源代码或模型权重；部署 ASR 前请遵循 [VibeVoice 原仓库](https://github.com/microsoft/VibeVoice) 的安装说明与 MIT 许可证。它的 ASR 支持长音频、说话人、时间戳和自定义热词。
- 预算模板及内部费用规则仅供已获授权的同事使用。不要把客户报价、录音、人员信息或未公开项目材料上传到无授权的外部服务。

## 维护

费用标准或预算模板变更时，更新 `Himice-budget-process/references/budget-rules.md`；新增的会展术语、客户名或地点别名更新 `Himice-vibevoice/references/meeting-glossary.md`。上游工具升级时，先阅读其变更与许可证，再更新对应的来源说明。
