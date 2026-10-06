@echo off
reg.exe add "HKCU\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t REG_DWORD /d 1 /f
reg.exe add "HKU\.DEFAULT\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t REG_DWORD /d 1 /f

taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
