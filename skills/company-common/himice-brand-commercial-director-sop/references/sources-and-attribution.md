# 来源、融合方式与适配说明

本 Skill 不是四份上游文档的拼接。它以客户商业片的真实决策顺序重新组织为“品牌事实锁 → 导演命题 → 生产方式 → 参考契约 → 镜头契约 → 模式编译 → 连续性生产 → 后期与验收”，并用 Himice 的客户审批、隐私和事实边界约束全部环节。

## 四个主要来源

| 上游 | 版本 | 许可证 | 本 Skill 吸收并重写的核心 |
| --- | --- | --- | --- |
| [Emily2040/seedance-2.0](https://github.com/Emily2040/seedance-2.0) | `44b514992963a2570beee71aaf2a8720785f7ec2` | MIT | 主逻辑：先导演意图后技术；模式门、参考资产单一职责、来源携带状态、当前镜头编译、连续性状态与 QC 权威顺序 |
| [wuwangzhang1216/DirectorSKILL](https://github.com/wuwangzhang1216/DirectorSKILL) | `47db7d9b951a9f27f7b4b727a6ca0e01ab56f7c6` | MIT | 工作导演/预演视角；产品材质灯光、微距物理、品牌色/Logo 的生成边界、Hero/Packshot/端卡分工、实拍/合成决策与修复预算 |
| [OSideMedia/higgsfield-ai-prompt-skill](https://github.com/OSideMedia/higgsfield-ai-prompt-skill) | `c0b73ab946df6658cca513db78bdc3909a655bfd` | MIT | 整片共享控制块、资产词汇表与保真等级、编辑一次全局继承、离场状态、片长算术、英雄停留和连续三镜单调审计 |
| [jacobye2017-afk/jacob-ye-seedance-prompt](https://github.com/jacobye2017-afk/jacob-ye-seedance-prompt) | `f74d2fcfa803cec4007fdfbeae9cde8831693ee7` | CC BY 4.0 | 可观察微表演、光源/光行为/色调、每拍结束状态、素材上传与删除纪律、道具多状态、跨段声音锚点、局部编辑/延长和后期去 AI 感 |

## 重要改动

- 将 Emily 的 Seedance 2.0 操作系统作为默认骨架，但移除任何未经核验的平台数字；适配其他平台时坚持能力优先。
- 将 DirectorSKILL 的产品摄影建议提升为“生成/实拍/合成”生产门槛，明确最终 Logo、文字、精确品牌色和高风险物理不交给纯生成。
- 将 Higgsfield 的 HTML 特定交付与平台 API 细节剥离，只保留适用于任意商业片的共享控制块、资产账本和整片审计。
- 将 Jacob 的 Seedance 2.5 专属槽位数字、时长和符号语法改为按当前平台核验；保留素材职责、微表演、声音与修复方法。
- 所有示例、品牌、人物、文案与镜头均重新编写；没有复制四个仓库的具体广告方案。

Jacob Ye 来源依 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) 署名；本 Skill 对其方法进行了节选、改写、重组与 Himice 业务适配。完整 MIT 版权声明与 CC BY 署名信息见仓库根目录 [THIRD_PARTY_NOTICES.md](../../../../THIRD_PARTY_NOTICES.md)。

## 使用边界

上游均为社区项目，不代表 Seedance、Higgsfield、字节跳动或任何模型平台的官方承诺。平台能力、条款、价格、模式、时长、分辨率和素材槽位属于时效信息；生产前应以目标平台当前官方文档或实际界面核验。
