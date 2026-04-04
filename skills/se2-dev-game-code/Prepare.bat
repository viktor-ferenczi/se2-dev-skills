@echo off

:: 1. Detect game install location (env var override takes precedence)
if defined SE2_GAME_ROOT goto have_game_root

:: Try the game's registry key
for /f "tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 1133870" /v "InstallLocation" 2^>nul') do (
    set "SE2_GAME_ROOT=%%B"
)

if defined SE2_GAME_ROOT goto have_game_root
echo ERROR: Could not detect Space Engineers 2 install location.
echo Please set the SE2_GAME_ROOT environment variable to the game's root folder
echo (the folder containing Game2, GameData, etc.)
goto failed

:have_game_root
echo Game Root: %SE2_GAME_ROOT%

echo Verifying Python
python --version
if %ERRORLEVEL% EQU 0 goto has_python
echo ERROR: Missing Python
echo Please install Python 3.13 or newer.
echo Make sure python.exe is on PATH.
goto failed
:has_python

uv -V 2>NUL
if %ERRORLEVEL% EQU 0 goto skip_uv
echo Installing uv
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
uv -V
if %ERRORLEVEL% NEQ 0 goto failed
:skip_uv

if exist .venv goto skip_venv
echo Setting up Python .venv (uv sync)
uv sync
:skip_venv

if exist busybox.exe goto skip_busybox
echo Downloading busybox
powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://frippery.org/files/busybox/busybox64u.exe -OutFile busybox.exe"
if %ERRORLEVEL% NEQ 0 goto failed
:skip_busybox

echo Installing ILSpy (if not installed already)
ilspycmd -v 2>NUL
if %ERRORLEVEL% EQU 0 goto skip_ilspycmd
dotnet tool install --global ilspycmd
ilspycmd -v
if %ERRORLEVEL% NEQ 0 goto failed
:skip_ilspycmd

if exist Game2 goto skip_game2
echo Linking the game folder as Game2
REM It must be the folder where SpaceEngineers2.dll is located:
mklink /J Game2 "%SE2_GAME_ROOT%\Game2"
if %ERRORLEVEL% EQU 0 goto skip_game2
echo ERROR: Missing Game2 folder.
echo Please verify that Space Engineers 2 is installed.
echo If Space Engineers 2 is installed at a custom location, then set the SE2_GAME_ROOT
echo environment variable to the game's root folder and try again.
goto failed
:skip_game2

if exist Decompiled\VRage.Water goto skip_decompile
.\busybox sh Decompile.sh
if %ERRORLEVEL% NEQ 0 goto failed
:skip_decompile

rmdir /s /q Game2

if exist Content goto skip_content
echo Copying indexable content
uv run python -u copy_content.py "%SE2_GAME_ROOT%\GameData\Vanilla\Content"
if %ERRORLEVEL% NEQ 0 goto failed
:skip_content

if exist CodeIndex\game_version.txt goto skip_code_index
echo Indexing decompiled code
mkdir CodeIndex 2>NUL
uv run python -OO -u index_code.py Decompiled CodeIndex
if %ERRORLEVEL% NEQ 0 goto failed
:skip_code_index

if exist CodeIndex\content_index.csv goto skip_content_index
echo Indexing content files
uv run python -u index_content.py Content Decompiled CodeIndex
if %ERRORLEVEL% NEQ 0 goto failed
:skip_content_index

echo DONE
del "\\?\%cd%\nul" 2>error.txt
del error.txt
echo DONE >Prepare.DONE
exit /b 0

:failed
del "\\?\%cd%\nul" 2>error.txt
del error.txt
echo FAILED
exit /b 1
