$ErrorActionPreference = 'SilentlyContinue'

$removeDirs = @(
    'C:\inetpub',
    'C:\PerfLogs',
    'C:\Windows.old'
)

$clearDirs = @(
    'C:\Windows\Temp',
    'C:\Windows\Prefetch',
    "$env:ProgramData\Microsoft\Windows\WER"
)

foreach ($dir in $removeDirs) {
    if (Test-Path -LiteralPath $dir) { 
        Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue 
    }
}

foreach ($dir in $clearDirs) {
    if (Test-Path -LiteralPath $dir) { 
        Remove-Item -Path "$dir\*" -Recurse -Force -ErrorAction SilentlyContinue 
    }
}

# Preserve event/CBS/DISM logs and update caches for AppX diagnosis.
# Do not stop delivery services or purge payloads while OOBE/Store is deploying apps.
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches' -ErrorAction SilentlyContinue | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name 'StateFlags0050' -Type DWord -Value 2 -Force -ErrorAction SilentlyContinue
}

exit 0