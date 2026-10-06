[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Edge,
    [switch]$OneDrive
)

$ErrorActionPreference = 'SilentlyContinue'

if (-not $Edge -and -not $OneDrive) {
    $Edge = $true
    $OneDrive = $true
}

$targetSignatures = @()
if ($Edge) {
    $targetSignatures += @(
        'microsoftedge',
        'microsoft edge',
        'edgeupdate',
        'edge update',
        'msedge'
    )
}
if ($OneDrive) {
    $targetSignatures += @(
        'onedrive',
        'onedrivesetup'
    )
}

$activeSetupHives = @(
    'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Active Setup\Installed Components',
    'Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Active Setup\Installed Components'
)

if (Test-Path -LiteralPath 'HKCU:\Software\Microsoft\Active Setup\Installed Components') {
    $activeSetupHives += 'HKCU:\Software\Microsoft\Active Setup\Installed Components'
}

Get-ChildItem -Path 'Registry::HKEY_USERS' -ErrorAction SilentlyContinue | Where-Object {
    ($_.PSChildName -match '^S-1-5-21-' -and $_.PSChildName -notmatch '_Classes$') -or ($_.PSChildName -match '^AME_UserHive_')
} | ForEach-Object {
    $activeSetupHives += "Registry::HKEY_USERS\$($_.PSChildName)\Software\Microsoft\Active Setup\Installed Components"
}

function Test-ComponentSignature {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string]$ComponentId,
        [string]$DisplayName,
        [string]$StubPath,
        [string[]]$Signatures
    )

    $payload = "$ComponentId $DisplayName $StubPath".ToLowerInvariant()
    foreach ($pattern in $Signatures) {
        if ($payload.Contains($pattern)) {
            return $true
        }
    }
    return $false
}

foreach ($hivePath in $activeSetupHives) {
    if (-not (Test-Path -LiteralPath $hivePath)) { continue }

    Get-ChildItem -LiteralPath $hivePath -ErrorAction SilentlyContinue | ForEach-Object {
        $componentKey = $_.PSPath
        $componentId  = $_.PSChildName
        $descriptor   = Get-ItemProperty -LiteralPath $componentKey -ErrorAction SilentlyContinue
        $displayName  = if ($descriptor.'(default)') { [string]$descriptor.'(default)' } else { '' }
        $stubPath     = if ($descriptor.StubPath)   { [string]$descriptor.StubPath }   else { '' }

        if (Test-ComponentSignature -ComponentId $componentId -DisplayName $displayName -StubPath $stubPath -Signatures $targetSignatures) {
            if ($descriptor.StubPath) {
                try {
                    Remove-ItemProperty -LiteralPath $componentKey -Name 'StubPath' -Force -ErrorAction SilentlyContinue
                } catch {}
            }
            try {
                Remove-Item -LiteralPath $componentKey -Recurse -Force -ErrorAction SilentlyContinue
            } catch {}
        }
    }
}

Write-Host "[ActiveSetup] Successfully"
exit 0
