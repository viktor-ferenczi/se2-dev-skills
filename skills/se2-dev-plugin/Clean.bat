@echo off
:: Clean.bat - removes everything that Prepare.bat creates inside the skill
:: folder. The Data folder (a junction to %USERPROFILE%\.se2-dev\plugin) is
:: preserved: only the junction itself is removed so the actual contents
:: (Sources, PluginHub-SE2, PluginCodeIndex, plugins.json) survive across runs.

:: Remove the Data junction (NOT its contents - rmdir without /s deletes only
:: the junction reparse point and leaves the target folder intact).
if exist Data rmdir Data

:: Remove transient skill artefacts.
if exist __pycache__  rmdir /s /q __pycache__
if exist .venv        rmdir /s /q .venv
if exist busybox.exe  del busybox.exe
if exist Prepare.log  del Prepare.log
if exist Prepare.DONE del Prepare.DONE

exit /b 0
