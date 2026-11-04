#!/usr/bin/env python3
"""Send one error-styled attention overlay through Hammerspoon's local IPC."""

import argparse
from pathlib import Path
import shutil
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("message", help="Short attention message, optionally with a newline")
    args = parser.parse_args()
    if not args.message.strip():
        parser.error("message must not be empty")

    cli = shutil.which("hs")
    if cli is None:
        bundled = Path("/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs")
        if not bundled.is_file():
            parser.exit(1, "Hammerspoon CLI is unavailable on this machine.\n")
        cli = str(bundled)

    # Three-digit Lua byte escapes keep arbitrary UTF-8 text out of executable code.
    message = '"' + "".join(f"\\{byte:03d}" for byte in args.message.encode("utf-8")) + '"'
    lua = (
        f"local id = hs.alert.show({message}, {{"
        "fillColor={red=0.35,green=0.03,blue=0.03,alpha=0.95},"
        "strokeColor={red=1,green=0.25,blue=0.25,alpha=1},"
        "textColor={white=1,alpha=1},strokeWidth=3,atScreenEdge=0"
        "}, hs.screen.mainScreen(), 10); assert(id, 'Alert was not created'); print(id)"
    )
    try:
        return subprocess.run([cli, "-c", lua], timeout=15, check=False).returncode
    except (OSError, subprocess.TimeoutExpired) as exc:
        print(f"Hammerspoon alert delivery failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
