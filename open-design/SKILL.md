---
name: open-design
description: 开源 Claude Design 替代品：AI 生成网页/桌面/移动端原型、活动页面、数据看板、演示文稿、图片、视频与 HyperFrames 动效，HTML/PDF/PPTX/MP4 导出，支持品牌 DESIGN.md 设计系统。适配智海王潮创意部的主视觉、海报、延展与提案产出。
whenToUse: 创意部需要生成活动主视觉、海报、延展画面、H5 页面原型、提案 deck、短视频分镜或品牌设计系统时使用。
user-invocable: true
---

# OpenDesign（创意部设计工作台）

封装上游 [nexu-io/open-design](https://github.com/nexu-io/open-design)（Apache-2.0，88539★，开源 Claude Design 替代品）。本地优先的原生桌面应用（macOS / Windows），可挂接 DeepSeek Harness（dsh）作为运行时；生成 **web · 桌面 · 移动原型、活动看板/artifacts、演示文稿、图片、视频、HyperFrames 动效**，沙箱 iframe 预览，HTML / PDF / PPTX / MP4 导出。本目录不包含上游源码或二进制。

## 原仓库地址

- GitHub：https://github.com/nexu-io/open-design
- 官网：https://open-design.ai（含 OpenDesign Cloud 官方模型服务）
- 中文社区：飞书群（见上游 README 链接）

## 安装（一次性）

OpenDesign 是桌面应用，按上游 QUICKSTART 安装（Node ~24 + pnpm 10.33.x，或用官方打包的桌面 App）：

1. 从 https://github.com/nexu-io/open-design/releases 下载 macOS / Windows 桌面版（推荐小白直接用打包版）。
2. 在 Settings → Execution mode 中把 DeepSeek Harness（`dsh`）添加为运行时；如 dsh 不在 PATH，先在 Settings 里 Rescan。
3. 无本地 CLI 时可用 BYOK：Settings 中配置任意 OpenAI 兼容端点。

## 使用方式

- **Home**：选择产出类型（原型/看板/deck/图片/视频），输入 brief，选设计系统与模型，开始生成。
- **Plugins**：官方技能市场，一键试用成熟工作流。
- **Design System**：把品牌参考（智海王潮主视觉、LOGO、VI 手册）提炼为 `DESIGN.md` 品牌契约，之后所有产出自动遵循品牌规范。
- **Studio**：单页 artifacts 用真实 CSS/字体/组件渲染，可直接在 agent 中运行、导出 HTML/PDF/PPTX/MP4。
- 与 dsh 集成后，DeepSeek 模型可在会话内直接驱动 OpenDesign 生成与交付。

## 智海王潮典型场景（创意部）

- **活动主视觉与延展**：把客户 brief 生成主 KV、海报、延展画面，一次产出多尺寸
- **H5 / 活动页面原型**：展会、发布会、快闪活动的落地页快速原型
- **提案 deck**：客户提案演示文稿（可导出 PPTX 再精修）
- **品牌设计系统**：把智海王潮 VI 固化到 `DESIGN.md`，全员产出自动统一
- **短视频分镜 / HyperFrames**：活动传播视频的分镜与动效预览

## 注意

- 桌面应用体积较大、需 GUI 环境；纯服务器或远程终端无法使用 GUI 模式（可用 CLI/BYOK 模式）。
- 生成内容可能涉及客户品牌素材，只在已授权范围内使用；未公开的客户资料不得上传到未授权服务（OpenDesign Cloud 为可选服务，默认本地优先）。
