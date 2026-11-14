@echo off
setlocal EnableDelayedExpansion
for %%s in (xblauthmanager xblgamesave xboxgipsvc xboxnetapisvc GamingServices GamingServicesNet) do (
    sc.exe stop "%%s" >nul 2>&1
    sc.exe config "%%s" start= disabled >nul 2>&1
)
pause
