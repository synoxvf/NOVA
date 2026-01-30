$ErrorActionPreference = 'SilentlyContinue'

Write-Host "System Cleanup Started" -ForegroundColor Cyan

@(
    "C:\inetpub",
    "C:\PerfLogs",
    "C:\Windows.old"
) | Where-Object { Test-Path $_ } | ForEach-Object {
    Remove-Item $_ -Recurse -Force
}

# Stop services
'wuauserv', 'UsoSvc', 'bits', 'dosvc' | ForEach-Object { Stop-Service $_ -Force }

# Clean temp folders
@(
    'C:\Windows\Temp',
    'C:\Windows\Prefetch',
    "$env:LOCALAPPDATA\Temp",
    "$env:windir\SoftwareDistribution\Download"
) | Where-Object { Test-Path $_ } | ForEach-Object {
    Get-ChildItem $_ -Recurse -Force | Remove-Item -Recurse -Force
}

# Clean GPU shader caches
@(
    "$env:LOCALAPPDATA\NVIDIA\GLCache",
    "$env:LOCALAPPDATA\NVIDIA\DXCache",
    "$env:ProgramData\NVIDIA Corporation\NV_Cache",
    "$env:LOCALAPPDATA\AMD\DX9Cache",
    "$env:LOCALAPPDATA\AMD\DxCache",
    "$env:LOCALAPPDATA\AMD\DxcCache",
    "$env:LOCALAPPDATA\AMD\OglCache",
    "$env:LOCALAPPDATA\AMD\VkCache",
    "$env:LOCALAPPDATA\Intel\ShaderCache",
    "$env:ProgramData\Intel\ShaderCache",
    "$env:LOCALAPPDATA\D3DSCache"
) | Where-Object { Test-Path $_ } | ForEach-Object {
    Get-ChildItem $_ -Recurse -Force | Remove-Item -Recurse -Force
}

# Clean logs and error reports
@(
    "$env:ProgramData\Microsoft\Windows\WER",
    'C:\Windows\Logs\CBS\CBS.log',
    'C:\Windows\Logs\DISM\DISM.log'
) | Where-Object { Test-Path $_ } | ForEach-Object { Remove-Item $_ -Recurse -Force }

Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }

# Empty recycle bin
Clear-RecycleBin -Force

# Deep cleanup
Delete-DeliveryOptimizationCache -Force

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches' | ForEach-Object {
    New-ItemProperty -Path $_.PSPath -Name StateFlags0050 -Value 2 -PropertyType DWord -Force | Out-Null
}

# Restart services
'wuauserv', 'UsoSvc', 'bits', 'dosvc' | ForEach-Object { Start-Service $_ }

Write-Host "Cleanup Complete" -ForegroundColor Green