# 招投标沙盘推演机制设计（复刻自群体智能推演）

本文记录 `himice-tender-simulation` 的设计来源与机制映射，便于团队理解与后续维护。

## 背景

智海王潮需要"给招标书 → 模拟各家竞标 → 得出最优投标方案"的能力。调研了群体智能推演引擎 **MiroFish**（[666ghj/MiroFish](https://github.com/666ghj/MiroFish)，AGPL-3.0，基于 CAMEL-AI 的 OASIS 仿真引擎）后，决定**只借鉴其机制思想、不引入其代码与部署**，在 DSH 会话内用现有模型 + 并行 subagent 完整复刻其推演模式，内化为公司招投标助手。

> 许可证说明：MiroFish 为 AGPL-3.0。本仓库仅参考其**公开的机制设计**（流程、数据结构、编排思路），所有实现为独立重写；不复制其源码、不包含其二进制。

## MiroFish 核心机制（调研摘要）

**完整流水线**：

```
上传材料 → 文本分块(500字/50重叠) → LLM生成本体(entity/edge类型)
→ Zep图谱构建(分批注入, batch=350) → 实体读取
→ LLM生成人设(OasisAgentProfile: bio/persona/年龄/性格/兴趣)
→ LLM生成仿真配置(时间/事件/各Agent活动强度/平台)
→ OASIS并行模拟(round循环, LLMAction+env.step, 默认72轮)
→ 上帝视角注入(Interview IPC: 文件命令驱动任意Agent即时回答)
→ 时序记忆回写(Zep episode批量写回图谱, 屏障排空后COMPLETED)
→ ReAct报告Agent(insight_forge/panorama_search/quick_search/interview_agents,
  分章节生成, 防幻觉校验)
```

关键工程点（复刻时借鉴）：
- **JSON 健壮性**：LLM 输出 response_format=json_object + 截断修复 + 降级重试（温度递减）。
- **防幻觉**：报告 prompt 禁止捏造数据；工具调用不足 3 次拒绝收尾；剔除模型自造工具结果。
- **并发安全**：图谱生命周期锁 + 读租约防删图；写操作不盲目重试（防非幂等重复）。
- **三层并行**：人设线程池并行、双平台 asyncio 并行、模拟独立子进程隔离。

## 机制 → 招投标复刻映射

| MiroFish 机制 | 原实现 | 本技能复刻 |
| --- | --- | --- |
| 种子提取 | FileParser + chunk(500/50) | 招标书分块(800/100，句边界) + 行业/案例种子 |
| 本体生成 | LLM 生成 entity/edge 类型 | 固定招投标本体 + 项目扩展（见 `tender-ontology.md`） |
| 图谱构建 | Zep Graph 分批注入 | 工作区 `graph.json`（nodes+edges）增量写入 |
| 人设生成 | LLM → OasisAgentProfile | LLM → 公司人设卡 + 评标专家人设（`personas.json`） |
| 环境配置 | LLM → Time/Event/Agent/Platform | LLM → 投标周期/事件/活动强度（`environment.json`） |
| 并行模拟 | OASIS round 循环 + LLMAction | 并行 subagent 各家出策略，round 循环 |
| 上帝视角注入 | Interview IPC 文件命令 | 主模型轮间注入变量 + interview 各家 |
| 时序记忆 | Zep episode 回写 | 每轮结果写 `round-log.jsonl` + 图谱更新 |
| 报告生成 | ReAct ReportAgent + 图谱工具 | 分章节报告，从记忆库取数，防幻觉 |

## 为什么不用 MiroFish 原项目

- **部署重**：需 Node 18+/Python 3.11-3.12/uv/Zep Cloud/LLM key，独立全栈应用。
- **场景不匹配**：MiroFish 是社交平台（Twitter/Reddit）舆情/社会推演；招投标是结构化决策对抗，用 subagent 编排更直接。
- **合规**：AGPL-3.0 有传染性，直接内嵌源码不适用于公司内部私有化部署。
- **成本**：OASIS 72 轮模拟 LLM 消耗大；本技能默认 2 轮、按需扩展，成本可控。

## 后续演进

- 如需更强"记忆"：可对接本地向量库或 MCP 记忆服务，替换 `graph.json` 实现。
- 如需真实多智能体框架：可评估 OASIS 等引擎做招投标环境定制，但需单独评估部署与合规。
