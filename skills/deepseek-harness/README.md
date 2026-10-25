# DeepSeek Harness Skills

DSH 侧技能源码目录。安装后映射到 `~/.dsh/skills/`，用仓库根目录的 `scripts/install.sh` 部署。

## 一、流程 Skill 的标准结构

每个「跑通过的流程」= 一个 skill，按**流程**拆，不按 Bot 拆。

```
skills/deepseek-harness/skills/<skill-name>/
├── SKILL.md                      # 必需：frontmatter + 主流程
├── references/
│   ├── field-mapping.md           # 字段映射（进库）
│   ├── business-rules.md          # 业务口径硬规则（进库）
│   └── pitfalls.md                # 踩坑，分「通用跨模板」「本流程专属」两节
└── assets/                        # 空白模板（不含客户数据）
```

### 本机覆盖文件的命名（通用规则）

凡「本机实际值」的文件，一律按**它所覆盖的那份共享文件**来命名：

| 用途 | 文件名 | 是否进库 |
| --- | --- | --- |
| 共享内容（字段映射、规则、说明） | `<name>.md` | 进库 |
| 同事可复制的空白模板 | `<name>.example.md` | 进库（只放占位符） |
| 本机实际值（申请人、部门、默认公司、窗口参数、项目别名…） | `<name>.local.md` | **不进库**（`.gitignore` 的 `*.local.md` 覆盖） |

例：付款/用印 skill 有 `field-mapping.md`，本机覆盖即 `field-mapping.local.md`；
`himice-advance-fund-application-process` 的默认值围绕部门与申请人，沿用既有 `department-defaults.example.md` / `department-defaults.local.md`，**不必迁移改名**——两者同属「`<name>.local.md` 一律忽略」这一条规则。

命名：小写连字符、`himice-` 前缀 + 业务流程语义，例如
`himice-dingtalk-payment-application`、`himice-dingtalk-seal-application`、
`himice-dingtalk-budget-approval`、`himice-dingtalk-loan-application`。

## 二、SKILL.md 的六段

frontmatter 必须有 `name` / `description` / `whenToUse`（可选 `user-invocable`）。正文六段：

| 段落 | 内容 |
| --- | --- |
| 适用场景 | 什么情况下用；**同时写明不适用什么**（例如付款 skill 不做节点查询） |
| 前置条件 | 系统权限、环境准备、依赖 skill、本机默认值文件、用户需要在场 |
| 逐步操作 | 每步写清 **输入 / 动作 / 易失败点**；操作步骤只在这里写一次 |
| 字段映射 | 指向 `references/field-mapping.md`，正文不重复表格 |
| 失败与回退 | 路由表：症状 → 处置去向（指向 pitfalls） |
| 提交前验证清单 | 复选框列表，**业务硬规则必须在这里有对应动作** |

## 三、内容归属（单点原则，避免同一内容两处写）

| 内容 | 归属 |
| --- | --- |
| 字段名、必填、取值来源、**控件类型**、格式校验 | `references/field-mapping.md` |
| 业务口径硬规则（预付款要件、金额口径、管控分类等） | `references/business-rules.md` |
| 症状 → 原因 → 处置；技术坑 | `references/pitfalls.md` |
| 坐标、OCR、聚焦、下拉滚动、附件面板等**跨流程技术坑** | 工具包 `himice-dingtalk-cua-toolkit`，各 skill 只引用不重写 |
| 具体坐标值 | 不写进任何文档（现 look 现点），只保留窗口基准为可配置参数 |

`business-rules.md` 每条必须带 **来源与日期**（哪条合同 / 谁的财务口径），并注明「口径变化时以财务最新说法为准」。

## 四、CUA 公共工具包

`himice-dingtalk-cua-toolkit` 提供钉钉 GUI 代填的公共能力（截图、Vision OCR、坐标点击、拼音输入、环境自检），是本目录下所有钉钉流程 skill 的**公共依赖**。流程 skill 在 SKILL.md 开头要求先加载它，不得复制其脚本。

工具包自带 `install.sh`（编译 `ocr`/`pdf2png` 到 `bin/`、写 `config.env`）与 `config.env.example`；`config.env` 与 `bin/` 已被忽略，不进版本库。

## 五、隐私硬规则

以下内容**一律不进仓库**：

- 客户名、税号、银行账号、人名、金额、鱼鹰号
- 截图、草稿快照、合同 / 发票 PDF
- 本机默认值（申请人、部门、默认公司等）——写进 `*.local.md`，示例用占位符如 `<收款单位>`、`<鱼鹰号>`

路径必须参数化：仓库中不得出现 `/Users/Zhuanz/...` 或固定窗口坐标，一律走 `config.env`。

## 六、验收四条

1. 结构合规：目录与 `SKILL.md` frontmatter 齐全
2. 隐私扫描：grep 客户名 / 税号 / 账号 / 人名 / 金额 / 鱼鹰号，命中即打回
3. 可移植性：无写死路径、无固定坐标、`*.local.md` 未进版本库
4. `scripts/validate.sh --privacy` 通过（**必带 `--privacy`**：内容级隐私扫描是可选参数，普通 `validate.sh` 不扫内容、等于空跑；白名单 `scripts/privacy-allowlist.txt` 只给「说明性命中」，真实个人信息一律不得放行）

验收责任在 skills 管家；先交样板，验收通过后再按同一模板铺开其余流程。