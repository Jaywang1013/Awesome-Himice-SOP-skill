#!/usr/bin/env python3
"""macOS 极简 GUI 驱动：截图辅助未内置，本文件专做 点击 / 输入 / 按键 / 聚焦。

用法:
  python3 gui.py click <x> <y>      单击（屏幕点坐标）
  python3 gui.py dclick <x> <y>     双击
  python3 gui.py type  <中文或任意文本>   Unicode 方式
  python3 gui.py keys  <ascii文本>        真实键码方式（兼容不吃 Unicode 的 Qt 输入框）
  python3 gui.py key   <return|tab|esc|home|pageup|pagedown|end|cmd_a|space|delete|up|down|left|right>
  python3 gui.py focus               把钉钉提到前台
  python3 gui.py cursor              打印鼠标坐标

钉钉进程名通过同目录 config.env 的 DINGTALK_APP 读取（缺省 DingTalk）。
坐标体系=屏幕点 = 像素/SCREEN_SCALE，与 look*.sh 输出一致。
"""
import ctypes
import os
import subprocess
import sys
import time

# ---- 可配置项：优先环境变量，其次同目录 config.env ----
def _load_app_name():
    env = os.environ.get('HIMICE_DINGTALK_APP')
    if env:
        return env
    cfg = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.env')
    try:
        with open(cfg, encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('DINGTALK_APP='):
                    return line.split('=', 1)[1].strip().strip('"\'')
    except OSError:
        pass
    return 'DingTalk'


DINGTALK_APP = _load_app_name()

cg = ctypes.CDLL('/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics')


class CGPoint(ctypes.Structure):
    _fields_ = [("x", ctypes.c_double), ("y", ctypes.c_double)]


cg.CGEventCreate.restype = ctypes.c_void_p
cg.CGEventGetLocation.argtypes = [ctypes.c_void_p]
cg.CGEventGetLocation.restype = CGPoint
cg.CGEventCreateMouseEvent.restype = ctypes.c_void_p
cg.CGEventCreateMouseEvent.argtypes = [ctypes.c_void_p, ctypes.c_uint32, CGPoint, ctypes.c_uint32]
cg.CGEventCreateKeyboardEvent.restype = ctypes.c_void_p
cg.CGEventCreateKeyboardEvent.argtypes = [ctypes.c_void_p, ctypes.c_uint16, ctypes.c_bool]
cg.CGEventKeyboardSetUnicodeString.argtypes = [ctypes.c_void_p, ctypes.c_ulong, ctypes.c_void_p]
cg.CGEventPost.argtypes = [ctypes.c_uint32, ctypes.c_void_p]

HID = 0

KEYCODES = {
    'return': 36, 'tab': 48, 'esc': 53, 'space': 49, 'delete': 51,
    'home': 115, 'pageup': 116, 'end': 119, 'pagedown': 121,
    'down': 125, 'up': 126, 'left': 123, 'right': 124,
}

KEYMAP = {
    'a': 0, 's': 1, 'd': 2, 'f': 3, 'h': 4, 'g': 5, 'z': 6, 'x': 7, 'c': 8, 'v': 9,
    'b': 11, 'q': 12, 'w': 13, 'e': 14, 'r': 15, 'y': 16, 't': 17,
    '1': 18, '2': 19, '3': 20, '4': 21, '6': 22, '5': 23, '9': 25, '7': 26, '8': 28, '0': 29,
    'o': 31, 'u': 32, 'i': 34, 'p': 35, 'l': 37, 'j': 38, 'k': 40, 'n': 45, 'm': 46,
}


def cursor():
    e = cg.CGEventCreate(None)
    p = cg.CGEventGetLocation(e)
    return (p.x, p.y)


def click(x, y, double=False):
    p = CGPoint(x, y)
    cg.CGEventPost(HID, cg.CGEventCreateMouseEvent(None, 5, p, 0))  # mouseMoved
    time.sleep(0.04)
    for n in ([1, 2, 1, 2] if double else [1, 2]):
        cg.CGEventPost(HID, cg.CGEventCreateMouseEvent(None, n, p, 0))
        time.sleep(0.05)
    time.sleep(0.15)


def type_text(s):
    """Unicode 方式输入，适合中文。"""
    for ch in s:
        raw = ch.encode('utf-16-le')
        buf = ctypes.create_string_buffer(raw, len(raw) + 2)
        for down in (True, False):
            ev = cg.CGEventCreateKeyboardEvent(None, 0, down)
            cg.CGEventKeyboardSetUnicodeString(ev, 1, ctypes.cast(buf, ctypes.c_void_p))
            cg.CGEventPost(HID, ev)
            time.sleep(0.012)
        time.sleep(0.02)


def type_ascii(s):
    """真实键码输入，兼容忽略 Unicode 事件的 Qt 输入框。"""
    for ch in s:
        kc = KEYMAP.get(ch.lower())
        if kc is None:
            continue
        shift = ch.isupper()
        if shift:
            cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, 56, True))
            time.sleep(0.01)
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, kc, True))
        time.sleep(0.012)
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, kc, False))
        time.sleep(0.012)
        if shift:
            cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, 56, False))
            time.sleep(0.01)
        time.sleep(0.03)


