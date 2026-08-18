---
name: himice-officecli
description: 使用 OfficeCLI 读取、修改、校验和渲染 Himice 的 Excel、Word 与 PowerPoint 文件，并保留原有格式与公式。
when_to_use: Use when a user needs a Himice Office document created, inspected, edited, validated, or rendered.
argument-hint: "<文件或目录> <编辑或校验任务>"
disable-model-invocation: true
---

# Himice OfficeCLI

仅在用户明确调用 `/himice-officecli` 后执行。先读取 `${CLAUDE_SKILL_DIR}/references/source.md`。本 Skill 仅封装 Himice 工作流，不包含 [iOfficeAI/OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 的源代码、二进制或依赖。

## 首次使用：安装 OfficeCLI（一次性）

克隆仓库后、第一次调用本 Skill 前，先按官方方式安装 OfficeCLI（任选其一）：

```bash
# macOS / Linux 一键安装
curl -fsSL https://raw.githubusercontent.com/iOfficeAI/OfficeCLI/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/iOfficeAI/OfficeCLI/main/install.ps1 | iex

# 或包管理器：brew install officecli（macOS/Linux）、scoop install officecli（Windows）、npm install -g @officecli/officecli（全平台）
```

若以上命令都不可用，直接运行 `officecli install`（显式自安装），或裸执行 `officecli`（首次调用也会触发自安装）。

## 首次调用自检（必做）

每次会话第一次调用本 Skill 时，必须先测试上游工具，**跑通后才能开始正式处理**：

1. 执行 `officecli --version`，能输出版本号即视为安装成功、工具可用；
2. 若提示命令不存在：提示用户按上方命令安装（或自动执行 `officecli install`），安装成功后重新执行 `officecli --version` 确认；
3. 自检通过后，再查看文件结构并执行任务；**未通过自检不得继续处理文件，也不得声称工具可用**。

## 执行步骤

1. 先查看结构再编辑。除非用户明确要求，不得改变样式、公式、合并单元格、列宽、冻结窗格、批注、数据验证或数字格式。
2. 需插入行列时，先查询帮助；复制相邻行列的样式、公式和校验规则。预算表具体规则由 `/himice-budget-process` 负责。
3. 修改后运行校验并渲染关键页面，检查公式错误、分页、表头、金额格式、合并关系和内容溢出。
4. 交付时说明输出、完成的校验和待人工确认项；不得把未验证的结果说成已验证。

客户资料和内部文件只在授权范围处理，不得发送到未授权服务。预算、报价和结算金额必须保持数值而非文本；会议展览方案资料不足时明确标 `[待确认]`。
