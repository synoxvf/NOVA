@echo off
setlocal EnableDelayedExpansion
for %%s in (Spooler PrintWorkFlowUserSvc StiSvc PrintNotify usbprint McpManagementService PrintScanBrokerService PrintDeviceConfigurationService) do reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%s" /v Start /t REG_DWORD /d 4 /f

DISM.exe /Online /Disable-Feature /FeatureName:Printing-Foundation-Features /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:Printing-Foundation-InternetPrinting-Client /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:Printing-PrintToPDFServices-Features /NoRestart

pause



