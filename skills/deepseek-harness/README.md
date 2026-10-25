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

### 并发写入：一个包同一时间只由一人改

多个 agent 共享同一工作区时，**一个 skill 包同一时间只应有一个写入者**。动手前先确认该包当前归谁改；**确认不了就「先读 → 确认 → 后写」**。

只"动手前确认"挡不住时序差——常见情形是**读的时候文件还没变、写的时候已经变了**。真正的闸门是写完前再核一次版本：`FS_STALE_VERSION` 就是这道闸门的报错，**它不是障碍、是提示**——重读后在新版本上重做编辑，**永远不要覆盖**。

危险的不是冲突而是**静默覆盖**：冲突会报错，覆盖不会。两个 agent 各改一处、位置恰好不重叠时，两边都"成功"，内容却悄悄少了一半，事后无从查证。**恰好不重叠是运气，不是安全。**

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

> ⚠️ **验收前先确认待验包已 `git add` 入库**。`--privacy` 只扫 `git ls-files` 出来的文件，**未跟踪的文件扫不到**——那种情况下会得到假 PASS（假绿）。已在别处验证过的泄漏文件如果没入库，扫描器一样放行。
>
> 已批准公开基线的豁免走 `scripts/approved-baselines.txt`（路径 + SHA-256 双条件，校验和不符即 FAIL）；`skills/` 与 `integrations/` 永不豁免。隐私工具链自身（`privacy-scan.rb`、白名单、基线清单）不参与内容扫描。

### 关于「正面引用禁令」产生的登记性白名单

`skills/` 永不整文件豁免（可分发面从严）。副作用是：**任何 skill 文档只要正面写出本机路径禁令，就必然在 `--privacy` 产生一条命中**，必须按**行内特征片段**登记进 `scripts/privacy-allowlist.txt`，否则 `--privacy` 变红。

**约定：保留原文、登记白名单，不改写措辞。** 理由——`/Users/<user>/...` 之类改写一眼看不出禁令针对谁的本机，`~/...` 更会被读成可选简写；禁令的可读性比少一条白名单更重要。而白名单是显式、带注释、进版本库的，**可审计**；改写等于把风险藏进措辞。

**登记用片段、不用行号**：`路径:行号` 会因别的段落插入而漂移失效（实测：toolkit 的 `SKILL.md` 前面加一节后，原 `:32` 失效、`--privacy` 直接变红）。现有 2 条都是片段——`不要在本工具包或任何流程 skill 里写死`（toolkit 教学句）与 `仓库中不得出现`（本文件规则自指）。片段必须足够特异，**绝不能登记成本机用户主目录的裸路径模式**（那等于全仓放行）。新增引用该禁令的文档时顺手登记片段即可。

### 几条同源盲区（工具报成功 ≠ 结果成立）

这四条其实是同一句话：**「通过了」只是某个工具在某一步没报错，不等于要的结果成立。** 报结论时把**范围、ref、工具**一起带上才算数。

| 盲区 | 假象 | 实质 |
| --- | --- | --- |
| 未跟踪 | 扫不到 → PASS | 假绿（没 `git add`，`--privacy` 放行） |
| 在分支上 | 扫到了 → 结论成立 | 未生效于主干，闭环未完成（「在分支上 ≠ 已进 main」） |
| `git fetch` 成功 | 报成功 | 对象未必齐全——远端跟踪 ref 已存在时 git 不再向远端索要，合并报 `unable to read sha1 file`；先 `git update-ref -d refs/remotes/origin/main` 再 fetch |
| 扫描「零命中」 | 报零 | 必须带工具口径：扫描器（带片段式白名单）与裸 grep 的「零」不是同一个零 |
| 自称「以 origin/main 为准」 | 报的是远端真值 | `origin/main` 是**本地缓存**，只在 `git fetch` 后更新。不 fetch 就 `git rev-parse origin/main`，看到的是上次 fetch 的快照——断言「远端状态是 X」前必须先 `git fetch && git rev-parse origin/main` |
| 已 `fetch` 过就信 `origin/main` | 刚 fetch 了，值一定对 | **fetch 也可能没生效**。「远端到底有什么」的权威值只在 `git ls-remote origin <ref>`——它直接问远端、不经过本地缓存。涉及「某提交推没推上去」这类判断，用 `git ls-remote`，不要用 `git rev-parse origin/main` |

**另有一条实测过的编码坑（同属「工具自己那步成功」）**：`privacy-scan.rb` 用 `File.read(mode: 'rb')` 读入是 `ASCII-8BIT`，与白名单里含**中文文件名**的 UTF-8 键比较会抛 `Encoding::CompatibilityError`；修法是在读取处把每行 `force_encoding(Encoding::UTF_8)`。**该 bug 只在文件名含非 ASCII 时触发**，纯 ASCII 文件名（`skills/` 下多数文件）不漏网——所以 `skills/` 面全绿不代表安全，一旦有中文名文档进库（如 `docs/*教学.md`）就会崩。改扫描器后务必用一个**中文文件名**的假泄漏文件做反向验证。

**样本的「形态覆盖」也是覆盖的一部分**：上面那条 bug 漏网的根因不是没人测，而是**测试样本的文件名全是 ASCII**——同一段逻辑，换个文件名形态就从「通过」变「崩溃」。反向验证不要只用 `test.md` / `LEAKTEST.md` 这类英文名，至少各带一个**中文名**与一个**含空格或括号的路径**。零命中/全绿之前先问一句：样本形态够不够杂？

**最常犯的一条：把自己的观察范围当成全体。** 上面几条盲区可以归到同一个根——**只看了自己碰过的那部分，就替全体下结论**。「未跟踪 = 假 PASS」是只扫了自己的文件，「裸 grep 报假阳性」是只信自己的工具不发口径，「说某几处不一致」是只量了自己熟的包就概括四个包。**说「某某不一致 / 某某都通过」之前，先把范围量全，尤其要包含自己没碰过的部分**；被自己范围之外的事推翻过，就是这一条。

**验相对引用时，基准目录按「引用所在的文件」算**，不按仓库根或包根算：`../../x.md` 写在 `references/y.md` 里，就要从 `references/` 起算。基准算错会得到一整批假「broken link」，而且看起来像真的。量错了基准，量出来的结论就是错的。

验收责任在 skills 管家；先交样板，验收通过后再按同一模板铺开其余流程。
