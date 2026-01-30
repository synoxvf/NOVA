@echo OFF
setlocal enabledelayedexpansion

:: Modify aero.theme to set default dark theme and wallpaper
icacls "%WINDIR%\Resources\Themes\aero.theme" /reset /t >nul 2>&1
PowerShell -NoP -C "$Content = (Get-Content '%WINDIR%\Resources\Themes\aero.theme'); $Content = $Content -replace 'Wallpaper=%%SystemRoot%%.*', 'Wallpaper=%%SystemRoot%%\web\wallpaper\Windows\img100.jpg'; $Content = $Content -replace 'SystemMode=.*', 'SystemMode=Dark'; $Content -replace 'AppMode=.*', 'AppMode=Dark' | Set-Content '%WINDIR%\Resources\Themes\aero.theme'"

:: Copy wallpaper files from playbook directory to Windows
if exist "img100.jpg" (
    if not exist "%WINDIR%\Web\Wallpaper\Windows" mkdir "%WINDIR%\Web\Wallpaper\Windows"
    takeown /f "%WINDIR%\Web\Wallpaper\Windows\img100.jpg" >nul 2>&1
    icacls "%WINDIR%\Web\Wallpaper\Windows\img100.jpg" /reset >nul 2>&1
    move /y "img100.jpg" "%WINDIR%\Web\Wallpaper\Windows\img100.jpg"
    icacls "%WINDIR%\Web\Wallpaper\Windows\img100.jpg" /reset >nul 2>&1
)

if exist "img106.jpg" (
    if not exist "%WINDIR%\Web\Screen" mkdir "%WINDIR%\Web\Screen"
    takeown /f "%WINDIR%\Web\Screen\img106.jpg" >nul 2>&1
    icacls "%WINDIR%\Web\Screen\img106.jpg" /reset >nul 2>&1
    move /y "img106.jpg" "%WINDIR%\Web\Screen\img106.jpg"
    icacls "%WINDIR%\Web\Screen\img106.jpg" /reset >nul 2>&1
)
 
set "RunEC=0"

:: Iterate through all user hives including Default
for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
    if "%%A"=="AME_UserHive_Default" (
        call :WALLRUN "%%A" "%SYSTEMDRIVE%\Users\Default"
    ) else (
        for /f "usebackq tokens=2* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "AppData" 2^>nul ^| findstr "REG_SZ"`) do (
            call :WALLRUN "%%A" "%%C"
        )
    )
)

exit /b %RunEC%

:WALLRUN
if exist "%~2\Microsoft\Windows\Themes\Transcoded_000" set "wallChanged=true" & goto lockScreen

:: Check if Desktop Spotlight is enabled
reg query "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState 2>nul | findstr /c:"0x1" >nul 2>&1
if %errorlevel% NEQ 0 (
    PowerShell -NoP -C "try { Add-Type -AssemblyName System.Drawing; $img = New-Object System.Drawing.Bitmap '%~2\Microsoft\Windows\Themes\TranscodedWallpaper'; if ($img.Flags -ne 77840) {exit 1}; if ($img.HorizontalResolution -ne 96) {exit 1}; if ($img.VerticalResolution -ne 96) {exit 1}; if ($img.PropertyIdList -notcontains 40961) {exit 1}; if ($img.PropertyIdList -notcontains 20624) {exit 1}; if ($img.PropertyIdList -notcontains 20625) {exit 1} } catch { exit 1 }" >nul 2>&1
    if errorlevel 1 (
        :: Check if current wallpaper is Spotlight
        reg query "HKU\%~1\Control Panel\Desktop" /v WallPaper 2>nul | findstr /i /c:"MicrosoftWindows.Client.CBS_cw5n1h2txyewy\DesktopSpotlight" >nul 2>&1
        if errorlevel 1 set "wallChanged=true" & goto lockScreen
    )
)

:: Set Desktop Wallpaper
reg add "HKU\%~1\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\img100.jpg" /f >nul 2>&1
if %errorlevel% NEQ 0 set "wallFail=true" & goto lockScreen

:: Additional wallpaper settings
reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v BackgroundType /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v CurrentWallpaperPath /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\img100.jpg" /f >nul 2>&1

:: Clear desktop wallpaper cache
del /q /f "%~2\Microsoft\Windows\Themes\TranscodedWallpaper" >nul 2>&1
rmdir /q /s "%~2\Microsoft\Windows\Themes\CachedFiles" >nul 2>&1

:lockScreen
:: Check if lock screen rotation is already disabled
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\%~1" /v "RotatingLockScreen*" >nul 2>&1
if %errorlevel% NEQ 0 (
    :: Disable rotating lock screen for this user SID
    echo "%~1" | findstr /c:"S-" >nul
    if not errorlevel 1 (
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\%~1" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
    )
    
    :: Disable Lock Screen rotation in user settings
    reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKU\%~1\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
    
    :: Copy lock screen to standard Windows locations
    if exist "%WINDIR%\Web\Screen\img106.jpg" (
        takeown /f "%WINDIR%\Web\Screen\img100.jpg" >nul 2>&1
        icacls "%WINDIR%\Web\Screen\img100.jpg" /reset >nul 2>&1
        copy /y "%WINDIR%\Web\Screen\img106.jpg" "%WINDIR%\Web\Screen\img100.jpg" >nul 2>&1
        
        takeown /f "%WINDIR%\Web\Screen\img103.png" >nul 2>&1
        icacls "%WINDIR%\Web\Screen\img103.png" /reset >nul 2>&1
        copy /y "%WINDIR%\Web\Screen\img106.jpg" "%WINDIR%\Web\Screen\img103.png" >nul 2>&1
    )
    
    :: Clear lock screen cache
    takeown /R /D Y /F "%PROGRAMDATA%\Microsoft\Windows\SystemData" >nul 2>&1
    icacls "%PROGRAMDATA%\Microsoft\Windows\SystemData" /reset /t >nul 2>&1
    for /d %%D in ("%PROGRAMDATA%\Microsoft\Windows\SystemData\*") do (
        for /d %%E in ("%%D\ReadOnly\LockScreen_*") do (
            rmdir /q /s "%%E" >nul 2>&1
        )
    )
    
    :: Set exit codes based on status
    if "%wallChanged%"=="true" exit /b 1
    if "%wallFail%"=="true" exit /b 4
) else (
    :: Lock screen settings already applied
    if "%wallChanged%"=="true" exit /b 3
    if "%wallFail%"=="true" exit /b 5
    exit /b 2
)

echo Successfully applied for %~1
exit /b 0