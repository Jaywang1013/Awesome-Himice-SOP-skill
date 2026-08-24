---
name: dsh-notifier
description: 统一通知推送：agent 与 DSH 会话事件自动推送（回合结束/等待确认/出错），27 个渠道（钉钉/飞书/企业微信/ServerChan/Telegram 等），手机可远程审批与遥控。适配智海王潮出差多、审批走钉钉的场景。
whenToUse: 需要把长任务结果、审批请求、错误告警推送到手机或 IM（钉钉/飞书/企业微信），或在手机上远程批准/停止任务时使用。
user-invocable: true
---

# dsh-notifier（统一通知推送）

封装上游插件 [THEWOLFWALKER/dsh-notifier](https://github.com/THEWOLFWALKER/dsh-notifier)（MIT，awesome-dsh-plugin 精选，846 项测试）。一条 `notify()` API 背后接 27 个推送渠道，session 事件自动推送，手机可反向审批与对话。本目录不包含上游源码或二进制。

## 原仓库地址

- GitHub：https://github.com/THEWOLFWALKER/dsh-notifier
- npm：`dsh-notifier`

## 安装（一次性）

```bash
dsh plugin --profile web add dsh-notifier
# 重启 dsh web 后生效
```

## 配置

在 profile 的 `cordis.patch.yml` 中配置渠道（示例：钉钉群机器人 + Telegram）：

```yaml
insert:
  - id: dsh-notifier
    name: dsh-notifier
    config:
      channels:
        - type: dingtalk
          webhook: "https://oapi.dingtalk.com/robot/send?access_token=..."
        - type: telegram
          botToken: "..."
          chatId: "..."
```

- 27 个渠道：钉钉、飞书、企业微信、ServerChan、Telegram、PushPlus、Bark 等 IM webhook 与推送 App。
- 支持**事件自动推送**：回合结束、等待确认（approval/asked）、agent 出错自动通知；`notify` 工具可让模型主动推送。
- 支持**反向通道**：手机回复 1/2 完成审批、远程停止长任务（v0.5+ 通知卡片带 ⏹ 停止按钮）。
- 本地 Web 管理台（`admin.enabled: true`，仅回环地址）：配置渠道、测试发送、绑定 agent。

## 智海王潮典型场景

- **出差手机收结果**：客户提案 PPT、报价单生成完毕 → 推送到手机（Telegram/钉钉），不用盯电脑
- **审批不下线**：任务需要人工确认时，审批请求推到手机，回复即可批准
- **长任务心跳**：大预算表生成、录音转写耗时长 → 心跳/完成通知，中途异常直接推送
- **多渠道覆盖**：钉钉给全员、Telegram/Bark 给核心负责人，同一事件多端到达

只在已授权范围内推送内部或客户信息；推送渠道凭据（webhook/token）属于敏感配置，不得写入仓库或分享。
