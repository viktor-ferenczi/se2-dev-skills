"""
Download (or update) a local copy of the PluginHub-SE2 registry.

The registry is always stored at `Data/PluginHub-SE2/` within the skill
directory.

When `git` is available on PATH, the registry is cloned with `git clone`
and subsequently updated with `git fetch`/`git reset`, so the local copy
can be refreshed incrementally. If `git` is not available, the script
falls back to downloading a ZIP snapshot of the default branch.

Regardless of the method, the downloaded commit hash is recorded in
`plugins.json` (next to the PluginHub-SE2 clone) so the skill can tell
which upstream version is currently on disk.
"""

import os
import shutil
import sys
import time
import zipfile
from pathlib import Path

import requests

from git_utils import clone_or_update, get_head_commit, is_git_available
from plugin_paths import ensure_base_dir, resolve_pluginhub_dir
from plugin_registry import update_pluginhub

REPO_URL = "https://github.com/StarCpt/PluginHub-SE2"
REPO_GIT_URL = f"{REPO_URL}.git"
ZIP_URL = f"{REPO_URL}/archive/refs/heads/main.zip"


def _should_update(path: Path) -> bool:
    """ZIP-mode staleness check: re-download if older than two hours."""
    if not path.exists():
        return True
    mod_time = path.stat().st_mtime
    return (time.time() - mod_time) > 2 * 3600


def _download_via_git(pluginhub_dir: Path) -> str:
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


def _download_via_zip(pluginhub_dir: Path) -> str:
    """
    Fallback: download a ZIP snapshot of the default branch.

    Returns the commit hash that GitHub reports as the archive's source,
    or an empty string if it cannot be determined.
    """
    if pluginhub_dir.exists() and not _should_update(pluginhub_dir):
        print(f"{pluginhub_dir} exists and is up to date.")
        return ""

    base_dir = pluginhub_dir.parent
    base_dir.mkdir(parents=True, exist_ok=True)

    if pluginhub_dir.exists():
        shutil.rmtree(pluginhub_dir)
        print(f"Deleted old {pluginhub_dir}.")

    print(f"Downloading ZIP from {ZIP_URL} ...")
    response = requests.get(ZIP_URL)
    response.raise_for_status()

    zip_path = base_dir / "pluginhub_temp.zip"
    with open(zip_path, "wb") as f:
        f.write(response.content)
    print("ZIP downloaded.")

    commit_hash = ""
    print("Extracting ZIP...")
    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        zip_ref.extractall(base_dir)
        top_names = {name.split("/")[0] for name in zip_ref.namelist() if name}
        prefix = f"{pluginhub_dir.name}-"
        for top in top_names:
            if top.startswith(prefix):
                suffix = top[len(prefix):]
                if len(suffix) == 40 and all(c in "0123456789abcdef" for c in suffix.lower()):
                    commit_hash = suffix.lower()

    extracted_dir = base_dir / f"{pluginhub_dir.name}-main"
    if extracted_dir.exists():
        if pluginhub_dir.exists():
            try:
                shutil.rmtree(pluginhub_dir)
            except OSError as e:
                print(f"Warning: Could not remove existing {pluginhub_dir}: {e}")
        try:
            os.rename(extracted_dir, pluginhub_dir)
        except OSError:
            shutil.move(str(extracted_dir), str(pluginhub_dir))

    print(f"Extracted to {pluginhub_dir}.")
    zip_path.unlink(missing_ok=True)
    print("Done.")
    return commit_hash


def download_and_extract() -> None:
    ensure_base_dir()
    pluginhub_dir = resolve_pluginhub_dir()

    if is_git_available():
        commit = _download_via_git(pluginhub_dir)
        method = "git"
    else:
        print("git not found on PATH; falling back to ZIP download.")
        commit = _download_via_zip(pluginhub_dir)
        method = "zip"

    try:
        update_pluginhub(
            repo_url=REPO_URL,
            commit=commit,
            method=method,
            local_path=str(pluginhub_dir),
        )
        print("Updated plugins.json registry.")
    except Exception as e:
        print(f"Warning: failed to update plugins.json: {e}", file=sys.stderr)


if __name__ == "__main__":
    download_and_extract()
