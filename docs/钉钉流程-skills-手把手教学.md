# 钉钉流程 Skills 手把手教学

> 适用：Himice 同事，在 macOS 上用 Codex / DeepSeek Harness（DSH）/ Claude Code 代填钉钉审批单。
> 本教学覆盖 4 个流程 + 1 个公共工具包。

---

## 一、这套东西是什么

| Skill | 干什么 | 停在哪儿 |
| --- | --- | --- |
| `himice-dingtalk-budget-approval` | 代填「项目预算审批单（厦门）」 | 停在提交前 |
| `himice-dingtalk-loan-application` | 代填「项目借款单（厦门）」 | 停在提交前 |
| `himice-dingtalk-payment-application` | 代填「项目类付款申请（厦门）」 | 停在提交前 |
| `himice-dingtalk-seal-application` | 代填「用印申请」，并按项目归档 | 停在提交前 |
| `himice-dingtalk-cua-toolkit` | 前四个的公共工具包（截图 / OCR / 点击 / 输入） | — |

**一条铁律：四个流程都不会替你点「提交」。** 它们把表单填好、把字段列给你核对，最后一步由你自己点。

---

## 二、前置条件（缺一不可）

1. **macOS + 钉钉桌面客户端已登录**（用的是 Qt 自绘界面，所以只能靠截图 + OCR，读不到控件树）
2. **系统权限**：系统设置 → 隐私与安全性 →
   - **辅助功能**：允许你的 Agent（DeepSeek Harness / Codex / 终端）
   - **屏幕录制**：同上
   - 授权后**重启 App** 才生效
3. **保持屏幕常亮**：`caffeinate -d -i -t 7200 &`（锁屏后 OCR 只能读到锁屏时间）
4. **钉钉窗口固定**：默认按 `(30,45) 1086×832` 校准；你若移动或缩放窗口，要改 `config.env`（见第六节）
5. **Xcode 命令行工具**（`swiftc`）：`xcode-select --install`，用于编译 OCR 工具

---

## 三、拉仓库

```bash
git clone https://github.com/Jaywang1013/Awesome-Himice-SOP-skill.git
cd Awesome-Himice-SOP-skill
```

---

## 四、安装

**注意：钉钉流程 skill 与工具包属于 `general` 包**（`core` 只装预算/备用金/报销等核心 SOP，不含钉钉代填）。

先预览，再正式装（安装脚本不会覆盖你已有的 skill 目录）：

```bash
# DSH
bash scripts/install.sh --platform dsh --bundle general --dry-run
bash scripts/install.sh --platform dsh --bundle general

# Codex
bash scripts/install.sh --platform codex --bundle general

# Claude Code
bash scripts/install.sh --platform claude-code --bundle general

# 想核心 SOP 和钉钉流程一起装，用 --bundle all
```

装完应能看到这 5 个目录落到 `~/.dsh/skills/`（Codex 则是 `~/.codex/skills/`）：
`himice-dingtalk-cua-toolkit`、`-budget-approval`、`-loan-application`、`-payment-application`、`-seal-application`。

**重启你的 Agent**，然后用 `/himice-dingtalk-...` 或直接说需求调用。

---

## 五、编译工具包（第一次必做）

工具包的 OCR 是 Swift 源码，需要在你机器上编译一次：

```bash
cd ~/.dsh/skills/himice-dingtalk-cua-toolkit   # Codex 则在 ~/.codex/skills/
bash install.sh
```

它会：编译出 `bin/ocr`、`bin/pdf2png`，给 `look*.sh` 加执行权限，并从 `config.env.example` 生成 `config.env`。

**自检三条**（在工具包目录里跑）：

```bash
# 1) 屏幕录制权限通了没有
screencapture -x /tmp/t.png && echo "截图 OK"

# 2) OCR 能否识别（ocr 接受图片路径，输出「屏幕点 x y 文本」）
bin/ocr /tmp/t.png | head -3

# 3) 能否读到钉钉窗口文字（会先把钉钉提到前台再截图识别）
bash look.sh | head -5
```

> 注意：`/tmp` 会被系统清理，重启后 `bin/` 若丢失，重跑一次工具包的 `install.sh`。

---

## 六、配置你自己的默认值

**不要把个人信息写进仓库。** 每个流程 skill 都有一份 `field-mapping.example.md`（占位符模板）和 `field-mapping.md`（字段规则，可进库）。你要做的是**在本地建 `field-mapping.local.md`**：

```bash
cd ~/.dsh/skills/himice-dingtalk-payment-application/references
cp field-mapping.example.md field-mapping.local.md
# 然后用编辑器填：申请人、部门、默认公司、常用鱼鹰号别名等
```

`*.local.md` 已被仓库 `.gitignore` 覆盖，**永远不要提交**。

窗口坐标、OCR 路径等则写在工具包的 `config.env` 里：

