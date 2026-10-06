# PowerShell script to disable Windows power management on USB devices

$ErrorActionPreference = 'SilentlyContinue'

$chassisTypes = (Get-CimInstance -ClassName Win32_SystemEnclosure -ErrorAction SilentlyContinue).ChassisTypes
$laptopTypes = 8..12 + 14 + 18 + 21 + 30..32
$isLaptop = $false
foreach ($type in $chassisTypes) {
    if ($type -in $laptopTypes) {
        $isLaptop = $true
        break
    }
}

if (-not $isLaptop) {
    Get-CimInstance -Namespace "root\wmi" -ClassName "MSPower_DeviceEnable" -ErrorAction SilentlyContinue | ForEach-Object {
        Set-CimInstance -InputObject $_ -Property @{ Enable = $false } -ErrorAction SilentlyContinue
    }
    Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Enum\USB' -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.PSChildName -eq 'Device Parameters') {
            Set-ItemProperty -Path $_.PSPath -Name SelectiveSuspendEnabled -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $_.PSPath -Name AllowIdleIrpInD3 -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $_.PSPath -Name DeviceSelectiveSuspended -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $_.PSPath -Name EnhancedPowerManagementEnabled -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
        }
        elseif ($_.PSChildName -eq 'Wdf') {
            Set-ItemProperty -Path $_.PSPath -Name IdleInWorkingState -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $_.PSPath -Name WdfDefaultIdleInWorkingState -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $_.PSPath -Name WdfDirectedPowerTransitionEnable -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
        }
    }
} else {
    $hubs = Get-CimInstance -ClassName Win32_PnPEntity -ErrorAction SilentlyContinue | Where-Object { $_.PNPClass -eq 'Ports' -or $_.PNPClass -eq 'USB' }
    $powerMgmt = Get-CimInstance -Namespace "root\wmi" -ClassName "MSPower_DeviceEnable" -ErrorAction SilentlyContinue

    if ($null -ne $powerMgmt -and $null -ne $hubs) {
        foreach ($p in $powerMgmt) {
            $instanceUpper = $p.InstanceName.ToUpper()
            foreach ($h in $hubs) {
                if ($null -ne $h.PNPDeviceID -and $instanceUpper -like "*$($h.PNPDeviceID.ToUpper())*") {
                    Set-CimInstance -InputObject $p -Property @{ Enable = $false } -ErrorAction SilentlyContinue
                }
            }
        }
    }
}
