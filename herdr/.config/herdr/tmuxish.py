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
RESERVED_TAB_PREFIX = ""

# Fixed launchers: copy one block to add another launcher, then bind its name
# in config.toml with: tmuxish.py fixed-launcher <name>
FIXED_LAUNCHERS = {
    "lazygit": {
        "position": 3,
        "label": "LazyGit",
        "command": "lazygit --ucf ~/.config/lazygit/config.yml",
    },
    "claude": {
        "position": 4,
        "label": "ClaudeCode",
        "command": "claude --permission-mode auto",
    },
    "codex": {
        "position": 6,
        "label": "codex",
        "command": "codex",
    },
    "glab-pipelines": {
        "position": 7,
        "label": "glab-pipelines",
        "command": "glab-pipelines",
    },
    "opencode": {
        "position": 8,
        "label": "OpenCode",
        "command": "opencode",
    },
}


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


def fixed_launchers() -> dict[str, dict]:
    launchers = FIXED_LAUNCHERS

    used_positions: dict[int, str] = {}
    for name, launcher in launchers.items():
        position = launcher.get("position")
        label = launcher.get("label")
        command = launcher.get("command")
        if not isinstance(position, int) or position < 1:
            raise ValueError(f"launcher {name!r} needs a positive integer position")
        if not isinstance(label, str) or not label.strip():
            raise ValueError(f"launcher {name!r} needs a non-empty label")
        if not isinstance(command, str) or not command.strip():
            raise ValueError(f"launcher {name!r} needs a non-empty command")
        if owner := used_positions.get(position):
            raise ValueError(f"launchers {owner!r} and {name!r} both use position {position}")
        used_positions[position] = name
    return launchers


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


def root_pane_id(created: dict) -> str:
    result = created.get("result", {})
    root = result.get("root_pane") or result.get("pane") or result.get("root") or {}
    pane_id = root.get("pane_id") or root.get("id")
    if pane_id:
        return pane_id
    raise RuntimeError(f"could not find root pane in tab create response: {created}")


def existing_tab_pane_id(workspace_id: str, tab_id: str) -> str:
    panes = herdr_json("pane", "list", "--workspace", workspace_id)["result"]["panes"]
    pane_id = next((pane["pane_id"] for pane in panes if pane.get("tab_id") == tab_id), None)
    if not pane_id:
        raise RuntimeError(f"could not find a pane in tab {tab_id}")
    return pane_id


def move_tab_to_end(workspace_id: str, tab: dict) -> None:
    if tab.get("pane_count") != 1:
        raise RuntimeError(
            f"cannot reorder tab {tab.get('label') or tab['tab_id']}: "
            "only single-pane tabs can be moved safely"
        )
    pane_id = existing_tab_pane_id(workspace_id, tab["tab_id"])
    args = ["pane", "move", pane_id, "--new-tab", "--workspace", workspace_id]
    label = tab.get("label")
    if label and not str(label).isdigit():
        args.extend(["--label", label])
    args.append("--no-focus")
    herdr_json(*args)


def reorder_tabs(workspace_id: str, tabs: list[dict], desired: list[dict]) -> None:
    current_ids = [tab["tab_id"] for tab in tabs]
    desired_ids = [tab["tab_id"] for tab in desired]
    if current_ids == desired_ids:
        return

    # Moving a sole pane into a new tab appends that tab. Keep the longest
    # possible desired prefix in place, then append the remaining tabs in
    # desired order. This realizes any permutation without restarting panes.
    tabs_to_move = desired
    for prefix_length in range(len(desired), -1, -1):
        prefix_ids = set(desired_ids[:prefix_length])
        if [tab_id for tab_id in current_ids if tab_id in prefix_ids] == desired_ids[:prefix_length]:
            tabs_to_move = desired[prefix_length:]
            break

    # Validate the complete rotation before moving anything so a split tab
    # cannot leave the workspace only partly reordered.
    split_tab = next((tab for tab in tabs_to_move if tab.get("pane_count") != 1), None)
    if split_tab:
        raise RuntimeError(
            f"cannot restore fixed launcher positions: "
            f"tab {split_tab.get('label') or split_tab['tab_id']} has multiple panes"
        )
    for tab in tabs_to_move:
        move_tab_to_end(workspace_id, tab)


