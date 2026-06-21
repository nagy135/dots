#!/usr/bin/env bash
set -u

# Decode every file in the current directory that is parseable as either:
#   - gzip-compressed JSON, or
#   - plain JSON
# For each parseable Raycast export, write: <filename-without-extension>-keybinds.json
# Output format is a simple object: { "Command Title": "Hotkey" }

shopt -s nullglob

python3 - "$PWD" <<'PY'
import gzip
import json
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])

SKIP_NAMES = {"parse.sh"}
SKIP_SUFFIXES = {"-keybinds.json"}


def output_path(path: Path) -> Path:
    if path.suffix:
        stem = path.with_suffix("").name
    else:
        stem = path.name
    return path.with_name(f"{stem}-keybinds.json")


def decode_json(path: Path):
    data = path.read_bytes()

    # Raycast's parseable .rayconfig exports are gzip-compressed JSON.
    try:
        data = gzip.decompress(data)
    except Exception:
        pass

    try:
        return json.loads(data.decode("utf-8"))
    except Exception:
        return None


def collect_title_lookup(obj):
    lookup = {}

    def walk(x):
        if isinstance(x, dict):
            key = x.get("key")
            title = x.get("title")
            if isinstance(key, str) and isinstance(title, str):
                lookup.setdefault(key, title)
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)

    walk(obj)
    return lookup


def title_for_item(item, lookup):
    key = item.get("key")
    if isinstance(key, str) and key in lookup:
        return lookup[key]

    title = item.get("title")
    if isinstance(title, str) and title:
        return title

    path = item.get("path")
    if isinstance(path, str) and path:
        name = path.rstrip("/").split("/")[-1]
        for suffix in (".app", ".appex"):
            if name.endswith(suffix):
                name = name[: -len(suffix)]
        if name:
            return name

    if isinstance(key, str) and key:
        return key

    return None


KEYCODE_TO_KEY = {
    "0": "A", "1": "S", "2": "D", "3": "F", "4": "H", "5": "G", "6": "Z", "7": "X",
    "8": "C", "9": "V", "11": "B", "12": "Q", "13": "W", "14": "E", "15": "R",
    "16": "Y", "17": "T", "18": "1", "19": "2", "20": "3", "21": "4", "22": "6",
    "23": "5", "24": "=", "25": "9", "26": "7", "27": "-", "28": "8", "29": "0",
    "30": "]", "31": "O", "32": "U", "33": "[", "34": "I", "35": "P", "36": "Return",
    "37": "L", "38": "J", "39": "'", "40": "K", "41": ";", "42": "\\", "43": ",",
    "44": "/", "45": "N", "46": "M", "47": ".", "48": "Tab", "49": "Space", "50": "`",
    "51": "Delete", "53": "Escape", "54": "Right Command", "55": "Command", "56": "Shift",
    "57": "Caps Lock", "58": "Option", "59": "Control", "60": "Right Shift", "61": "Right Option",
    "62": "Right Control", "63": "Fn",
    "64": "F17", "65": ".", "67": "*", "69": "+", "71": "Clear", "75": "/", "76": "Enter",
    "78": "-", "79": "F18", "80": "F19", "81": "=", "82": "0", "83": "1", "84": "2",
    "85": "3", "86": "4", "87": "5", "88": "6", "89": "7", "91": "8", "92": "9",
    "96": "F5", "97": "F6", "98": "F7", "99": "F3", "100": "F8", "101": "F9",
    "103": "F11", "105": "F13", "106": "F16", "107": "F14", "109": "F10", "111": "F12",
    "113": "F15", "114": "Help", "115": "Home", "116": "Page Up", "117": "Forward Delete",
    "118": "F4", "119": "End", "120": "F2", "121": "Page Down", "122": "F1", "123": "Left",
    "124": "Right", "125": "Down", "126": "Up",
}


MODIFIER_MAP = {
    "Command": "cmd",
    "Option": "alt",
    "Control": "ctrl",
    "Shift": "shift",
}
MODIFIER_ORDER = ["cmd", "alt", "ctrl", "shift"]


