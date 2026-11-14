@echo off
setlocal EnableDelayedExpansion
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
sc.exe stop termservice >nul 2>&1
sc.exe stop umrdpservice >nul 2>&1
sc.exe config "termservice" start= disabled >nul 2>&1
for %%s in (umrdpservice winrm rdpbus rdpdr rdpvideominiport terminpt tsusbflt tsusbgd tsusbhub SessionEnv) do (
    sc.exe config "%%s" start= disabled >nul 2>&1
)
netsh advfirewall firewall set rule group="remote desktop" new enable=No >nul 2>&1
netsh advfirewall firewall set rule group="Дистанционное управление рабочим столом" new enable=No >nul 2>&1
pause
