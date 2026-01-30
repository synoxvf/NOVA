@echo off
setlocal EnableDelayedExpansion
for %%s in (WlanSvc vwififlt) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 4 /f
pause
