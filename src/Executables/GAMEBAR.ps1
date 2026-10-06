[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$ConfigureGameBar,
    [switch]$UninstallXbox,
    [string]$SimulatedProcessorName,
    [switch]$TestMode
)

$ErrorActionPreference = 'SilentlyContinue'

$processorName = ''
if ($SimulatedProcessorName) {
    $processorName = $SimulatedProcessorName.Trim()
} else {
    $cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cpu -and $cpu.Name) {
        $processorName = $cpu.Name.Trim()
    }

    if (-not $processorName) {
        $processorName = (Get-ItemProperty -Path 'HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0' -Name 'ProcessorNameString' -ErrorAction SilentlyContinue).ProcessorNameString
    }
}

if (-not ([System.Management.Automation.PSTypeName]'CpuTopology').Type) {
    Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class CpuTopology {
    [DllImport("kernel32.dll", SetLastError=true)]
    static extern bool GetLogicalProcessorInformationEx(int rel, IntPtr buf, ref uint len);
    public static int EfficiencyClasses() {
        uint len = 0;
        GetLogicalProcessorInformationEx(0, IntPtr.Zero, ref len);
        if (len == 0) return 1;
        IntPtr buf = Marshal.AllocHGlobal((int)len);
        try {
            if (!GetLogicalProcessorInformationEx(0, buf, ref len)) return 1;
            var seen = new HashSet<byte>();
            long p = buf.ToInt64(); long end = p + len;
            while (p < end) {
                int size = Marshal.ReadInt32((IntPtr)(p + 4));
                seen.Add(Marshal.ReadByte((IntPtr)(p + 9)));
                p += size;
            }
            return seen.Count;
        } finally { Marshal.FreeHGlobal(buf); }
    }
    public static bool HasAsymmetricL3() {
        uint len = 0;
        GetLogicalProcessorInformationEx(2, IntPtr.Zero, ref len);
        if (len == 0) return false;
        IntPtr buf = Marshal.AllocHGlobal((int)len);
        try {
            if (!GetLogicalProcessorInformationEx(2, buf, ref len)) return false;
            var l3Sizes = new HashSet<uint>();
            long p = buf.ToInt64(); long end = p + len;
            while (p < end) {
                int rel = Marshal.ReadInt32((IntPtr)p);
                int size = Marshal.ReadInt32((IntPtr)(p + 4));
                if (rel == 2) {
                    byte level = Marshal.ReadByte((IntPtr)(p + 8));
                    uint cacheSize = (uint)Marshal.ReadInt32((IntPtr)(p + 12));
                    if (level == 3) {
                        l3Sizes.Add(cacheSize);
                    }
                }
                p += size;
            }
            return l3Sizes.Count > 1;
        } finally { Marshal.FreeHGlobal(buf); }
    }
}
'@
}

$isDualCcdX3D = ($processorName -match 'Ryzen.*(7900X3D|7950X3D|9900X3D|9950X3D)' -or ($processorName -match 'Ryzen\s+9' -and $processorName -match 'X3D'))
if (-not $isDualCcdX3D -and -not $SimulatedProcessorName) {
    $isDualCcdX3D = [CpuTopology]::HasAsymmetricL3()
}

$telemetry = [PSCustomObject]@{
    ProcessorName          = $processorName
    IsDualCcdX3D           = [bool]$isDualCcdX3D
    RegistrySettings       = @{}
    AppxRemoved            = @()
    ServicesDisabled       = @()
    PresenceWriterDisabled = $false
}

$userHive = 'Registry::HKEY_USERS\AME_UserHive_Default'

