#!/usr/bin/env python3
"""Launch a persistent macOS reminder without waiting for its dismissal."""

import argparse
import json
from pathlib import Path
import platform
import re
import subprocess
from urllib.parse import quote


APPLESCRIPT = '''on run argv
    set reminderText to item 1 of argv
    set threadURL to item 2 of argv
    tell current application to activate
    set answer to display alert "Reminder" message reminderText as warning buttons {"Dismiss", "Open thread"} default button "Open thread"
    if button returned of answer is "Open thread" then
        do shell script "/usr/bin/open -a '/Applications/T3 Code (Beta).app' " & quoted form of threadURL
    end if
end run
'''


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--message", required=True)
    parser.add_argument("--environment-id", required=True)
    parser.add_argument("--thread-id", required=True)
    args = parser.parse_args()
    if platform.system() != "Darwin":
        parser.error("This reminder must run on Viktor's Mac.")
    if not args.message.strip() or "\0" in args.message:
        parser.error("The reminder message must be nonempty and contain no NUL.")
    for label, value, pattern in (
        ("environment-id", args.environment_id, r"[A-Za-z0-9_:-]{1,512}"),
        ("thread-id", args.thread_id, r"[A-Za-z0-9_%:-]{1,512}"),
    ):
        if not re.fullmatch(pattern, value):
            parser.error(f"Invalid {label}.")
    url = "t3code://threads/{}/{}".format(
        quote(args.environment_id, safe=""), quote(args.thread_id, safe="")
    )
    log_path = Path.home() / "Library/Logs/remind-me-later.log"
    log_path.parent.mkdir(parents=True, exist_ok=True)
    with log_path.open("ab") as log:
        process = subprocess.Popen(
            ["/usr/bin/osascript", "-e", APPLESCRIPT, args.message, url],
            stdin=subprocess.DEVNULL,
            stdout=log,
            stderr=log,
            start_new_session=True,
        )
    print(json.dumps({"launched": True, "pid": process.pid, "log": str(log_path)}))


if __name__ == "__main__":
    main()
