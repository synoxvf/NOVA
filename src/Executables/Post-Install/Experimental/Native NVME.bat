@echo off
title Native NVMe Toggle

:menu
cls
echo.
echo 1 - Enable native NVMe
echo 2 - Restore default
echo.
choice /c 12 /n /m "Select option [1-2]: "

if errorlevel 2 goto disable
if errorlevel 1 goto enable

:enable
cls
echo Enabling native NVMe...
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 735209102 /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 1853569164 /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 156965516 /t REG_DWORD /d 1 /f >nul
echo.
echo Done. Reboot required.
pause
exit /b 0

:disable
cls
echo Restoring default configuration...
reg delete "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 735209102 /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 1853569164 /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 156965516 /f >nul 2>&1
echo.
echo Done. Reboot required.
pause
exit /b 0