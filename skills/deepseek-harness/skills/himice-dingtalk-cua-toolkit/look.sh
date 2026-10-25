#!/bin/bash
# 提升钉钉到前台 -> 全屏截图 -> 裁切 -> OCR，输出: 屏幕点坐标 x y 文本
# 依赖同目录 config.env（由 install.sh 生成，或用 config.env.example 复制）
set -euo pipefail
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
[ -f "$DIR/config.env" ] && . "$DIR/config.env"
: "${DINGTALK_APP:=DingTalk}"
: "${TMP_DIR:=/tmp}"
: "${OCR_BIN:=$DIR/bin/ocr}"
: "${CROP_W:=2172}" "${CROP_H:=1664}" "${CROP_OFFSET_X:=60}" "${CROP_OFFSET_Y:=90}"
: "${SCREEN_SCALE:=2}"

osascript -e "tell application \"System Events\" to tell process \"$DINGTALK_APP\" to set frontmost to true" >/dev/null 2>&1
osascript -e "tell application \"System Events\" to tell process \"$DINGTALK_APP\" to perform action \"AXRaise\" of window 1" >/dev/null 2>&1
sleep 0.55
screencapture -x "$TMP_DIR/_h_toolkit_f.png"
sips -c "$CROP_H" "$CROP_W" --cropOffset "$CROP_OFFSET_Y" "$CROP_OFFSET_X" \
  "$TMP_DIR/_h_toolkit_f.png" --out "$TMP_DIR/_h_toolkit_d.png" >/dev/null 2>&1
"$OCR_BIN" "$TMP_DIR/_h_toolkit_d.png" 2>&1 \
  | awk -F'\t' -v OFS='\t' -v ox="$CROP_OFFSET_X" -v oy="$CROP_OFFSET_Y" -v s="$SCREEN_SCALE" \
      '{printf "%.0f\t%.0f\t%.0f\t%.0f\t%s\n", ($1+$3/2+ox)/s, ($2+$4/2+oy)/s, $3, $4, $5}'
