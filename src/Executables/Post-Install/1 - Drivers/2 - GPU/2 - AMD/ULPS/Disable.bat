@echo off
setlocal EnableDelayedExpansion

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" 2^>nul ^| findstr /r "\\0[0-9][0-9][0-9]$"') do (
    reg add "%%i" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "%%i" /v "EnableUlps_NA" /t REG_SZ /d "0" /f >nul 2>&1
)

pause
