---
name: dsh-vision-router
description: 给纯文本 DeepSeek Harness Agent 装上"眼睛"：粘贴/上传图片即可识别，内置免费视觉链与多模态模型路由，支持看图问答、OCR、元素定位、像素对比、取色、抠图、SVG 矢量化等深度视觉工具。本技能为上游插件的封装。
whenToUse: 需要识别图片、查看截图、OCR 文字、定位界面元素、对比像素、取色、抠图或矢量化图片时使用。
user-invocable: true
---

# dsh-vision-router（图片识别）

本技能封装上游插件 [ysr666/dsh-vision-router](https://github.com/ysr666/dsh-vision-router)（MIT，DeepSeek Harness 官方精选插件，dsh-recommend 认证），为纯文本模型提供**免费开箱的视觉能力**。本目录不包含上游源码或二进制；安装、版本与许可证以上游仓库为准。

## 原仓库地址

- GitHub：https://github.com/ysr666/dsh-vision-router
- npm：`dsh-vision-router`

## 安装（一次性，部署 DeepSeek 版本时执行）

```bash
dsh plugin --profile web add dsh-vision-router
# 重新加载 DSH Web 后生效；插件加载后模型路由热更新，无需再次重启
```

## 使用方式

1. 用户在输入框**粘贴或上传图片**（PNG/JPEG/WebP/GIF），图片会渲染在对话气泡中。
2. 模型通过视觉工具识别图片，开箱免费、免 Key、无 Python：
   - **看图问答 / OCR**：`vision_describe`、`vision_ocr`、`vision_bootstrap`（结构化预识别）
   - **元素定位**：`vision_detect`、`vision_ground`（返回像素坐标框）
   - **像素级操作**：`vision_crop` 裁剪、`vision_pixel_diff` 像素对比、`vision_colors` 取色、`vision_extract_foreground` 抠图
   - **截图**：`vision_html_screenshot` 渲染本地 HTML 为图片、`vision_long_screenshot_ocr` 长截图转文字
   - **矢量化**：`vision_trace` 转 SVG
3. 默认内置免费视觉链（云端优先，未配置 Key 时自动回退本机模型，数据不出本机）。

## 配置

- 默认免费模型即可用；如需接入自己的多模态模型，在设置中配置云端 OpenAI 兼容端点或本机 Ollama 视觉模型。
- 桌面截屏类工具默认关闭，需显式开启隐私开关后才可用。
- 可在设置中选择"隐身模式"：接管或让渡官方 DeepSeek 图片路由。

## 与 Himice 技能配合

处理发票截图、行程单、支付凭证、活动照片、签到背景板效果图等图片时，先用本技能识别图片内容，再交给 `himice-operating-expense-reimbursement-process` 等技能按 SOP 处理。只在已授权范围内处理内部或客户资料，不把图片内容发送给未授权服务。
