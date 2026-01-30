@echo off
setlocal EnableDelayedExpansion
for %%s in (storflt vmbushid HvHost vmickvpexchange Vid HvService vmbus HyperVideo gencounter vmicguestinterface vmicshutdown hyperkbd Bttflt vmgid vmicheartbeat vmicvmsession vmicrdv vmictimesync vmicvss vpci umbus storqosflt SharedAccess) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 4 /f
pause
