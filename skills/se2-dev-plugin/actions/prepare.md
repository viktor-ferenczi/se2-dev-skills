# Prepare Action

> **Part of the se2-dev-plugin skill.** Invoked to run the one-time preparation.

**⚠️ IMPORTANT: Read [CommandExecution.md](../CommandExecution.md) for complete guidance on running commands correctly.**

Run `Prepare.bat` to set up the skill environment. This is required before using the skill.

## Quick Check Status

**IMPORTANT**: Use bash syntax, NOT Windows CMD syntax. Commands run through busybox (UNIX shell).

```bash
# ✅ CORRECT - Use bash syntax
test -f "Prepare.DONE" && echo "READY" || echo "NOT_READY"
```

**Alternative**: Use the Glob tool to check for file existence instead of bash commands.

```bash
# ❌ WRONG - Don't use Windows CMD syntax (will NOT work)
# if exist Prepare.DONE (echo READY) else (echo NOT_READY)
```

## Running Preparation

If `Prepare.DONE` is missing:

1. Review the requirements and instructions in [Prepare.md](../Prepare.md).
2. Execute preparation using the skill folder as working directory:

**Recommended approach (using workdir parameter):**
```bash
./Prepare.bat (with workdir set to skill folder)
```

**Alternative approaches:**

Using PowerShell:
```powershell
cd C:\path\to\skill\folder
.\Prepare.bat
```

Using CMD (change directory first):
```cmd
cd /d C:\path\to\skill\folder
Prepare.bat
```

**⚠️ CRITICAL:** See [CommandExecution.md](../CommandExecution.md) for details on:
- Why `&&` doesn't work in CMD
- How to use the workdir parameter correctly
- Common mistakes and how to avoid them

## Critical Rules

- **DO NOT** create the `Prepare.DONE` file yourself.
- It is automatically created by `Prepare.bat` only upon a successful run.
- Creating it manually is "faking" success and will lead to errors.

## What Preparation Does

The preparation script:
- Verifies Python and `git` are on `PATH`
- Creates the per-user profile folder `%USERPROFILE%\.se2-dev\plugin\` and
  links it into the skill folder as a `Data\` junction (so all downloaded
  data persists across re-installs and `Clean.bat` runs)
- Pre-creates the `Data\Sources\` folder where each plugin will later be
  cloned into its own `Data\Sources\<PluginName>\` subdirectory
- Sets up the Python virtual environment
- Downloads and installs required tools (busybox.exe)
- `git clone`s the PluginHub-SE2 registry into `Data\PluginHub-SE2`
  (refreshed with `git fetch` / `git reset` on subsequent runs, so a
  manual `git pull` works too)
- Records the cloned commit in `Data\plugins.json`
- Verifies the environment is ready for use

Individual plugin sources are downloaded on demand by
`download_plugin_source.py`, which `git clone`s each plugin from GitHub into
`Data\Sources\<PluginName>\` (or the override set via
`SE_PLUGIN_DOWNLOAD_FOLDER` / `plugin_download_folder:`). Re-running it pulls
upstream updates in place.
