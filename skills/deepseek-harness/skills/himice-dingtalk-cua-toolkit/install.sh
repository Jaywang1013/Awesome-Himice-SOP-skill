#!/usr/bin/env bash
# himice-dingtalk-cua-toolkit 安装/初始化
# 1) swiftc 编译 ocr / pdf2png 到 bin/
# 2) chmod +x 各脚本
# 3) 若不存在 config.env，从 config.env.example 复制生成（并提示按本机修改）
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

BIN_DIR="$DIR/bin"
mkdir -p "$BIN_DIR"

echo "==> 编译 ocr（Vision OCR）"
if command -v swiftc >/dev/null 2>&1; then
  swiftc -O ocr.swift -o "$BIN_DIR/ocr"
else
  echo "!! 未找到 swiftc，跳过编译；请确保 \$BIN_DIR/ocr 存在" >&2
fi

echo "==> 编译 pdf2png"
if command -v swiftc >/dev/null 2>&1; then
  swiftc -O pdf2png.swift -o "$BIN_DIR/pdf2png"
else
  echo "!! 未找到 swiftc，跳过编译；请确保 \$BIN_DIR/pdf2png 存在" >&2
fi

echo "==> chmod 脚本"
chmod +x gui.py look.sh look2.sh lookfull.sh "$BIN_DIR/ocr" "$BIN_DIR/pdf2png" 2>/dev/null || true

if [[ ! -f "$DIR/config.env" ]]; then
  cp config.env.example config.env
  echo "==> 已由 config.env.example 生成 config.env"
  echo "==> 首次使用请打开 config.env，按本机屏幕/窗口情况修改："
  echo "     钉钉进程名(DINGTALK_APP)、窗口基准(WIN_*)、Retina倍率(SCREEN_SCALE)、裁切偏移(CROP_*)"
else
  echo "==> config.env 已存在，未覆盖"
fi

echo
echo "✔ 完成。可先验证："
echo "    $DIR/bin/ocr --help   （或直接跑 ./look.sh 看是否输出 OCR 坐标）"
echo "    注意每台机器要单独跑一次本 install.sh，并按 config.env 校准坐标。"