def key(name):
    if name == 'cmd_a':
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, 55, True))
        time.sleep(0.02)
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, 0, True))
        time.sleep(0.02)
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, 0, False))
        time.sleep(0.02)
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, 55, False))
    else:
        kc = KEYCODES[name]
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, kc, True))
        cg.CGEventPost(HID, cg.CGEventCreateKeyboardEvent(None, kc, False))
    time.sleep(0.12)


def dclick(x, y):
    click(x, y, double=True)


def scroll(x, y, notches):
    """在 (x,y) 处滚动；notches 正数向上、负数向下。"""
    cg.CGEventCreateScrollWheelEvent.restype = ctypes.c_void_p
    cg.CGEventCreateScrollWheelEvent.argtypes = [
        ctypes.c_void_p, ctypes.c_uint32, ctypes.c_uint32, ctypes.c_int32]
    p = CGPoint(x, y)
    cg.CGEventPost(HID, cg.CGEventCreateMouseEvent(None, 5, p, 0))
    time.sleep(0.2)
    step = 1 if notches > 0 else -1
    for _ in range(abs(notches)):
        cg.CGEventPost(HID, cg.CGEventCreateScrollWheelEvent(None, 0, 1, step * 6))
        time.sleep(0.06)
    time.sleep(0.6)


def focus():
    subprocess.run(
        ['osascript', '-e',
         f'tell application "System Events" to tell process "{DINGTALK_APP}" to set frontmost to true'],
        capture_output=True)
    time.sleep(0.2)


USAGE = """\
用法: python3 gui.py <命令> [参数]

  focus                 把钉钉提到前台（任何点击前都先跑这个）
  cursor                打印鼠标当前位置，格式: (x, y)
  click  <x> <y>        单击指定屏幕点
  dclick <x> <y>        双击指定屏幕点
  type   <文本>         以 Unicode 方式输入（中文、含小数点的金额走这个）
  keys   <拼音串>       以 ASCII 逐键输入，配合 key 选字（如 keys "limeng"）
  key    <键>           按单个键（如 key "1"、key "return"）

坐标一律是「屏幕点」，不是像素；像素除以 config.env 的 SCREEN_SCALE 得到屏幕点。
可用 ./look.sh 或 ./look2.sh 取到各字段的屏幕点坐标。
"""


def fail(msg):
    print(f"ERROR: {msg}", file=sys.stderr)
    sys.exit(2)


def need(args, n, usage):
    """参数不足时明确报错退出，不要抛 IndexError。"""
    if len(args) < n:
        fail(f"参数不足，需要 {n} 个，实际 {len(args)} 个。\n  用法: {usage}")


if __name__ == '__main__':
    args = sys.argv[1:]
    if not args or args[0] in ('-h', '--help', 'help'):
        print(USAGE)
        sys.exit(0 if args else 2)

    cmd, rest = args[0], args[1:]
    if cmd == 'click':
        need(rest, 2, 'gui.py click <x> <y>')
        click(float(rest[0]), float(rest[1]))
    elif cmd == 'dclick':
        need(rest, 2, 'gui.py dclick <x> <y>')
        click(float(rest[0]), float(rest[1]), double=True)
    elif cmd == 'type':
        need(rest, 1, 'gui.py type <文本>')
        type_text(rest[0])
    elif cmd == 'keys':
        need(rest, 1, 'gui.py keys <拼音串>')
        type_ascii(rest[0])
    elif cmd == 'key':
        need(rest, 1, 'gui.py key <键>')
        key(rest[0])
    elif cmd == 'focus':
        focus()
    elif cmd == 'cursor':
        print(cursor())
    else:
        # 未知命令必须非 0 退出：静默啥也不做会被上层当成"这步成功了"
        fail(f"未知命令: {cmd}\n\n{USAGE}")