def create_tab(workspace_id: str, *, label: str | None = None, focus: bool = False) -> dict:
    args = ["tab", "create", "--workspace", workspace_id, "--cwd", active_cwd()]
    if label:
        args.extend(["--label", label])
    args.append("--focus" if focus else "--no-focus")
    return herdr_json(*args)


def create_tab_and_run(label: str, command: str) -> None:
    created = create_tab(active_workspace_id(), label=label, focus=True)
    run([HERDR, "pane", "run", root_pane_id(created), command])


def fixed_tab_and_run(
    position: int,
    label: str,
    command: str,
    fixed_tab_labels: dict[int, str] | None = None,
) -> None:
    if position < 1:
        raise ValueError("fixed tab position must be positive")

    workspace_id = active_workspace_id()
    tabs = herdr_json("tab", "list", "--workspace", workspace_id)["result"]["tabs"]
    if fixed_tab_labels is None:
        fixed_tab_labels = {
            launcher["position"]: launcher["label"] for launcher in fixed_launchers().values()
        }
    if fixed_tab_labels.get(position) != label:
        raise ValueError(f"launcher {label!r} is not configured for position {position}")

    pinned: dict[int, dict] = {}
    should_run = False
    for fixed_position, fixed_label in sorted(fixed_tab_labels.items()):
        reserved_label = f"{RESERVED_TAB_PREFIX}{fixed_label}"
        fixed_tab = next((tab for tab in tabs if tab.get("label") == fixed_label), None)
        if fixed_tab is None:
            fixed_tab = next((tab for tab in tabs if tab.get("label") == reserved_label), None)
        if fixed_tab is None:
            new_label = fixed_label if fixed_label == label else reserved_label
            created = create_tab(workspace_id, label=new_label)
            fixed_tab = created.get("result", {}).get("tab", {})
            fixed_tab["pane_count"] = fixed_tab.get("pane_count", 1)
            tabs.append(fixed_tab)
            if fixed_label == label:
                should_run = True
        elif fixed_label == label and fixed_tab.get("label") == reserved_label:
            run([HERDR, "tab", "rename", fixed_tab["tab_id"], fixed_label])
            fixed_tab["label"] = fixed_label
            should_run = True
        pinned[fixed_position] = fixed_tab

    while len(tabs) < max(fixed_tab_labels):
        created = create_tab(workspace_id)
        filler = created.get("result", {}).get("tab", {})
        filler["pane_count"] = filler.get("pane_count", 1)
        tabs.append(filler)

    desired: list[dict | None] = [None] * len(tabs)
    pinned_ids = {tab["tab_id"] for tab in pinned.values()}
    for fixed_position, fixed_tab in pinned.items():
        desired[fixed_position - 1] = fixed_tab
    unpinned = iter(tab for tab in tabs if tab["tab_id"] not in pinned_ids)
    for index, tab in enumerate(desired):
        if tab is None:
            desired[index] = next(unpinned)

    reorder_tabs(workspace_id, tabs, [tab for tab in desired if tab is not None])
    tabs = herdr_json("tab", "list", "--workspace", workspace_id)["result"]["tabs"]
    launcher = next(tab for tab in tabs if tab.get("label") == label)
    pane_id = existing_tab_pane_id(workspace_id, launcher["tab_id"])
    run([HERDR, "tab", "focus", launcher["tab_id"]])
    if should_run:
        run([HERDR, "pane", "run", pane_id, command])


def run_fixed_launcher(name: str) -> None:
    launchers = fixed_launchers()
    if name not in launchers:
        raise ValueError(f"unknown fixed launcher {name!r}")
    launcher = launchers[name]
    labels_by_position = {
        entry["position"]: entry["label"] for entry in launchers.values()
    }
    fixed_tab_and_run(
        launcher["position"],
        launcher["label"],
        launcher["command"],
        labels_by_position,
    )


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
    elif action == "fixed-launcher" and len(argv) == 3:
        try:
            run_fixed_launcher(argv[2])
        except (OSError, RuntimeError, ValueError) as error:
            run(
                [HERDR, "notification", "show", "Launcher unavailable", "--body", str(error)],
                check=False,
            )
            return 1
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
