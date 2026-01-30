@echo off
setlocal EnableDelayedExpansion
for %%s in (BthAvctpSvc bluetoothuserservice btagservice bthserv btha2dp bthenum bthhfenum bthleenum bthmini bthmodem bthport bthusb hidbth bthpan microsoft_bluetooth_avrcptransport rfcomm ncbservice) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 3 /f

Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Allow" /f
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Allow" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Allow" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Allow" /f

DevManView.exe /enable "Generic Bluetooth Adapter"
DevManView.exe /enable "Microsoft Radio Device Enumeration Bus"

schtasks.exe /change /enable /TN "\Microsoft\Windows\Bluetooth\UninstallDeviceTask"
pause
