# Integrations

这里存放上游能力的接入说明，不复制任何第三方源码、二进制、模型或受限内容。真正被 DSH 发现的可部署包装位于 `skills/deepseek-harness/skills/`；维护时需与这里的说明同步。

| 分类 | 接入说明 | 用途 |
| --- | --- | --- |
| DeepSeek Harness | `deepseek-harness/dsh-file-upload` | 文件上传、MarkItDown 文档提取 |
| DeepSeek Harness | `deepseek-harness/dsh-vision-router` | 图片理解、OCR 与视觉路由 |
| 钉钉 | `dingtalk/dsh-dingtalk` | 钉钉群消息推送 |
| 钉钉 | `dingtalk/dsh-notifier` | 多渠道通知与等待确认 |
| 设计 | `design/open-design` | 本地优先设计与提案工作台 |
| 演示 | `presentations/pptfast` | 原生可编辑 PPTX 生成 |

安装和使用前必须检查上游项目的版本、许可证、数据处理条款、真实可用性和所需凭据。连接器、机器人、通知或写入任何外部系统前，必须确认目标与授权范围。
