import os
import shutil
from pathlib import Path
from typing import Set


def get_content_root() -> Path:
    """Get the SE2 content root from the SE2_CONTENT_ROOT environment variable."""
    content_root = os.environ.get('SE2_CONTENT_ROOT')
    if content_root:
        return Path(content_root)

    # Fallback: try SE2_ROOT env var
    se2_root = os.environ.get('SE2_ROOT')
    if se2_root:
        return Path(se2_root) / 'GameData' / 'Vanilla' / 'Content'

    raise EnvironmentError(
        'Neither SE2_CONTENT_ROOT nor SE2_ROOT environment variable is set. '
        'Please set SE2_CONTENT_ROOT to the path of GameData\\Vanilla\\Content '
        'or SE2_ROOT to the Space Engineers 2 installation root.'
    )


def copy_content(content_root: Path, subdir: str, allowed_extensions: Set[str], exclude: Set[str] = ()):
    src_dir = content_root / subdir
    if not src_dir.exists():
        print(f"Skipping {subdir} (not found)")
        return

    dst_dir = Path('Content') / subdir
    dst_dir.mkdir(parents=True, exist_ok=True)
    count = 0
    for src_path in src_dir.glob('**/*'):
        if not src_path.is_file():
            continue

        src_path_ext = str(src_path).rsplit('.', 1)[-1].lower()
        if src_path_ext not in allowed_extensions:
            continue

        if any(part in exclude for part in str(src_path).split(os.sep)):
            continue

        dst_path = dst_dir / src_path.relative_to(src_dir)
        dst_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src_path, dst_path)
        count += 1

    print(f"Copied {count} files from {subdir}")


def main():
    content_root = get_content_root()
    print(f"Content root: {content_root}")

    # Definition files (JSON-like format in SE2)
    copy_content(content_root, 'Armors', {'def'})
    copy_content(content_root, 'ArmorSkins', {'def'})
    copy_content(content_root, 'Audio', {'def'})
    copy_content(content_root, 'BlockMaterials', {'def'})
    copy_content(content_root, 'BlockTools', {'def'})
    copy_content(content_root, 'Blocks', {'def'})
    copy_content(content_root, 'CharacterTools', {'def'})
    copy_content(content_root, 'Characters', {'def'})
    copy_content(content_root, 'Colonization', {'def'})
    copy_content(content_root, 'Components', {'def'})
    copy_content(content_root, 'Decals', {'def'})
    copy_content(content_root, 'Encounters', {'def'})
    copy_content(content_root, 'Environment', {'def'})
    copy_content(content_root, 'Items', {'def'})
    copy_content(content_root, 'Materials', {'def'})
    copy_content(content_root, 'Templates', {'def'})
    copy_content(content_root, 'UI', {'def'})

    # Localization texts
    copy_content(content_root, 'MainMenuData', {'loc-texts'})

    # System configuration and AI
    copy_content(content_root, 'System', {'def', 'json'})


if __name__ == '__main__':
    main()
