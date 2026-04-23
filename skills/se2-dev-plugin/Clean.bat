@echo off
rmdir /s /q __pycache__
rmdir /s /q PluginSources
rmdir /s /q PluginCodeIndex
rmdir /s /q PluginHub-SE2
rmdir /s /q .venv
del busybox.exe
del Prepare.log
del Prepare.DONE
exit /b 0
