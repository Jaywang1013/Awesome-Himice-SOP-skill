#!/bin/bash
# 用法: look2.sh <左点> <上点> <宽点> <高点>  先聚焦钉钉再截该区域并OCR
# 输入为「屏幕点」坐标；内部转像素像素后裁切，输出仍为屏幕点。
set -euo pipefail
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
[ -f "$DIR/config.env" ] && . "$DIR/config.env"
: "${DINGTALK_APP:=DingTalk}"
: "${TMP_DIR:=/tmp}"
: "${OCR_BIN:=$DIR/bin/ocr}"
: "${SCREEN_SCALE:=2}"

osascript -e "tell application \"System Events\" to tell process \"$DINGTALK_APP\" to set frontmost to true" >/dev/null 2>&1
osascript -e "tell application \"System Events\" to tell process \"$DINGTALK_APP\" to perform action \"AXRaise\" of window 1" >/dev/null 2>&1
sleep 0.45
OX=$(python3 -c "print(int(${1:-0}*$SCREEN_SCALE))")
OY=$(python3 -c "print(int(${2:-0}*$SCREEN_SCALE))")
W=$(python3 -c "print(int(${3:-0}*$SCREEN_SCALE))")
H=$(python3 -c "print(int(${4:-0}*$SCREEN_SCALE))")
screencapture -x "$TMP_DIR/_h_toolkit_g.png"
sips -c "$H" "$W" --cropOffset "$OY" "$OX" \
  "$TMP_DIR/_h_toolkit_g.png" --out "$TMP_DIR/_h_toolkit_h.png" >/dev/null 2>&1
"$OCR_BIN" "$TMP_DIR/_h_toolkit_h.png" 2>&1 \
  | awk -F'\t' -v OFS='\t' -v ox="$OX" -v oy="$OY" -v s="$SCREEN_SCALE" \
      '{printf "%.0f\t%.0f\t%.0f\t%.0f\t%s\n", ($1+$3/2+ox)/s, ($2+$4/2+oy)/s, $3, $4, $5}'
