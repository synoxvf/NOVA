@echo off
setlocal EnableDelayedExpansion

for %%s in ("AMD Crash Defender Service" "AMD External Events Utility" "Ati External Event Utility" "amdfendr" "amdfendrmgr" "amdlog") do (
    sc.exe stop "%%~s" >nul 2>&1
    sc.exe config "%%~s" start= disabled >nul 2>&1
)

pause
