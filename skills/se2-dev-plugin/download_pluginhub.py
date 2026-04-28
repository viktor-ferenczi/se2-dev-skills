"""
Clone (or update) a local copy of the PluginHub-SE2 registry.

The registry is always stored at `Data/PluginHub-SE2/` within the skill
directory as a `git clone`. `Prepare.bat` verifies that `git` is on `PATH`,
so this script clones with `git clone` on first run and refreshes with
`git fetch` + `git reset` on subsequent runs (also `git pull`-able by hand).

The downloaded commit hash is recorded in `plugins.json` (next to the
PluginHub-SE2 clone) so the skill can tell which upstream version is
currently on disk.
"""

import sys
from pathlib import Path

from git_utils import clone_or_update, get_head_commit
from plugin_paths import ensure_base_dir, resolve_pluginhub_dir
from plugin_registry import update_pluginhub

REPO_URL = "https://github.com/StarCpt/PluginHub-SE2"
REPO_GIT_URL = f"{REPO_URL}.git"


def _clone_or_update(pluginhub_dir: Path) -> str:
    """Clone or update PluginHub-SE2 using git. Returns the HEAD commit."""
    print(f"Using git to clone/update {pluginhub_dir.name} at {pluginhub_dir}...")
    ok = clone_or_update(REPO_GIT_URL, pluginhub_dir, commit=None)
    if not ok:
        raise RuntimeError("git clone/update failed")
    commit = get_head_commit(pluginhub_dir)
    if not commit:
        raise RuntimeError("failed to read HEAD commit after clone/update")
    print(f"{pluginhub_dir.name} now at commit {commit[:12]}")
    return commit


def download_and_extract() -> None:
    ensure_base_dir()
    pluginhub_dir = resolve_pluginhub_dir()

    commit = _clone_or_update(pluginhub_dir)

    try:
        update_pluginhub(
            repo_url=REPO_URL,
            commit=commit,
            method="git",
            local_path=str(pluginhub_dir),
        )
        print("Updated plugins.json registry.")
    except Exception as e:
        print(f"Warning: failed to update plugins.json: {e}", file=sys.stderr)


if __name__ == "__main__":
    download_and_extract()
