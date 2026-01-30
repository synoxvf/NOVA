@echo OFF
cd Executables
mkdir "%SYSTEMDRIVE%\Windows\Setup\Scripts"
copy /y "LayoutModification.xml" "%SYSTEMDRIVE%\Windows\Setup\Scripts\TaskbarLayoutModification.xml"
for /f "usebackq tokens=2 delims=\" %%A in (`reg query "HKEY_USERS" ^| findstr /r /x /c:"HKEY_USERS\\S-.*" /c:"HKEY_USERS\\AME_UserHive_[^_]*"`) do (
	reg query "HKEY_USERS\%%A" | findstr /c:"Volatile Environment" /c:"AME_UserHive_" > NUL 2>&1
	if not errorlevel 1 (
		reg delete "HKU\%%A\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /f 2>NUL
		reg delete "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Start" /v "Config" /f 2>NUL
		for /f "usebackq tokens=3* delims= " %%B in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Local AppData" 2^>^&1 ^| findstr /R /X /C:".*Local AppData[ ]*REG_SZ[ ].*"`) do (
			copy /y "LayoutModification.xml" "%%C\Microsoft\Windows\Shell\LayoutModification.xml"
			for /f "usebackq delims=" %%D in (`dir /b "%%C\Packages" 2^>NUL ^| findstr /c:"Microsoft.Windows.StartMenuExperienceHost"`) do (
				del /q /f "%%C\Packages\%%D\LocalState\start*.bin" 2>NUL
				copy /y "start2.bin" "%%C\Packages\%%D\LocalState\start2.bin"
			)
		)
		reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d 1 /f
		reg add "HKU\%%A\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_SZ /d "C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml" /f
		for /f "usebackq delims=" %%C in (`reg query "HKU\%%A\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" 2^>NUL ^| findstr /c:"start.tilegrid"`) do (
			reg delete "%%C" /f 2>NUL
		)
	)
)
if not exist "%SYSTEMDRIVE%\Users\Default\AppData\Local\Microsoft\Windows\Shell" mkdir "%SYSTEMDRIVE%\Users\Default\AppData\Local\Microsoft\Windows\Shell"
copy /y "LayoutTaskbar.xml" "%SYSTEMDRIVE%\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
if not exist "%SYSTEMDRIVE%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" mkdir "%SYSTEMDRIVE%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
del /q /f "%SYSTEMDRIVE%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start*.bin" 2>NUL
copy /y "start2.bin" "%SYSTEMDRIVE%\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin"