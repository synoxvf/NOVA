# PowerShell script to disable Windows power management on devices (MSPower_DeviceEnable)
# For desktops: globally disables idle sleep states for all PCIe/USB devices (ASPM/D3 blocks) to minimize stutters.
# For laptops: only prevents Windows from turning off connected serial ports to save power.

$ErrorActionPreference = 'SilentlyContinue'

$isLaptop = [bool]((Get-CimInstance -ClassName Win32_SystemEnclosure).ChassisTypes -match '^(8|9|10|11|12|14|18|21|30|31|32)$')

if (-not $isLaptop) {
    Get-CimInstance -Namespace "root\wmi" -ClassName "MSPower_DeviceEnable" | ForEach-Object {
        Set-CimInstance -InputObject $_ -Property @{Enable = $false}
    }
} else {
    $hubs = Get-CimInstance -ClassName Win32_SerialPort | Select-Object Name, DeviceID, Description, PNPDeviceID
    $powerMgmt = Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi

    if ($null -ne $powerMgmt -and $null -ne $hubs) {
        foreach ($p in $powerMgmt) {
            $IN = $p.InstanceName.ToUpper()
            foreach ($h in $hubs) {
                $PNPDI = $h.PNPDeviceID
                if ($IN -like "*$PNPDI*") {
                    Set-CimInstance -InputObject $p -Property @{Enable = $false}
                }
            }
        }
    }
}
