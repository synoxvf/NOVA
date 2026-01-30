@echo off
reg add "HKCU\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /ve /d "CLSID_MSGraphHomeFolder" /f
reg add "HKCU\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f

