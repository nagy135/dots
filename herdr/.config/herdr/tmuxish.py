#!/usr/bin/env python3
"""Small Herdr helpers that emulate tmux bindings from ~/Code/nix-darwin."""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from pathlib import Path

HERDR = os.environ.get("HERDR_BIN_PATH") or "herdr"
HOME = Path.home()


def run(args: list[str], *, check: bool = True, capture: bool = False) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        args,
        check=check,
        text=True,
        stdout=subprocess.PIPE if capture else subprocess.DEVNULL,
        stderr=subprocess.PIPE if capture else subprocess.DEVNULL,
    )


def herdr_json(*args: str) -> dict:
    proc = run([HERDR, *args], capture=True)
    return json.loads(proc.stdout)


def active_workspace_id() -> str:
    if value := os.environ.get("HERDR_ACTIVE_WORKSPACE_ID"):
        return value
    workspaces = herdr_json("workspace", "list")["result"]["workspaces"]
    for workspace in workspaces:
        if workspace.get("focused"):
            return workspace["workspace_id"]
    raise RuntimeError("no active workspace")


def active_pane_id() -> str:
    if value := os.environ.get("HERDR_ACTIVE_PANE_ID"):
        return value
    panes = herdr_json("pane", "list")["result"]["panes"]
    for pane in panes:
        if pane.get("focused"):
            return pane["pane_id"]
    raise RuntimeError("no active pane")


def active_cwd() -> str:
    return os.environ.get("HERDR_ACTIVE_PANE_CWD") or os.getcwd()


def focus_tab(offset: int) -> None:
    tabs = herdr_json("tab", "list", "--workspace", active_workspace_id())["result"]["tabs"]
    if not tabs:
        return
    current = next((i for i, tab in enumerate(tabs) if tab.get("focused")), 0)
    target = tabs[(current + offset) % len(tabs)]["tab_id"]
    run([HERDR, "tab", "focus", target])


def focus_workspace(offset: int) -> None:
    workspaces = herdr_json("workspace", "list")["result"]["workspaces"]
    if not workspaces:
        return
    current = next((i for i, workspace in enumerate(workspaces) if workspace.get("focused")), 0)
    target = workspaces[(current + offset) % len(workspaces)]["workspace_id"]
    run([HERDR, "workspace", "focus", target])


def log_path() -> Path:
    config_path = Path(os.environ.get("HERDR_CONFIG_PATH", HOME / ".config" / "herdr" / "config.toml"))
    return config_path.parent / "herdr-server.log"


def last_tab() -> None:
    workspace_id = active_workspace_id()
    tabs = herdr_json("tab", "list", "--workspace", workspace_id)["result"]["tabs"]
    existing = {tab["tab_id"] for tab in tabs}
    current = next((tab["tab_id"] for tab in tabs if tab.get("focused")), None)
    if not current:
        return

    path = log_path()
    if path.exists():
        pattern = re.compile(r'tab focused .*workspace_id="([^"]+)" tab_id="([^"]+)"')
        with path.open("r", errors="ignore") as fh:
            for line in reversed(fh.readlines()[-5000:]):
                match = pattern.search(line)
                if not match:
                    continue
                log_workspace, tab_id = match.groups()
                if log_workspace == workspace_id and tab_id != current and tab_id in existing:
                    run([HERDR, "tab", "focus", tab_id])
                    return

    # If no history is available, fall back to the adjacent previous tab.
    focus_tab(-1)


def last_workspace() -> None:
    workspaces = herdr_json("workspace", "list")["result"]["workspaces"]
    existing = {workspace["workspace_id"] for workspace in workspaces}
    current = next((workspace["workspace_id"] for workspace in workspaces if workspace.get("focused")), None)
    if not current:
        return

    path = log_path()
    if path.exists():
        pattern = re.compile(r'workspace focused .*workspace_id="([^"]+)"')
        with path.open("r", errors="ignore") as fh:
            for line in reversed(fh.readlines()[-5000:]):
                match = pattern.search(line)
                if not match:
                    continue
                workspace_id = match.group(1)
                if workspace_id != current and workspace_id in existing:
                    run([HERDR, "workspace", "focus", workspace_id])
                    return

    # If no history is available, fall back to the adjacent previous workspace.
    focus_workspace(-1)


def create_tab_and_run(label: str, command: str) -> None:
    created = herdr_json("tab", "create", "--workspace", active_workspace_id(), "--label", label, "--cwd", active_cwd())
    result = created.get("result", {})
    root = result.get("root_pane") or result.get("pane") or result.get("root") or {}
    pane_id = root.get("pane_id") or root.get("id")
    if not pane_id:
        # Fallback for older/newer response shapes: use focused pane in the new tab.
        panes = herdr_json("pane", "list", "--workspace", active_workspace_id())["result"]["panes"]
        pane_id = next((pane["pane_id"] for pane in panes if pane.get("focused")), None)
    if not pane_id:
        raise RuntimeError(f"could not find root pane in tab create response: {created}")
    run([HERDR, "pane", "run", pane_id, command])


def scratch() -> None:
    workspaces = herdr_json("workspace", "list")["result"]["workspaces"]
    for workspace in workspaces:
        if workspace.get("label") == "scratch":
            run([HERDR, "workspace", "focus", workspace["workspace_id"]])
            return
    run([HERDR, "workspace", "create", "--label", "scratch", "--cwd", str(HOME)])


def split_jq() -> None:
    created = herdr_json("pane", "split", "--current", "--direction", "right")
    pane = created.get("result", {}).get("pane", {})
    pane_id = pane.get("pane_id") or pane.get("id")
    if not pane_id:
        raise RuntimeError(f"could not find pane in split response: {created}")
    run([HERDR, "pane", "run", pane_id, "pbpaste | jq -C | less -R"])


def close_workspace_now() -> None:
    run([HERDR, "workspace", "close", active_workspace_id()])


def move_pane_to_new_tab() -> None:
    run([HERDR, "pane", "move", active_pane_id(), "--new-tab", "--focus"])


def resize(direction: str) -> None:
    run([HERDR, "pane", "resize", "--direction", direction, "--amount", "5", "--current"])


def send_literal(text: str) -> None:
    run([HERDR, "pane", "send-text", active_pane_id(), text])


def maybe_run(command: str) -> None:
    subprocess.Popen(command, shell=True, cwd=active_cwd(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: tmuxish.py <action> [args...]", file=sys.stderr)
        return 2
    action = argv[1]
    if action == "prev-tab":
        focus_tab(-1)
    elif action == "next-tab":
        focus_tab(1)
    elif action == "last-tab":
        last_tab()
    elif action == "prev-workspace":
        focus_workspace(-1)
    elif action == "last-workspace":
        last_workspace()
    elif action == "next-workspace":
        focus_workspace(1)
    elif action == "launcher" and len(argv) >= 4:
        create_tab_and_run(argv[2], " ".join(argv[3:]))
    elif action == "scratch":
        scratch()
    elif action == "split-jq":
        split_jq()
    elif action == "close-workspace-now":
        close_workspace_now()
    elif action == "move-pane-new-tab":
        move_pane_to_new_tab()
    elif action == "resize" and len(argv) == 3:
        resize(argv[2])
    elif action == "send-backtick":
        send_literal("`")
    elif action == "git-open-browser":
        script = HOME / ".scripts" / "git_open_browser.sh"
        if script.exists():
            maybe_run(str(script))
    else:
        print(f"unknown action or bad args: {' '.join(argv[1:])}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
