# dsh-univer-office 上游说明

Univer 在线办公集成（DeepSeek Harness 插件）。

## 上游来源

- 插件仓库：https://github.com/dream-num/dsh-univer-office
- 上游框架：https://github.com/dream-num/univer
- npm：`dsh-univer-office`
- 许可证：Apache-2.0（上游）

## 安装

```bash
dsh plugin --profile web add dsh-univer-office
# 重启 dsh web 后生效；需 Node.js ≥ 22.19
```

## 使用

- 描述需求 → agent 在隔离草稿中编辑 → 对话内实时预览 → 用户批准/丢弃 → 导出 `.xlsx` / `.docx` / `.pptx`。
- 内容类型：Sheet 表格、Doc 文档、Slide 演示、Base 轻数据库、Board 画布。
- 内置工具：`univer_new` / `univer_status` / `univer_worktree` / `univer_unit` / `univer_import` / `univer_inspect` / `univer_execute` / `univer_export` / `univer_lint` / `univer_compile_svg` / `univer_screenshot` / `univer_api` / `univer_resources`。

## 分工边界（与仓库内其他技能）

| 场景 | 使用 |
| --- | --- |
| Himice SOP（预算表、报销、备用金） | `himice-officecli` + 核心 SOP 技能 |
| 通用办公在线可视化创建/编辑/审查 | 本插件（`dsh-univer-office`） |
| 原生可编辑、品牌风格统一的 PPTX | `pptfast` |
| 本地精准修改现有 Office 文件、公式验证 | `himice-officecli`（OfficeCLI） |
| 读取文档内容供模型理解 | `dsh-file-upload`（MarkItDown） |

> 本目录仅保存接入说明，不包含上游源码或二进制；版本与许可证以原仓库为准。
