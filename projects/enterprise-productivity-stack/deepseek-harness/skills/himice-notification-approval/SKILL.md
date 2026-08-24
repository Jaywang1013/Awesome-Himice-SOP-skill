---
name: himice-notification-approval
description: 在 DeepSeek Harness 中使用已安装的 dsh-im、dsh-notifier 或渠道插件发送通知、等待确认并记录审批状态。
whenToUse: 用户要求通过钉钉、飞书、企业微信等渠道通知人员或发起审批跟踪时使用。
user-invocable: true
---

# Himice Notification And Approval — DSH

优先使用当前 profile 实际安装的 `dsh-im`、`dsh-notifier` 或具体渠道插件；可参考 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 与插件上游。插件名称不代表官方内置，先核对来源、权限和凭据。

1. 发送前确认渠道、收件人/群、项目、正文、附件、动作和截止时间；对象无法唯一识别时停止。
2. 消息含客户资料、金额、手机号或文件时，核对目标群权限和最小披露范围。
3. 通知不等于审批。只有目标系统明确返回批准/拒绝记录时才能更新审批状态；普通回复不得推断为批准。
4. 发送后保存消息 ID、渠道和时间并回读状态。失败只做一次安全重试，避免重复推送。
5. Webhook、签名密钥和渠道凭据仅放本地安全配置，不得写入 Skill 或 GitHub。
