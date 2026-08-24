---
name: dsh-dingtalk
description: 让 agent 直接向钉钉群推送消息：Markdown/纯文本通知，加签安全，零依赖。适配智海王潮传播集团钉钉办公流程（项目群、执行群、客户群通知）。
whenToUse: 需要把任务结果、执行进度、报价确认、会议纪要或告警推送到钉钉群时使用。
user-invocable: true
---

# dsh-dingtalk（钉钉群通知）

封装上游插件 [STARDUSTLC666/dsh-dingtalk](https://github.com/STARDUSTLC666/dsh-dingtalk)（MIT，awesome-dsh-plugin 精选）。让 agent 能向钉钉群**单向推送** Markdown / 纯文本消息，纯 Node 实现，零运行时依赖。本目录不包含上游源码或二进制。

## 原仓库地址

- GitHub：https://github.com/STARDUSTLC666/dsh-dingtalk
- npm：`dsh-dingtalk`

## 安装（一次性）

```bash
dsh plugin --profile web add dsh-dingtalk
# 重启 dsh web 后生效
```

## 配置（钉钉自定义机器人）

1. 在钉钉群 → 群设置 → 智能群助手 → 添加机器人 → 自定义（Webhook）。
2. 复制 Webhook 地址中的 `access_token`，如需安全设置则开启"加签"，复制加签密钥。
3. 在 DSH 设置或 `cordis.patch.yml` 中配置机器人信息（token / secret）。

## 使用方式

| 工具 | 作用 |
|---|---|
| `dingtalk_notify` | 向配置的钉钉群发一条 **Markdown** 消息（`title` 标题 + `text` Markdown 正文） |
| `dingtalk_text` | 向配置的钉钉群发一条 **纯文本** 消息（`content`） |

典型对话："帮我给项目群发条消息，标题「预算表已完成」，正文「上海大会预算已按报价生成，总价 ¥177,851.84，请查收。」"

## 智海王潮典型场景

- **项目执行群**：活动报价/预算表生成完成 → 推送到项目群通知项目经理
- **进度播报**：物料制作、搭建进度阶段性完成后推送
- **会议纪要**：转写与纪要完成后推送到会议群（配合 `himice-vibevoice`）
- **异常告警**：执行中发现问题时推送给负责人

只在已授权范围内发送内部或客户信息；钉钉群消息可能被同事与客户看到，发送前确认内容脱敏与收件群正确。
