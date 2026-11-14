[CmdletBinding()]
param(
    [string]$SimulatedProcessorName
)

# Writes CPU topology-specific performance overrides into the imported NOVA scheme.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$proc     = '54533251-82be-4824-96c1-47b60b740d00'
$novaGuid = '2260e152-6d07-4704-affc-0c74cebbdde0'
$powerCfg = Join-Path -Path $env:SystemRoot -ChildPath 'System32\powercfg.exe'

if (-not (Test-Path -LiteralPath $powerCfg)) {
    throw "powercfg.exe was not found at '$powerCfg'."
}

function Invoke-PowerCfg {
    param(
        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    & $powerCfg @Arguments | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "powercfg.exe failed with exit code $LASTEXITCODE`: $($Arguments -join ' ')"
    }
}

Invoke-PowerCfg -Arguments @('/query', $novaGuid)

$name = ''
if ($SimulatedProcessorName) {
    $name = $SimulatedProcessorName.Trim()
} else {
    $cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop |
        Select-Object -First 1
    if ($null -eq $cpu) {
        throw 'Win32_Processor did not return a CPU.'
    }
    $name = $cpu.Name.Trim()
}

$isDualCcdX3D = ($name -match 'Ryzen.*(7900X3D|7950X3D|9900X3D|9950X3D)' -or ($name -match 'Ryzen\s+9' -and $name -match 'X3D'))

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
$efficiencyClasses = [CpuTopology]::EfficiencyClasses()
$isHybrid = $efficiencyClasses -gt 1
if (-not $isHybrid -and ($name -match '(?i)\b(12|13|14)\d{3}|Ultra')) {
    $isHybrid = $true
}
if (-not $isDualCcdX3D) {
    $isDualCcdX3D = [CpuTopology]::HasAsymmetricL3()
}

function Set-Idx {
    param(
        [Parameter(Mandatory)]
        [string]$Setting,

        [Parameter(Mandatory)]
        [ValidateRange(0, 255)]
        [int]$Ac,

        [Parameter(Mandatory)]
        [ValidateRange(0, 255)]
        [int]$Dc
    )

    Invoke-PowerCfg -Arguments @('/setacvalueindex', $novaGuid, $proc, $Setting, $Ac)
    Invoke-PowerCfg -Arguments @('/setdcvalueindex', $novaGuid, $proc, $Setting, $Dc)
}

Invoke-PowerCfg -Arguments @('/setacvalueindex', $novaGuid, 'fea3413e-7e05-4911-9a71-700331f1c294', '245d8541-3943-4422-b025-13a784f679b7', 2)
Invoke-PowerCfg -Arguments @('/setdcvalueindex', $novaGuid, 'fea3413e-7e05-4911-9a71-700331f1c294', '245d8541-3943-4422-b025-13a784f679b7', 2)
Invoke-PowerCfg -Arguments @('/setacvalueindex', $novaGuid, '48672f38-7a9a-4bb2-8bf8-3d85be19de4e', '2bfc24f9-5ea2-4801-8213-3dbae01aa39d', 0)
Invoke-PowerCfg -Arguments @('/setdcvalueindex', $novaGuid, '48672f38-7a9a-4bb2-8bf8-3d85be19de4e', '2bfc24f9-5ea2-4801-8213-3dbae01aa39d', 0)
Invoke-PowerCfg -Arguments @('/setacvalueindex', $novaGuid, '48672f38-7a9a-4bb2-8bf8-3d85be19de4e', '73cde64d-d720-4bb2-a860-c755afe77ef2', 50)
Invoke-PowerCfg -Arguments @('/setdcvalueindex', $novaGuid, '48672f38-7a9a-4bb2-8bf8-3d85be19de4e', '73cde64d-d720-4bb2-a860-c755afe77ef2', 50)

if ($isHybrid) {
    Set-Idx '93b8b6dc-0698-4d1c-9ee4-0644e900c85d' 2   5
    Set-Idx 'bae08b81-2d5e-4688-ad6a-13243356654b' 1   5
    Set-Idx '7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5' 0   0
    Set-Idx 'b669a5e9-7b1d-4132-baaa-49190abcfeb6' 1   1
    Set-Idx '2430ab6f-a520-44a2-9601-f7f23b5134b1' 100 0
    Set-Idx 'f735a673-2066-4f80-a0c5-ddee0cf1bf5d' 100 0
    Set-Idx '6788488b-1b90-4d11-8fa7-973e470dff47' 100 100
    Set-Idx '69439b22-221b-4830-bd34-f7bcece24583' 100 10
    Set-Idx '0cc5b647-c1df-4637-891a-dec35c318584' 50  50
    Set-Idx '828423eb-8662-4344-90f7-52bf15870f5a' 255 255
    Set-Idx 'bf903d33-9d24-49d3-a468-e65e0325046a' 255 255
}

if ($isDualCcdX3D) {
    Set-Idx '0cc5b647-c1df-4637-891a-dec35c318583' 50  50
    Set-Idx '616cdaa5-695e-4545-97ad-97dc2d1bdd88' 50  50
    Set-Idx '93b8b6dc-0698-4d1c-9ee4-0644e900c85d' 2   5
    Set-Idx 'bae08b81-2d5e-4688-ad6a-13243356654b' 2   5
} elseif (-not $isHybrid) {
    Set-Idx '0cc5b647-c1df-4637-891a-dec35c318583' 100 50
    Set-Idx '616cdaa5-695e-4545-97ad-97dc2d1bdd88' 100 50
}

Invoke-PowerCfg -Arguments @('/setactive', $novaGuid)
