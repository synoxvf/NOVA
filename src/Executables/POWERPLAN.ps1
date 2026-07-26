# Writes CPU topology-specific performance overrides into the imported NOVA scheme.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$proc     = '54533251-82be-4824-96c1-47b60b740d00'
$novaGuid = '00000000-0000-0000-0000-000000000000'
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

$cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop |
    Select-Object -First 1
if ($null -eq $cpu) {
    throw 'Win32_Processor did not return a CPU.'
}

$name = $cpu.Name.Trim()
$isIntel = $cpu.Manufacturer -match 'Intel'
$isLockedIntel = $isIntel -and ($name -notmatch '(?i)\b\d{3,5}\s*(K|KF|KS|X|XE)\b')

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
}
'@
}
$efficiencyClasses = [CpuTopology]::EfficiencyClasses()
$isHybrid = $efficiencyClasses -gt 1

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

if ($isLockedIntel) {
    Set-Idx '06cadf0e-64ed-448a-8927-ce7bf90eb35d' 1 1
    Set-Idx '06cadf0e-64ed-448a-8927-ce7bf90eb35e' 1 1
    Set-Idx '4b92d758-5a24-4851-a470-815d78aee119' 1 1
} else {
    Set-Idx '06cadf0e-64ed-448a-8927-ce7bf90eb35d' 0 0
    Set-Idx '06cadf0e-64ed-448a-8927-ce7bf90eb35e' 0 0
}

if ($isHybrid) {
    Set-Idx '93b8b6dc-0698-4d1c-9ee4-0644e900c85d' 2   5
    Set-Idx 'bae08b81-2d5e-4688-ad6a-13243356654b' 1   5
    Set-Idx '7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5' 0   0
    Set-Idx 'b669a5e9-7b1d-4132-baaa-49190abcfeb6' 1   1
    Set-Idx '2430ab6f-a520-44a2-9601-f7f23b5134b1' 100 0
    Set-Idx 'f735a673-2066-4f80-a0c5-ddee0cf1bf5d' 100 0
    Set-Idx '6788488b-1b90-4d11-8fa7-973e470dff47' 100 100
    Set-Idx '69439b22-221b-4830-bd34-f7bcece24583' 100 100
    Set-Idx '0cc5b647-c1df-4637-891a-dec35c318584' 100 50
    Set-Idx '828423eb-8662-4344-90f7-52bf15870f5a' 255 255
    Set-Idx 'bf903d33-9d24-49d3-a468-e65e0325046a' 255 255
}

Invoke-PowerCfg -Arguments @('/setactive', $novaGuid)
