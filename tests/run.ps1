$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

# Parse scripts without executing any playbook actions against the host.
$scripts = Get-ChildItem (Join-Path $root 'src') -Recurse -Filter '*.ps1'
foreach ($script in $scripts) {
    $tokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile(
        $script.FullName, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors) { throw "$($script.FullName): $parseErrors" }
}
Write-Host "PASS: PowerShell syntax ($($scripts.Count) scripts)"

& (Join-Path $PSScriptRoot 'appx-removal.Tests.ps1')

# Exercise both Game Bar CPU branches without changing services or the registry.
$gamebar = Join-Path $root 'src\Executables\GAMEBAR.ps1'
foreach ($cpu in @('AMD Ryzen 7 7800X3D', 'AMD Ryzen 9 7950X3D', 'Intel Core i7-13700K')) {
    foreach ($configure in @($false, $true)) {
        $result = & $gamebar -SimulatedProcessorName $cpu -TestMode -ConfigureGameBar:$configure
        if ($result.AppxRemoved.Count -ne 0 -or $result.ServicesDisabled.Count -ne 0) {
            throw "Keeping Xbox failed for $cpu (ConfigureGameBar=$configure)"
        }
    }
    $removed = & $gamebar -SimulatedProcessorName $cpu -TestMode -UninstallXbox
    if ($removed.AppxRemoved -notcontains '*Microsoft.GamingApp*' -or
        $removed.ServicesDisabled -notcontains 'XblAuthManager') {
        throw "Explicit Xbox removal did not select the expected targets for $cpu"
    }
    if ($removed.AppxRemoved -contains '*Microsoft.XboxGameCallableUI*') {
        throw "Protected system Xbox package selected for $cpu"
    }
}
Write-Host 'PASS: Xbox retention, independent DVR configuration and explicit removal on three CPU paths'
