@echo off
setlocal EnableDelayedExpansion

for %%s in ("AMD Crash Defender Service" "AMD External Events Utility" "Ati External Event Utility" "amdfendr" "amdfendrmgr" "amdlog") do (
    sc.exe config "%%~s" start= auto >nul 2>&1
    sc.exe start "%%~s" >nul 2>&1
)

pause
