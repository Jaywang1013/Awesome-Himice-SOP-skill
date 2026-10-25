---
name: himice-dingtalk-cua-toolkit
description: 钉钉 macOS 桌面客户端（Qt 自绘）的基础 GUI 自动化工具包。提供截图→Vision OCR→点击/输入/聚焦的公共命令（look.sh/look2.sh/lookfull.sh+gui.py），所有路径与坐标都从 config.env 参数化读取。当需要在钉钉客户端里点按钮、填表单、OCR 读屏幕字段，或编写 himice-dingtalk-* 流程 skill 需要底层控件操作时使用；也作为其他流程 skill 的公共依赖。
whenToUse: 需要对 macOS 钉钉客户端做 GUI 自动化（截图识别/点击/输入）；编写或调试 himice-dingtalk-payment-application、himice-dingtalk-seal-application、预算审批、借款单等流程 skill 时引用本工具包。
---

# himice-dingtalk-cua-toolkit

钉钉 macOS 桌面应用的通用 CUA（Computer-Use Automation）基础层。

> 定位：**公共工具层**，不承载任何业务字段规则。字段级操作交给各流程 skill。

## 载体放这里

- 本目录是工具包本体：`gui.py`、`look*.sh`、`ocr.swift`、`pdf2png.swift`、`install.sh`、`config.env(.example)`、`README.md`
- 完整说明、前置权限、坐标体系、已知坑见 `README.md`

## 使用流程（每台机器首次）

1. 跑 `bash install.sh` —— 编译 `bin/ocr`、`bin/pdf2png`，`chmod`，生成 `config.env`
2. 打开 `config.env` 按本机校准：`DINGTALK_APP`、`WIN_*`、`SCREEN_SCALE`、`CROP_*`
3. 系统授权：辅助功能 + 屏幕录制（允许 DeepSeek Harness）
4. `caffeinate -d -i -t 7200 &` 保持屏幕常亮

## 调用惯例（嵌入流程 skill 时的约定）

- **任何 GUI 操作前先 `gui.py focus`**（DSH 会抢焦点）
- 坐标一律「现截图现点」：`look2.sh left top width height` 拿到屏幕点 → `gui.py click x y`
- 每步截图验证，别盲点
- 中文/特殊字符输入用 `gui.py type`；拼音候选式输入用 `gui.py keys"拼音"` + `gui.py key "数字"`
- 金额等含小数点必须用 `type`（Unicode），不能用 `keys`
- **不要在本工具包或任何流程 skill 里写死 `/Users/Zhuanz/...` 或固定坐标**——必须走 config.env

## 各 flow skill 引用本工具包的方式

流程 skill 的 `SKILL.md` 内直接调用：
```bash
TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
# 若流程 skill 与 toolkit 同仓部署，通常路径为：
#   <repo>/skills/deepseek-harness/skills/himice-dingtalk-cua-toolkit
python3 "$TOOLKIT_DIR/gui.py" focus
bash "$TOOLKIT_DIR/look2.sh" 400 200 500 300
```

实际引用路径由部署时决定，流程 skill 应通过相对仓库根的路径或配置解析，禁止硬编码个人主目录。