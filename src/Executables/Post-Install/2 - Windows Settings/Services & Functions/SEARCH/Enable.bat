@echo off
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Search\DisableSearch" /v value /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableSearch /t REG_DWORD /d 0 /f
pause