@echo off
setlocal EnableDelayedExpansion
for %%s in (PhoneSvc autotimesvc) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 3 /f
pause

