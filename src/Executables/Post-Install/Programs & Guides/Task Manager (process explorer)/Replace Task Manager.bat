@echo off
copy "%~dp0procexp64.exe" "%windir%" >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /t REG_SZ /d "\"C:\WINDOWS\PROCEXP64.EXE\"" /f >nul 2>&1
%windir%"/procexp64.exe >nul 2>&1
exit