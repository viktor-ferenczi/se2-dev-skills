@echo off

:: 1. Get the Steam Install Path from the Registry
for /f "tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam" /v "SteamPath" 2^>nul') do (
    set "STEAM_ROOT=%%B"
)

:: 2. Clean up the path (Registry uses forward slashes, Batch prefers backslashes)
set "STEAM_ROOT=%STEAM_ROOT:/=\%"

:: 3. Define your target folders
set "WORKSHOP_PATH=%STEAM_ROOT%\steamapps\workshop\content"
set "COMMON_PATH=%STEAM_ROOT%\steamapps\common"

:: Output results to verify
echo Steam Root:    %STEAM_ROOT%
echo Workshop Path: %WORKSHOP_PATH%
echo Common Path:   %COMMON_PATH%

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
mklink /J Game2 "%COMMON_PATH%\SpaceEngineers2\Game2"
if %ERRORLEVEL% EQU 0 goto skip_game2
echo ERROR: Missing Game2 folder.
echo Please verify that Space Engineers 2 is installed.
echo If Space Engineers 2 is installed at custom location, then please update the absolute path to the `Game2` folder in the `mklink` command inside `Prepare.bat` accordingly and try again.
goto failed
:skip_game2

if exist Decompiled\VRage.Water goto skip_decompile
.\busybox sh Decompile.sh
if %ERRORLEVEL% NEQ 0 goto failed
:skip_decompile

rmdir /s /q Game2

:: Set environment variable for copy_content.py
set "SE2_CONTENT_ROOT=%COMMON_PATH%\SpaceEngineers2\GameData\Vanilla\Content"

if exist Content goto skip_content
echo Copying indexable content
uv run python -u copy_content.py
if %ERRORLEVEL% NEQ 0 goto failed
:skip_content

if exist CodeIndex\variables.csv goto skip_index
echo Indexing decompiled code
mkdir CodeIndex 2>NUL
uv run python -OO -u index_code.py Decompiled CodeIndex
if %ERRORLEVEL% NEQ 0 goto failed
:skip_index

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
