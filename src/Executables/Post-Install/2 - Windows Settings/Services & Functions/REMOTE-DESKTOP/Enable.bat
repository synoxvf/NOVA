@echo off
setlocal EnableDelayedExpansion
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d 3389 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LimitBlankPasswordUse" /t REG_DWORD /d 0 /f
sc.exe config "termservice" start= auto >nul 2>&1
for %%s in (umrdpservice winrm rdpbus rdpdr rdpvideominiport terminpt tsusbflt tsusbgd tsusbhub SessionEnv) do (
    sc.exe config "%%s" start= demand >nul 2>&1
)
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes >nul 2>&1
netsh advfirewall firewall set rule group="Дистанционное управление рабочим столом" new enable=Yes >nul 2>&1
sc.exe start termservice >nul 2>&1
pause
