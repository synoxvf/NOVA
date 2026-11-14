@echo off
setlocal EnableDelayedExpansion
for %%s in (GamingServices GamingServicesNet) do (
    sc.exe config "%%s" start= auto >nul 2>&1
    sc.exe start "%%s" >nul 2>&1
)
for %%s in (xblauthmanager xblgamesave xboxgipsvc xboxnetapisvc) do (
    sc.exe config "%%s" start= demand >nul 2>&1
)
pause
