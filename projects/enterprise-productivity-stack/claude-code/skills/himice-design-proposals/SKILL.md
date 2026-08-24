---
name: himice-design-proposals
description: 在 Claude Code 中使用 OpenDesign 与已安装的 Claude Skills 制作活动视觉、提案、原型、演示和多格式设计交付物。
---

# Himice Design And Proposals — Claude Code

使用 [OpenDesign](https://github.com/nexu-io/open-design) 作为本地优先设计工作台，并按任务调用当前已安装的 Claude 设计/文档 Skills。不要假定外部 Skill 已自动导入 OpenDesign；先检查 Claude CLI、OpenDesign daemon、MCP 和所需 Skill。

1. 收集交付物、尺寸/页数、品牌、受众、用途、截止时间和参考素材。
2. 用品牌设计系统约束原型、活动视觉和提案；DOCX/PDF/PPTX/XLSX 交付应路由到对应 Anthropic document Skill。
3. 不把概念稿写成最终承诺；客户名、日期、场地、报价和业务结论必须与来源核对。
4. 导出后检查层级、字体、对比度、留白、图片授权、页面裁切和可编辑性。
5. 对外发布前由项目负责人确认，客户与内部素材不得发送到未授权服务。
