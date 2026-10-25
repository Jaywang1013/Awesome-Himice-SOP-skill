#!/bin/bash
# 全屏截图 + OCR，输出: 屏幕点坐标 x y 文本
set -euo pipefail
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
[ -f "$DIR/config.env" ] && . "$DIR/config.env"
: "${TMP_DIR:=/tmp}"
: "${OCR_BIN:=$DIR/bin/ocr}"
: "${SCREEN_SCALE:=2}"

screencapture -x "$TMP_DIR/_h_toolkit_s.png"
"$OCR_BIN" "$TMP_DIR/_h_toolkit_s.png" 2>&1 \
  | awk -F'\t' -v OFS='\t' -v s="$SCREEN_SCALE" \
      '{printf "%.0f\t%.0f\t%.0f\t%.0f\t%s\n", ($1+$3/2)/s, ($2+$4/2)/s, $3, $4, $5}'
