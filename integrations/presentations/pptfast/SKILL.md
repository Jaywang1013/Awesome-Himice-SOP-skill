---
name: pptfast
description: 生成原生可编辑 PPTX：从大纲/笔记/文档生成演示文稿，语义 IR → 校验 → 渲染，17 种内置主题，可抽取公司现有 PPT 的品牌配色字体，本地渲染无 API key。适配智海王潮的提案、方案汇报与内部培训 deck。
whenToUse: 需要把内容（提案、方案、复盘、培训）做成 PPT/演示文稿，且要求原生可编辑、品牌风格一致、稳定可复用时使用。
user-invocable: true
---

# pptfast（PPT 生成）

封装上游 [liustack/pptfast](https://github.com/liustack/pptfast)（MIT，DSH deck 生成插件）。把内容大纲转成**原生 DrawingML `.pptx`**——每一级标题、要点、图表都能在 PowerPoint 里继续编辑，不是"一张图片 PPT"。17 种内置主题，可抽取公司现有 PPT 的配色与字体做成自定义主题。本地渲染，无账号、无 API key。本目录不包含上游源码或二进制。

## 原仓库地址

- GitHub：https://github.com/liustack/pptfast
- npm：`@liustack/pptfast`

## 安装（一次性）

```bash
dsh plugin --profile web add @liustack/pptfast@0.20.0
# 重启 dsh web 后生效；插件卡片显示为 "pptfast"，自带 CLI，无需单独安装
```

> 需要 Node.js ≥ 22.19（或 Bun）。卸载插件会同时移除 skill，无残留。

## 使用方式

1. 告诉 agent 要做什么 PPT（"把这份活动方案做成提案 deck"），agent 会：
   - `pptfast schema / themes / narratives` 读取当前词表（每会话都重新读，勿凭记忆）
   - 写出 deck 的 JSON IR（结构：封面/章节/内容/结尾页）
   - `pptfast validate` 校验 → `pptfast render` 渲染 → `pptfast preview` 浏览器预览
2. 修订闭环：预览页面上直接写批注 → agent 读取并修改 → 页面自动刷新。
3. 品牌定制：`pptfast brand extract` 从公司现有 PPT 提取配色/字体，套用到新 deck。
4. 重点规则：封面/章节/结尾页不渲染内容组件；小 deck 可直接写单个 IR 文件再 validate。

## 智海王潮典型场景

- **客户提案 deck**：把客户需求、方案、报价结构生成提案 PPT，导出 PPTX 精修后提案
- **活动方案汇报**：展会/发布会方案、排期、执行要点一键成稿
- **项目复盘**：执行数据、亮点、改进项结构化呈现
- **内部培训**：SOP 培训、新人上手材料（配合思维导图模式）

## 注意

- 生成的是**内容骨架 + 排版**：图表/表格数字如需修改，让 agent 重建该页，不要手工改图。
- 涉及客户名称、预算金额、报价等未公开信息，仅在已授权范围内处理，不发送到未授权服务。
- 与 `open-design` 的区别：pptfast 专注**原生 PPTX 演示文稿**（可编辑、快、稳定）；open-design 是**设计工作台**（原型/海报/动效等多形态产出）。两者可搭配：提案正文用 pptfast，主视觉用 open-design。
