@echo Off
setlocal EnableDelayedExpansion
for %%s in (xblauthmanager xblgamesave xboxgipsvc xboxnetapisvc) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 3 /f
pause
