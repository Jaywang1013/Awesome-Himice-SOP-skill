---
name: himice-officecli
description: 使用 OfficeCLI 读取、修改、校验和渲染 Himice 的 Excel、Word 与 PowerPoint 文件，并保留原有格式与公式。
when_to_use: Use when a user needs a Himice Office document created, inspected, edited, validated, or rendered.
argument-hint: "<文件或目录> <编辑或校验任务>"
disable-model-invocation: true
---

# Himice OfficeCLI

仅在用户明确调用 `/himice-officecli` 后执行。先读取 `${CLAUDE_SKILL_DIR}/references/source.md`。本 Skill 仅封装 Himice 工作流，不包含 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 的源代码、二进制或依赖。

1. 先执行 `officecli --version`，确认上游工具可用；只读取当前文件类型所需的规则。
2. 先查看结构再编辑。除非用户明确要求，不得改变样式、公式、合并单元格、列宽、冻结窗格、批注、数据验证或数字格式。
3. 需插入行列时，先查询帮助；复制相邻行列的样式、公式和校验规则。预算表具体规则由 `/himice-budget-process` 负责。
4. 修改后运行校验并渲染关键页面，检查公式错误、分页、表头、金额格式、合并关系和内容溢出。
5. 交付时说明输出、完成的校验和待人工确认项；不得把未验证的结果说成已验证。

客户资料和内部文件只在授权范围处理，不得发送到未授权服务。预算、报价和结算金额必须保持数值而非文本；会议展览方案资料不足时明确标 `[待确认]`。
