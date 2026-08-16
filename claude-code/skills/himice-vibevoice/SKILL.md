---
name: himice-vibevoice
description: 使用 VibeVoice-ASR 转写已获授权的 Himice 会议、展览和活动录音，并结合会展和厦门术语生成纪要、行动项与待确认清单。
when_to_use: Use when a user provides authorized Himice meeting or event audio and needs a transcript or meeting minutes.
argument-hint: "<已授权音频或视频> [会议名称] [输出要求]"
disable-model-invocation: true
---

# Himice VibeVoice

仅在用户明确调用 `/himice-vibevoice` 后执行。使用 [VibeVoice-ASR](https://github.com/microsoft/VibeVoice) 的上游 ASR 能力；本 Skill 不包含其源代码或模型权重。先读取 `${CLAUDE_SKILL_DIR}/references/meeting-glossary.md`，需要核对来源时再读取 `${CLAUDE_SKILL_DIR}/references/sources.md`。

## 前提与输入

确认录音已获参会者与客户授权；收集会议名称、客户/主办方、日期地点、参会角色、语言方言、预期输出和重点术语。未获授权或没有原始音频时，不得转写。项目实际客户、人员、供应商、场地、品牌和缩写可作为热词，但不可用来臆造音频内容。

## 转写与整理

1. 通过上游文件推理或获批准的内部部署生成原始转写，保留说话人和时间戳；长音频按自然议题切分且保持连续时间基准。
2. 对照音频核对姓名、数字、金额、日期、地点、项目编号和责任人；证据不足处标 `[待确认]`。
3. 原始转写与整理后纪要分开交付。纪要包括背景、结论、决定、行动项、风险/待确认项；行动项表列事项、负责人、截止时间、来源时间戳和状态。
4. 区分策划、搭建、彩排、开展、执行、撤场、复盘等阶段；重点复核会场、舞美、灯光、音响、视频、导视、签到、嘉宾、展商、物料、供应商、预算、合同、发票、结算和代付。

只保存和访问已授权资料；AI 转写不是最终依据，对外发布、合同金额、承诺和法律/安全内容必须人工复核。不得合成、克隆、伪造或冒充任何人的声音。
