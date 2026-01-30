@echo off
setlocal enabledelayedexpansion

if not exist "%SYSTEMDRIVE%\Windows\Setup\Scripts" mkdir "%SYSTEMDRIVE%\Windows\Setup\Scripts"
copy /y "DEFENDER.ps1" "%SYSTEMDRIVE%\Windows\Setup\Scripts\DEFENDER.ps1"
    
