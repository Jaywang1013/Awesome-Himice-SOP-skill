---
name: himice-officecli
description: 使用 OfficeCLI 创建、读取、修改、校验和渲染 Himice 的 Excel、Word 与 PowerPoint 文件，适用于项目预算、客户报价、会议方案、执行清单和复盘。
whenToUse: 需要保留或核验 Office 文件格式、公式、合并单元格、版式或渲染效果时使用。
user-invocable: true
---

# Himice OfficeCLI（DSH）

使用 [OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 处理 Office 文件。该上游工具必须由用户单独安装；本 Skill 仅提供 Himice 工作流，不包含其源码、二进制或依赖。详见 `references/source.md`。

1. 先运行 `officecli --version`，确认工具可用；查看文件结构后再编辑。
2. 保留原文件的样式、公式、合并单元格、列宽、冻结窗格、批注和数字格式，除非用户要求改变。
3. 需要增删 Excel 行列时，先查询对应帮助并克隆相邻格式、公式和校验规则；项目预算执行 `himice-budget-process` 的专门规则。
4. 修改后运行校验并渲染/截图复核。重点检查公式错误、分页、表头、金额格式、合并关系与文字溢出。
5. 交付时说明输出文件、校验结果和待人工确认项；不得宣称未实际校验的结果。

只在已授权范围内处理内部或客户资料，不把文件、客户信息或录音发送给未授权服务。
