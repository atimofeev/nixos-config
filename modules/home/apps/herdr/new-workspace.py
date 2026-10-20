import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


def main():
    if not os.environ.get("HERDR_SOCKET_PATH") or not os.environ.get("HERDR_ACTIVE_WORKSPACE_ID"):
        raise RuntimeError("Run this helper through the Herdr workspace popup.")
    for executable in ("zoxide", "fzf", "pi", "nix"):
        if shutil.which(executable) is None:
            raise RuntimeError(f"Required command not found: {executable}")
    herdr = os.environ.get("HERDR_BIN_PATH", "herdr")
    if shutil.which(herdr) is None:
        raise RuntimeError("Herdr executable not found.")

    directories = subprocess.run(
        ["zoxide", "query", "--list"], check=True, capture_output=True, text=True
    ).stdout
    if not directories.strip():
        raise RuntimeError("Zoxide has no directories yet. Visit a project directory first.")
    selection = subprocess.run(
        [
            "fzf", "--prompt=Workspace > ", "--height=100%", "--layout=reverse",
            "--border=none", "--no-multi", "--no-print-query", "--no-expect", "--no-preview",
        ],
        input=directories,
        stdout=subprocess.PIPE,
        text=True,
    )
    if selection.returncode in (1, 130):
        return
    selection.check_returncode()
    directory = selection.stdout.rstrip("\n")
    if directory not in directories.splitlines() or not Path(directory).is_dir():
        raise RuntimeError("Selected directory is no longer available.")

    def api(*args, expect_json=False):
        response = subprocess.run(
            [herdr, *args], check=True, capture_output=True, text=True, timeout=30
        )
        if expect_json:
            try:
                return json.loads(response.stdout)["result"]
            except (ValueError, KeyError, TypeError) as error:
                raise RuntimeError(
                    f"Herdr {' '.join(args[:2])} returned no valid JSON result. "
                    "Command may have succeeded; inspect before retrying."
                ) from error

    def identifier(response, section, key):
        value = response[section][key]
        if not isinstance(value, str) or not value:
            raise RuntimeError(f"Herdr returned an invalid {key}.")
        return value

    created = api(
        "workspace", "create", "--cwd", directory,
        "--label", Path(directory).name or directory, "--no-focus", expect_json=True,
    )
    workspace = identifier(created, "workspace", "workspace_id")
    try:
        editor_tab = identifier(created, "tab", "tab_id")
        api("tab", "rename", editor_tab, "neojj")
        editor_pane = identifier(created, "root_pane", "pane_id")
        api("pane", "run", editor_pane, "nix run ~/repos/nixvim-config -- -c Neojj")
        agent = api(
            "tab", "create", "--workspace", workspace, "--cwd", directory,
            "--label", "pi-agent", "--no-focus", expect_json=True,
        )
        pane = identifier(agent, "root_pane", "pane_id")
        api("pane", "run", pane, "pi")
        api("workspace", "focus", workspace)
    except Exception:
        print(f"Setup incomplete; workspace {workspace} kept for inspection.", file=sys.stderr)
        raise


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError, TypeError, RuntimeError, subprocess.SubprocessError) as error:
        print(f"Workspace setup failed: {error}", file=sys.stderr)
        if isinstance(error, subprocess.CalledProcessError) and error.stderr:
            print(error.stderr, file=sys.stderr)
        if sys.stdin.isatty():
            input("Press Enter to close.")
        sys.exit(1)