function Set-RegistryValueRecord {
    [CmdletBinding()]
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type = 'DWord'
    )

    if (-not $telemetry.RegistrySettings.ContainsKey($Path)) {
        $telemetry.RegistrySettings[$Path] = @{}
    }
    $telemetry.RegistrySettings[$Path][$Name] = $Value

    if (-not $TestMode) {
        if (-not (Test-Path -LiteralPath $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value -Force
    }
}

function Set-UserRegistryValue {
    [CmdletBinding()]
    param(
        [string]$SubKey,
        [string]$Name,
        [object]$Value,
        [string]$Type = 'DWord'
    )

    if ($userHive) {
        $targetPath = Join-Path $userHive $SubKey
        Set-RegistryValueRecord -Path $targetPath -Name $Name -Value $Value -Type $Type
    }
}

function Remove-XboxAppxPackages {
    [CmdletBinding()]
    param(
        [string[]]$Packages
    )

    if ($TestMode) { return }

    foreach ($pkg in $Packages) {
        # Provisioned packages (staged for new users)
        Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object {
            $_.PackageName -like $pkg -or $_.DisplayName -like $pkg
        } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

        # Existing user packages
        Get-AppxPackage -Name $pkg -AllUsers -ErrorAction SilentlyContinue | ForEach-Object {
            Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
        }
    }
}

if ($isDualCcdX3D) {
    if ($ConfigureGameBar) {
        Set-UserRegistryValue -SubKey 'SOFTWARE\Microsoft\GameBar' -Name 'AppCaptureEnabled'   -Value 0
        Set-UserRegistryValue -SubKey 'SOFTWARE\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -Value 1
        Set-UserRegistryValue -SubKey 'SOFTWARE\Microsoft\GameBar' -Name 'AllowAutoGameMode'    -Value 1
        Set-UserRegistryValue -SubKey 'System\GameConfigStore'    -Name 'GameDVR_enabled'       -Value 0
    }

    if ($UninstallXbox) {
        $targetPackages = @(
            '*Microsoft.GamingApp*',
            '*Microsoft.XboxApp*',
            '*Microsoft.XboxSpeechToTextOverlay*',
            '*Microsoft.XboxIdentityProvider*',
            '*Microsoft.Xbox.TCUI*'
        )
        $telemetry.AppxRemoved = $targetPackages

        Remove-XboxAppxPackages -Packages $targetPackages

        $targetServices = @('XblAuthManager', 'XblGameSave', 'XboxNetApiSvc')
        $telemetry.ServicesDisabled = $targetServices

        if (-not $TestMode) {
            foreach ($svc in $targetServices) {
                Set-Service -Name $svc -StartupType Manual -ErrorAction SilentlyContinue
                Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            }
            Unregister-ScheduledTask -TaskName 'XblGameSaveTask' -TaskPath '\Microsoft\Windows\XblGameSave\' -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
} else {
    if ($ConfigureGameBar) {
        $gameDvrPolicyKey  = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR'
        $presenceWriterKey = 'HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter'

        Set-RegistryValueRecord -Path $gameDvrPolicyKey  -Name 'AllowGameDVR'   -Value 0
        Set-RegistryValueRecord -Path $presenceWriterKey -Name 'ActivationType' -Value 0
        $telemetry.PresenceWriterDisabled = $true

        Set-UserRegistryValue -SubKey 'SOFTWARE\Microsoft\GameBar' -Name 'AppCaptureEnabled'         -Value 0
        Set-UserRegistryValue -SubKey 'SOFTWARE\Microsoft\GameBar' -Name 'UseNexusForGameBarEnabled' -Value 0
        Set-UserRegistryValue -SubKey 'SOFTWARE\Microsoft\GameBar' -Name 'ShowStartupPanel'          -Value 0
        Set-UserRegistryValue -SubKey 'System\GameConfigStore'    -Name 'GameDVR_enabled'           -Value 0
    }

    if ($UninstallXbox) {
        $targetPackages = @(
            '*Microsoft.GamingApp*',
            '*Microsoft.Xbox*',
            '*Microsoft.GamingServices*',
            '*Microsoft.XboxGameCallableUI*',
            '*Microsoft.Xbox.TCUI*',
            '*Microsoft.XboxApp*',
            '*Microsoft.XboxGameOverlay*',
            '*Microsoft.XboxGamingOverlay*',
            '*Microsoft.XboxIdentityProvider*',
            '*Microsoft.XboxSpeechToTextOverlay*'
        )
        $telemetry.AppxRemoved = $targetPackages

        Remove-XboxAppxPackages -Packages $targetPackages

        $targetServices = @('XblAuthManager', 'XblGameSave', 'XboxGipSvc', 'XboxNetApiSvc')
        $telemetry.ServicesDisabled = $targetServices

        if (-not $TestMode) {
            foreach ($svc in $targetServices) {
                Set-Service -Name $svc -StartupType Manual -ErrorAction SilentlyContinue
                Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            }
            Unregister-ScheduledTask -TaskName 'XblGameSaveTask' -TaskPath '\Microsoft\Windows\XblGameSave\' -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}

if ($TestMode) {
    return $telemetry
}

Write-Host "[GameBar] Successfully"
exit 0