def normalize_key_name(key: str) -> str:
    key = KEYCODE_TO_KEY.get(key, key)
    special = {
        "Return": "enter",
        "Escape": "esc",
        "Delete": "backspace",
        "Forward Delete": "delete",
        "Space": "space",
        "Tab": "tab",
        "Left": "left",
        "Right": "right",
        "Up": "up",
        "Down": "down",
        "Page Up": "pageup",
        "Page Down": "pagedown",
        "Home": "home",
        "End": "end",
    }
    return special.get(key, key.lower().replace(" ", ""))


def normalize_hotkey(hotkey: str) -> str:
    # Raycast exports hotkeys as modifier names plus macOS virtual key codes.
    # Example: Option-19 is alt+2, Option-13 is alt+w.
    parts = hotkey.split("-")
    if not parts:
        return hotkey.lower()

    raw_mods = parts[:-1]
    raw_key = parts[-1]

    mods = []
    for mod in raw_mods:
        mapped = MODIFIER_MAP.get(mod, mod.lower())
        if mapped not in mods:
            mods.append(mapped)

    # Stable requested format: cmd+alt+ctrl+shift+h
    ordered_mods = [m for m in MODIFIER_ORDER if m in mods]
    ordered_mods.extend(m for m in mods if m not in ordered_mods)

    return "+".join(ordered_mods + [normalize_key_name(raw_key)])


UUID_RE = re.compile(r"(?:__|[-_])?[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")


def clean_output_key(title: str) -> str:
    # Raycast extension command IDs can end in UUID suffixes like:
    #   extension_foo.bar__40ebc708-964f-473b-8d19-d4e9cbd27ae9
    # Strip that unstable suffix for cleaner downstream keys.
    title = UUID_RE.sub("", title)
    return title.rstrip("_- ")


def extract_keybinds(obj):
    lookup = collect_title_lookup(obj)
    keybinds = {}

    def add_item(item):
        hotkey = item.get("hotkey")
        if not isinstance(hotkey, str) or not hotkey:
            return
        title = title_for_item(item, lookup)
        if not title:
            return
        title = clean_output_key(title)

        # Keep JSON as a simple key:value object, but avoid silently dropping
        # duplicates by appending the Raycast key when needed.
        out_key = title
        if out_key in keybinds and keybinds[out_key] != hotkey:
            raycast_key = item.get("key")
            if isinstance(raycast_key, str) and raycast_key:
                out_key = f"{title} ({raycast_key})"
            else:
                i = 2
                while f"{title} ({i})" in keybinds:
                    i += 1
                out_key = f"{title} ({i})"

        keybinds[out_key] = normalize_hotkey(hotkey)

    root_search = obj.get("builtin_package_rootSearch", {}).get("rootSearch") if isinstance(obj, dict) else None
    if isinstance(root_search, list):
        for item in root_search:
            if isinstance(item, dict):
                add_item(item)
    else:
        # Fallback for future export shapes: find any dict with a hotkey.
        def walk(x):
            if isinstance(x, dict):
                add_item(x)
                for v in x.values():
                    walk(v)
            elif isinstance(x, list):
                for v in x:
                    walk(v)
        walk(obj)

    return dict(sorted(keybinds.items(), key=lambda kv: kv[0].lower()))


converted = 0
for path in sorted(p for p in root.iterdir() if p.is_file()):
    if path.name in SKIP_NAMES or any(path.name.endswith(s) for s in SKIP_SUFFIXES):
        continue

    obj = decode_json(path)
    if obj is None:
        print(f"skip: {path.name}")
        continue

    keybinds = extract_keybinds(obj)
    if not keybinds:
        print(f"skip: {path.name} (no hotkeys)")
        continue

    out = output_path(path)
    out.write_text(json.dumps(keybinds, indent=2, ensure_ascii=False) + "\n")
    print(f"wrote: {out.name} ({len(keybinds)} hotkeys)")
    converted += 1

if converted == 0:
    print("no parseable keybind files found")
PY
