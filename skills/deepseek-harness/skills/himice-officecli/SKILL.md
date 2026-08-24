---
name: himice-officecli
description: 使用 OfficeCLI 创建、读取、修改、校验和渲染 Himice 的 Excel、Word 与 PowerPoint 文件，适用于项目预算、客户报价、会议方案、执行清单和复盘。
whenToUse: 需要保留或核验 Office 文件格式、公式、合并单元格、版式或渲染效果时使用。
user-invocable: true
---

# Himice OfficeCLI（DSH）

使用 [OfficeCLI](https://github.com/iOfficeAI/OfficeCLI) 处理 Office 文件。本 Skill 仅提供 Himice 工作流，不包含上游工具的源码、二进制或依赖；安装、版本与许可证以[上游仓库](https://github.com/iOfficeAI/OfficeCLI)为准。详见 `references/source.md`。

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

1. 运行 `officecli --version`，能输出版本号即视为安装成功、工具可用；
2. 若提示命令不存在：提示用户按上方命令安装（或自动执行 `officecli install`），安装成功后重新运行 `officecli --version` 确认；
3. 自检通过后，再查看文件结构并执行任务；**未通过自检不得继续处理文件，也不得声称工具可用**。

## 执行流程

1. 先查看文件结构，再编辑。
2. 保留原文件的样式、公式、合并单元格、列宽、冻结窗格、批注和数字格式，除非用户要求改变。
3. 需要增删 Excel 行列时，先查询对应帮助并克隆相邻格式、公式和校验规则；项目预算执行 `himice-budget-process` 的专门规则。
4. 修改后运行校验并渲染/截图复核。重点检查公式错误、分页、表头、金额格式、合并关系与文字溢出。
5. 交付时说明输出文件、校验结果和待人工确认项；不得宣称未实际校验的结果。

只在已授权范围内处理内部或客户资料，不把文件、客户信息或录音发送给未授权服务。

整理实际操作费用报销和预算差异时先使用 `himice-operating-expense-reimbursement-process`；需要把已确认明细写入公司模板时，再使用本 Skill。