| 配置项 | 含义 |
| --- | --- |
| `WIN_X / WIN_Y / WIN_W / WIN_H` | 钉钉窗口位置与尺寸（默认 `30 / 45 / 1086 / 832`） |
| `SCREEN_SCALE` | Retina 倍率（屏幕点 = 像素 / 该值，默认 2） |
| `CROP_W / CROP_H / CROP_OFFSET_X / CROP_OFFSET_Y` | 全屏截图后裁切到钉钉窗口的范围 |
| `DINGTALK_APP` | 钉钉进程名（默认 `DingTalk`） |
| `TMP_DIR` | 截图临时目录（默认 `/tmp`） |
| `TOOLKIT_DIR` | 工具包自身路径 |
| `OCR_BIN` | 编译产物 `bin/ocr` 的路径 |

---

## 七、四个流程怎么用

通用套路：**你把材料丢给它 → 它读、它填、它列字段给你核对 → 你点提交。**

### 1. 项目预算审批单

- 给它：项目预算表（xlsx）
- 它做：读收入/成本/操作费用，填客户、鱼鹰号、执行时间地点、负责人、项目类型，上传预算表与预估协作人审批表
- 注意：**行号会随项目变化**，它取数前会先核标签（`F64/F65/J52` 只是默认锚点）

### 2. 项目借款单

- 给它：项目预算表的**用款申请表**
- 它做：只取**现金档**（待转帐走对公、刷卡走对公，只有现金无法转账才需备用金），填申请人、负责人、鱼鹰号、收款人与银行账户
- 注意：**收款账户只放本地 `.local.md`；账号必须由发起人当次提供，不得沿用历史值**

### 3. 项目类付款申请

- 给它：群消息式信息（付给谁、多少钱）+ 合同 / 发票 / 结算单
- 它做：OCR 提金额与开票方、模糊匹配鱼鹰号、填费用类别与付款日期、挂附件
- 注意：金额**必须人工确认**；合同与发票金额不一致它会**直接报警**，不会替你二选一

### 4. 用印申请

- 给它：待盖章的合同/文件
- 它做：提取对方单位全称、金额、份数，拼文件名，填管控分类，上传原件；提交后归档到 `用印流程-{鱼鹰号}-{项目名称}/`
- 两个**必问不取默认**的项：跨公司用集团（海口）章时选**电子章还是实体章**、**是否需要原件**

---

## 八、安全铁律（这几条别绕）

1. **不自动提交**：四个流程一律停在提交前，最后一步由你点
2. **金额不臆造**：读不出就问；合同≠发票金额时报警
3. **缺件明说**：允许"发票后补"这类，但必须在备注显式写，不许静默提交
4. **不推测审批状态**：机器人读不到钉钉审批进度，节点只能由你告知或给截图
5. **本地值不进库**：`*.local.md`、截图、合同 PDF、发票一律不提交

---

## 九、常见故障

| 现象 | 原因 | 处置 |
| --- | --- | --- |
| 点不中、点空 | DSH 窗口抢了焦点 | 工具每次操作前会 `focus()` 钉钉；操作期间人别碰电脑 |
| OCR 只读到锁屏时间 | 屏幕锁了 | 跑 `caffeinate -d -i -t 7200 &` |
| 截图报 `could not create image from rect` | 本机 macOS 已知问题 | 已改为全屏截 + 裁切，若仍失败检查屏幕录制权限 |
| 坐标整体偏移 | 钉钉窗口被移动/缩放 | 改 `config.env` 的 `WIN_*` |
| 日期选择器点不到 | 日历是第二层浮层，被窗口底边裁掉 | 把光标移到日历外再滚动 |
| 附件传完没挂上 | 上传面板需要**再点一次「确定」**才回写 | 看到"上传完成"后点面板确定；重复操作会产生重复附件 |
| 模板点错（如点了「非项目采购借款」） | 搜索结果横向并排三项 | **立即关闭重开**，不要在错模板上继续填 |
| 中文输不进去 | 钉钉这些字段是拼音联想式 | 打拼音 → 按数字键选字 |

---

## 十、更新与维护

```bash
cd Awesome-Himice-SOP-skill
git pull
bash scripts/install.sh --platform dsh --bundle core
```

安装脚本**不覆盖**已有目录——更新前先备份或手动移除旧 skill 目录，再重装。

---

## 十一、这个仓库的隐私边界

仓库是**公开**的，规则见 `docs/public-repository-safety.md`。一句话：

- **不进库**：客户名称、税号、合同、报价、预算、发票、支付截图、录音、员工电话、账户、API Key、`.env`、运行日志
- **进库**：空白模板、脱敏示例、通用业务规则、不含业务数据的脚本
- 已批准的行业基线（如 `projects/mice-bid-enterprise-directory/`）单列管理，带来源口径、核验状态、使用边界与校验和；其联络字段仅用于核验或获授权业务联系，**禁止导出为批量营销名单**

自查命令（发 PR 前跑一遍）：

```bash
bash scripts/validate.sh            # 结构与跟踪文件检查
bash scripts/validate.sh --privacy  # 内容级隐私扫描（必带 --privacy，否则只做结构检查）
```