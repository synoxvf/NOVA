@echo off
setlocal EnableDelayedExpansion
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d 0 /f
for %%p in (ms-gamebar ms-gamingoverlay ms-gamebarservices) do (
    reg add "HKLM\SOFTWARE\Classes\%%p" /ve /d "URL:%%p" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Classes\%%p" /v "URL Protocol" /d "" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Classes\%%p" /v "NoOpenWith" /d "" /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Classes\%%p\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\systray.exe" /f >nul 2>&1
)
pause
