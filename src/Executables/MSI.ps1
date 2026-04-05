try {
    $ErrorActionPreference = 'Stop'
    $isLaptop = [bool]((Get-CimInstance -ClassName Win32_SystemEnclosure).ChassisTypes -match '^(8|9|10|11|12|14|18|21|30|31|32)$')
    $devices = [System.Collections.Generic.List[pscustomobject]]::new()

    $peripheralPattern = '(?i)(high definition audio|nvm|nvme|ahci|sata|scsi|ethernet|wi-fi|network|gigabit|gbe|killer|wlan|802\.11)'

    # Enumerate PCI Device Capabilities
    Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI' -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
        if ($null -eq $props -or $null -eq $props.psobject.Properties['DeviceDesc']) { return }

        $desc = [string]$props.DeviceDesc
        if ($desc -match $peripheralPattern) {
            $cleanPath = $_.PSPath -replace 'Microsoft\.PowerShell\.Core\\Registry::', 'HKLM:'
            $devices.Add([pscustomobject]@{ Path = $cleanPath })
        }
    }

    # Enumerate USB xHCI Host Controllers
    Get-CimInstance -ClassName Win32_USBController -Filter 'ConfigManagerErrorCode != 22' | ForEach-Object {
        $usbPath = Join-Path 'HKLM:\SYSTEM\CurrentControlSet\Enum' $_.PNPDeviceID
        $entry   = Get-Item -Path $usbPath -ErrorAction Ignore
        if ($entry) {
            $cleanPath = $entry.PSPath -replace 'Microsoft\.PowerShell\.Core\\Registry::', 'HKLM:'
            $devices.Add([pscustomobject]@{ Path = $cleanPath })
        }
    }

    # Provision MSI and Core Affinity Policies
    foreach ($device in $devices) {
        try {
            $interruptMgmtPath = Join-Path $device.Path 'Device Parameters\Interrupt Management'
            $msiPath           = Join-Path $interruptMgmtPath 'MessageSignaledInterruptProperties'
            $affinityPath      = Join-Path $interruptMgmtPath 'Affinity Policy'

            foreach ($key in $msiPath, $affinityPath) {
                if (-not (Test-Path $key)) { New-Item $key -Force | Out-Null }
            }

            Set-ItemProperty -Path $msiPath -Name 'MSISupported' -Type DWord -Value 1 -Force
            Remove-ItemProperty -Path $msiPath -Name 'MessageNumberLimit' -ErrorAction Ignore

            if (-not $isLaptop) {
                Set-ItemProperty -Path $affinityPath -Name 'DevicePriority' -Type DWord -Value 0 -Force
            }
        } catch { }
    }

    Write-Host "Successfully"
    exit 0
}
catch {
    Write-Warning "Failed: $_"
    exit 1
}