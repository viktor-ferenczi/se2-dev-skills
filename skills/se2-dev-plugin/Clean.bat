@echo off
rmdir /s /q __pycache__
rmdir /s /q .venv
if exist Data rmdir Data
del busybox.exe
del Prepare.log
del Prepare.DONE
exit /b 0
