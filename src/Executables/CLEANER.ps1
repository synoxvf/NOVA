$removeDirs = @(
    'C:\inetpub'
    'C:\PerfLogs'
    'C:\Windows.old'
)

$clearDirs = @(
    'C:\Windows\Temp'
    'C:\Windows\Prefetch'
    'C:\Windows\Logs\CBS'
    'C:\Windows\Logs\DISM'
    "$env:windir\SoftwareDistribution\Download"
    "$env:ProgramData\Microsoft\Windows\WER"
)

$services = @('wuauserv', 'UsoSvc', 'bits', 'dosvc')
foreach ($svc in $services) { 
    Stop-Service -Name $svc -ErrorAction SilentlyContinue 
}

foreach ($dir in $removeDirs) {
    if (Test-Path $dir) { Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue }
}

foreach ($dir in $clearDirs) {
    if (Test-Path $dir) { Remove-Item "$dir\*" -Recurse -Force -ErrorAction SilentlyContinue }
}

wevtutil el | ForEach-Object { wevtutil cl "$_" 2>$null }
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Delete-DeliveryOptimizationCache -Force -ErrorAction SilentlyContinue

foreach ($svc in $services) { 
    Start-Service -Name $svc -ErrorAction SilentlyContinue 
}

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches' -ErrorAction SilentlyContinue | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name 'StateFlags0050' -Type DWord -Value 2 -Force -ErrorAction SilentlyContinue
}

exit 0