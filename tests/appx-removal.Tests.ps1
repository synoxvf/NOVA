$ErrorActionPreference = 'Stop'
$appxScript = Join-Path $PSScriptRoot '..\src\Executables\APPX.ps1'
$global:NovaAppxTestremoved = @()
$global:NovaAppxTestdeprovisioned = @()

function New-Package($Name, $Suffix = 'main', [switch]$Bundle, [switch]$Protected, [switch]$Framework, [switch]$SystemApp) {
    [pscustomobject]@{
        Name = $Name
        PackageFullName = "${Name}_${Suffix}"
        IsBundle = [bool]$Bundle
        NonRemovable = [bool]$Protected
        IsFramework = [bool]$Framework
        IsResourcePackage = $false
        InstallLocation = if ($SystemApp) { "$env:windir\SystemApps\$Name" } else { "C:\Program Files\WindowsApps\$Name" }
    }
}

$global:NovaAppxTestinventory = @(
    New-Package 'Microsoft.BingNews' -Bundle
    New-Package 'Microsoft.BingNews' 'child'
    New-Package 'Microsoft.BingSearch' -Protected
    New-Package 'Microsoft.People' -SystemApp
    New-Package 'Microsoft.Todos' -Framework
    New-Package 'Microsoft.WindowsCamera'
    New-Package 'Microsoft.GamingApp'
    New-Package 'Microsoft.GamingServices'
    New-Package 'Microsoft.XboxGameCallableUI' -Protected
    New-Package 'Microsoft.WindowsStore'
    New-Package 'Microsoft.StorePurchaseApp'
    New-Package 'Microsoft.UI.Xaml.2.8' -Framework
    New-Package 'MicrosoftWindows.Client.AIX' -SystemApp
    New-Package 'Microsoft.BingNews.Unrelated'
)

function Get-AppxPackage {
    param([switch]$AllUsers, $PackageTypeFilter)
    if (-not $AllUsers -or 'Bundle' -notin $PackageTypeFilter) { throw 'Missing all-user/bundle enumeration' }
    $global:NovaAppxTestinventory
}
function Get-AppxProvisionedPackage {
    param([switch]$Online)
    foreach ($p in $global:NovaAppxTestinventory | Sort-Object Name -Unique) {
        [pscustomobject]@{ DisplayName = $p.Name; PackageName = "$($p.Name)_provisioned" }
    }
}
function Remove-AppxPackage {
    [CmdletBinding()] param($Package, [switch]$AllUsers)
    if (-not $AllUsers) { throw 'Missing AllUsers' }
    if ($Package -eq 'Microsoft.WindowsCamera_main') { throw 'Simulated deployment failure' }
    $global:NovaAppxTestremoved += $Package
}
function Remove-AppxProvisionedPackage {
    [CmdletBinding()] param($PackageName, [switch]$Online, [switch]$AllUsers)
    if (-not $AllUsers -or -not $Online) { throw 'Missing provisioning flags' }
    $global:NovaAppxTestdeprovisioned += $PackageName
}
# Any filesystem, registry, service or external-process fallback is a regression.
function Remove-Item { throw 'Unexpected direct filesystem/registry deletion' }
function Remove-ItemProperty { throw 'Unexpected registry deletion' }
function Set-Service { throw 'Unexpected service change' }
function Stop-Service { throw 'Unexpected service stop' }
function Start-Process { throw 'Unexpected external process' }

function Assert-Equal($Actual, $Expected, $Message) {
    if (($Actual -join '|') -ne ($Expected -join '|')) {
        throw "$Message : got [$($Actual -join ', ')] expected [$($Expected -join ', ')]"
    }
}

& $appxScript -Group Bloatware -WarningVariable removalWarnings
Assert-Equal $global:NovaAppxTestremoved @('Microsoft.BingNews_main') 'Only removable allowlisted parent bundles are removed'
Assert-Equal ($global:NovaAppxTestdeprovisioned | Sort-Object) @('Microsoft.BingNews_provisioned', 'Microsoft.WindowsCamera_provisioned') 'Protected/system/framework packages are retained'
if (-not ($removalWarnings -match 'Simulated deployment failure')) { throw 'Removal failure was not reported' }

$global:NovaAppxTestremoved = @(); $global:NovaAppxTestdeprovisioned = @()
& $appxScript -Group Xbox
Assert-Equal ($global:NovaAppxTestremoved | Sort-Object) @('Microsoft.GamingApp_main', 'Microsoft.GamingServices_main') 'Xbox removal is explicit and keeps protected packages'

$global:NovaAppxTestremoved = @(); $global:NovaAppxTestdeprovisioned = @()
& $appxScript -Group Bloatware -WhatIf
Assert-Equal $global:NovaAppxTestremoved @() 'WhatIf must not remove apps'
Assert-Equal $global:NovaAppxTestdeprovisioned @() 'WhatIf must not remove provisioning'
Write-Host 'PASS: allowlist, bundles, protected packages, failures, Xbox opt-in and WhatIf'
