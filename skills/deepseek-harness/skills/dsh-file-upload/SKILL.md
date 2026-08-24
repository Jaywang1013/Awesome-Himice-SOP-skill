---
name: dsh-file-upload
description: 在 DeepSeek Harness 中上传并识别任意文件（PDF/Word/Excel/PPT/图片/压缩包/文本等），内置 MarkItDown 引擎将文档转为 Markdown，供模型用 read_document 工具分页读取。本技能为上游插件的封装。
whenToUse: 需要把本地文件（客户报价表、发票、合同、PDF、图片、压缩包等）上传给模型识别、读取或分析时使用。
user-invocable: true
---

# dsh-file-upload（文件识别）

本技能封装上游插件 [HongMing-Huang/dsh-file-upload](https://github.com/HongMing-Huang/dsh-file-upload)（MIT，DeepSeek Harness 官方精选插件），为 DSH Web 提供**任意文件上传 + 文档识别**能力。本目录不包含上游源码或二进制；安装、版本与许可证以上游仓库为准。

## 原仓库地址

- GitHub：https://github.com/HongMing-Huang/dsh-file-upload
- npm：`dsh-file-upload`

## 安装（一次性，部署 DeepSeek 版本时执行）

```bash
dsh plugin --profile web add dsh-file-upload
# 重启 dsh web 后生效
```

重启后 composer 工具栏出现**回形针按钮**，也可把文件直接**拖到页面任意位置**上传。

## 使用方式

1. 用户通过回形针按钮或拖拽上传文件（默认上限 25MB，可在配置中调整）。
2. 小文本文件（代码/JSON/CSV/日志等）内容**直接进输入框**；文档类显示为附件卡，路径随消息发出；上传后输入 `@` 可按相对路径引用。
3. 模型用 `read_document <路径>` 读取文档：内置 MarkItDown 引擎按需转为 Markdown（PDF / DOCX / PPTX / XLSX / HTML / CSV / JSON / XML / ZIP / Jupyter / 图片 OCR / 音频转写等 20+ 格式），支持 `offset`/`limit` 分页与行号定位。
4. 图片默认经内置引擎 OCR 转文字（Tesseract，110+ 语言），无需额外视觉插件。

## 安全

- 仅接受本机回环（loopback）上传；文件名消毒；按会话隔离存储到 `.dsh-uploads/<sessionId>/`。
- sha256 内容去重、并发限流、TTL 自动清理。
- 只在已授权范围内处理内部或客户资料，不把文件内容发送给未授权服务。

## 与 Himice 技能配合

处理项目预算、客户报价、发票、行程单、合同等文件时，先用本技能上传并读取内容，再交给 `himice-budget-process`、`himice-operating-expense-reimbursement-process` 等技能按 SOP 处理。
