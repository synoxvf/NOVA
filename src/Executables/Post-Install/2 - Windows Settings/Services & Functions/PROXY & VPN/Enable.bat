@echo off
setlocal EnableDelayedExpansion
for %%s in (WinHttpAutoProxySvc RasMan SstpSvc PolicyAgent) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 3 /f
pause
