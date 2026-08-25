---
name: dsh-univer-office
description: 在 DeepSeek Harness 对话内用自然语言创建、编辑、预览和审查办公文件：Sheet 表格（公式/图表/透视表/条件格式）、Doc 文档、Slide 演示、Base 轻数据库、Board 画布；隔离草稿 + 实时预览 + 批准/丢弃，支持 .xlsx/.docx/.pptx 导入导出。适配智海王潮的通用办公与轻量可视化编辑。
whenToUse: 需要可视化地创建或编辑表格、文档、演示、轻数据库或画布，希望在对话中实时预览并审查后再确认，或需要 .univer 多内容合一文件时使用。
user-invocable: true
---

# dsh-univer-office（Univer 在线办公）

本技能封装上游插件 [dream-num/dsh-univer-office](https://github.com/dream-num/dsh-univer-office)（Apache-2.0，由 [Univer](https://github.com/dream-num/univer) 驱动，114★）。让 agent 在对话内**可视地**创建、编辑、审查办公文件：描述需求 → agent 在隔离草稿中工作 → 对话内实时预览 → 批准或丢弃 → 导出标准文件。本目录不包含上游源码或二进制；安装、版本与许可证以上游仓库为准。

## 原仓库地址

- GitHub：https://github.com/dream-num/dsh-univer-office
- npm：`dsh-univer-office`
- 上游框架：https://github.com/dream-num/univer（Apache-2.0）

## 安装（一次性，部署 DeepSeek 版本时执行）

```bash
dsh plugin --profile web add dsh-univer-office
# 重启 dsh web 后生效（需 Node.js ≥ 22.19）
```

## 能力与内置工具

| 内容类型 | 创建与编辑 | 校验与审查 | 导入 | 导出 |
| --- | --- | --- | --- | --- |
| **Sheet** | 单元格、公式、样式、表格、图表、透视表、筛选、验证、图片等 | 结构化范围检查、重算、截图、实时预览 | `.xlsx` `.csv` `.tsv` | `.xlsx` `.csv` `.tsv` |
| **Doc** | 段落、富文本、列表、任务、表格、图片、图表、页眉页脚、分页 | 文档回读、页面截图、实时预览 | `.docx` | `.docx` |
| **Slide** | 页面、文本、形状、图片、表格、图表、SVG 版式、转场 | 结构检查、文本越界/溢出/重叠 lint、截图预览 | `.pptx` | `.pptx` |
| **Base** | 表、字段、记录、视图、公式字段、筛选、排序、分组 | 结构化数据检查、工作台截图 | — | `.xlsx` `.csv` `.tsv` |
| **Board** | 形状、文本、连接线、图片、原生图表、路由 | 元素与连接线分析、区域截图 | — | 暂不支持导出 |

内置工具（DSH 自动选择，一般无需手动调用）：`univer_new` / `univer_status` / `univer_worktree`（隔离草稿）/ `univer_unit` / `univer_import` / `univer_inspect` / `univer_execute` / `univer_export` / `univer_lint` / `univer_compile_svg` / `univer_screenshot` / `univer_api` / `univer_resources`。

## 使用方式

1. 描述你要的结果（"读取 q2-sales.xlsx 生成管理看板：汇总指标、月度趋势、区域排名"），提供源文件路径。
2. agent 创建隔离草稿并编辑；你跟随实时预览，可反复要求修订。
3. 批准后更新当前版本，或丢弃草稿（批准/丢弃必须由你显式确认）。
4. 需要交付标准文件时，要求 agent 导出 `.xlsx` / `.docx` / `.pptx`，可在 Excel / WPS / PowerPoint 中继续编辑。

## 与仓库其他技能的分工边界（重要，避免选错工具）

| 场景 | 用哪个 | 为什么 |
| --- | --- | --- |
| **Himice 预算表/报价/报销 SOP**（项目预算表、收支明细表、备用金申请） | `himice-officecli` + `himice-budget-process` 等核心 SOP | 公司模板格式、公式、代付、现金项有专属规则；Univer 不感知 Himice SOP |
| **通用表格/文档/演示的可视化创建与审查**（临时表、周报、培训 deck、轻数据库） | **本技能 `dsh-univer-office`** | 对话内实时预览 + 草稿批准/丢弃是 Univer 独有优势 |
| **需要原生可编辑、品牌风格统一的 PPTX**（客户提案、方案汇报） | `pptfast` | pptfast 输出原生 DrawingML 可在 PowerPoint 直接编辑，17 主题 + 品牌抽取；Univer 的 Slide 主要用于在线预览审查 |
| **只读/精准修改现有 Office 文件、保留公式格式** | `himice-officecli`（OfficeCLI） | 本地精准修改、公式验证、渲染复核 |
| **读取文档内容供模型理解** | `dsh-file-upload`（MarkItDown） | 上传识别与内容提取，非编辑 |

> 一句话：**SOP 流程走核心技能，在线可视化编辑走 Univer，精美原生 PPTX 走 pptfast，本地精准修改走 OfficeCLI。** 不确定时优先问用户期望"在线预览审查"还是"导出可编辑文件"。

## 智海王潮典型场景

- **通用表格**：项目排期表、媒体排期、执行 checklist 快速建表并可视化核对
- **周报/汇报文档**：项目周报、客户跟进报告（含表格与图表）
- **培训/提案演示**：在对话里先预览 deck 结构，确认后再导出 PPTX
- **轻数据库**：客户台账、供应商名录、招投标候选池的结构化维护（Base）
- **多内容合一**：同一 `.univer` 文件中 Sheet 数据被 Slide 图表引用

## 安全与边界

- 只在已授权范围内处理内部或客户资料；草稿与预览均在本地，不把文件内容发送给未授权服务。
- 批准/丢弃必须由用户显式确认；不得以未审查结果覆盖当前版本。
- 涉及客户名称、税号、预算金额等未公开信息时，遵循仓库"本地处理"规则。
