# himice-dingtalk-cua-toolkit

钉钉 macOS 桌面客户端（Qt 自绘）的基础 GUI 自动化工具包：截图 → Vision OCR → 模拟点击/输入。
供 `himice-dingtalk-*` 各流程 skill 共同引用，避免每个流程各自重复一堆坐标与脚本。

> 平台：仅 **macOS**（依赖 Apple Vision / CGEvent）。Windows 同事请改用
> windows-mcp 或 cua-gui-automation，本工具包不适用。

## 组成

| 文件 | 作用 |
|---|---|
| `gui.py` | 点击 / 输入 / 按键 / 聚焦钉钉（读 config.env 的 DINGTALK_APP） |
| `look.sh` | 聚焦钉钉 → 全窗截图 → 裁切 → OCR，输出屏幕点坐标 |
| `look2.sh <左 上 宽 高>` | 聚焦钉钉 → 截指定局部区域 → OCR |
| `lookfull.sh` | 全屏截图 → OCR |
| `ocr.swift` / `pdf2png.swift` | 编译源（install.sh 编译） |
| `config.env(.example)` | 所有参数集中配置 |
| `install.sh` | 一次性初始化：编译 + chmod + 生成 config.env |

## 安装（每台机器跑一次）

```bash
bash install.sh
```

## 三件前置（缺一不可）

1. **辅助功能**：系统设置 → 隐私与安全性 → 辅助功能 → 允许 DeepSeek Harness
2. **屏幕录制**：系统设置 → 隐私与安全性 → 屏幕录制 → 允许 DeepSeek Harness
  
   授权后 App 会自动重启。验证：
   ```bash
   screencapture -x /tmp/t.png && echo 截图OK
   python3 -c "import ctypes;a=ctypes.CDLL('/System/Library/Frameworks/ApplicationServices.framework/ApplicationServices');a.AXIsProcessTrusted.restype=ctypes.c_bool;print('辅助功能',a.AXIsProcessTrusted())"
   ```
3. **保持屏幕常亮**（否则锁屏后 OCR 只读到锁屏时间）：
   ```bash
   caffeinate -d -i -t 7200 &
   ```

## 坐标体系

- **钉钉窗口基准**（屏幕点）：见 `config.env` 的 `WIN_X / WIN_Y / WIN_W / WIN_H`
- **屏幕点 = 像素 / SCREEN_SCALE**（2x Retina 用 2）
- `look*.sh` 输出的已是**屏幕点坐标**，可直接喂给 `gui.py` 点击

## 配置项（config.env，首次 install.sh 后按本机修改）

| 键 | 含义 | 示例 |
|---|---|---|
| `DINGTALK_APP` | 钉钉进程名（聚焦用） | `DingTalk` |
| `TMP_DIR` | 临时截图目录 | `/tmp` |
| `OCR_BIN` / `PDF2PNG_BIN` | 编译后的二进制路径 | `<toolkit>/bin/ocr` |
| `WIN_X/WIN_Y/WIN_W/WIN_H` | 钉钉窗口屏幕点基准 | `30 45 1086 832` |
| `SCREEN_SCALE` | Retina 倍率 | `2` |
| `CROP_W/CROP_H/CROP_OFFSET_X/CROP_OFFSET_Y` | `look.sh` 全窗裁切（像素） | `2172 1664 60 90` |

> 关键：**换机器必须重跑 install.sh 并校准坐标**。坐标现截图现点，不要硬编码在任何流程 skill 里。

## 最小用例

```bash
# 聚焦钉钉 + 全窗 OCR（拿到各字段的屏幕点坐标）
./look.sh

# 局部 OCR：左上(400,200)起 宽500 高300（屏幕点）
./look2.sh 400 200 500 300

# 点击文本框（右侧空白区，Qt 自绘框要点右半）
python3 gui.py focus
python3 gui.py click 600 260

# 输入（中文走顶层候选时用 keys 打拼音+数字；纯文本用 type）
python3 gui.py keys "limeng"
python3 gui.py key "1"
python3 gui.py type "酒店费用预付款"

# 提交：取消在左、确定在右（右下角）
python3 gui.py click 980 800

# 看鼠标当前位置
python3 gui.py cursor
```

## 已知坑（Qt 自绘钉钉）

- 输入框要**点右半空白区**才聚焦，点「请输入」占位符无效
- 下拉列表：滚轮滚的是表单不是列表，要把鼠标**悬停到列表项上**再滚
- 打开表单会**自动载入上次未发布草稿**，先点「清除内容」
- **含小数点的金额**不能用 `keys`（KEYMAP 缺小数点），走 `type`（Unicode）否则丢小数点
- 「申请日期」日历浮层会被窗口底边裁断，需把鼠标移到日历外滚动让整块上移
- 任何一步前先 `gui.py focus`，否则 DSH 会抢焦点导致点空

> 更细的字段级操作（每个流程按钮在哪、填什么）在各流程 skill
> （`himice-dingtalk-*-application`）的 references 里，本工具包保持通用、不含任何客户数据。