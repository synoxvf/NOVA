@echo off
setlocal EnableDelayedExpansion
for %%s in (termservice umrdpservice winrm rdpbus rdpdr rdpvideominiport terminpt tsusbflt tsusbgd tsusbhub) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 4 /f
pause

