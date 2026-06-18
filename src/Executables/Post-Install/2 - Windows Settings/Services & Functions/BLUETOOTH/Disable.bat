@echo off
setlocal EnableDelayedExpansion
for %%s in (BthAvctpSvc bluetoothuserservice btagservice bthserv btha2dp bthenum bthhfenum bthleenum bthmini bthmodem bthport bthusb hidbth bthpan microsoft_bluetooth_avrcptransport rfcomm ncbservice) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 4 /f

Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f
Reg.exe add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Deny" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Deny" /f

DevManView.exe /disable "Generic Bluetooth Adapter"
DevManView.exe /disable "Microsoft Radio Device Enumeration Bus"
DevManView.exe /disable "Microsoft Device Association Root Enumerator"

schtasks.exe /change /disable /TN "\Microsoft\Windows\Bluetooth\UninstallDeviceTask"
pause
