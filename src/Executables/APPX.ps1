[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateSet('Bloatware', 'Xbox', 'OneDrive')]
    [string]$Group = 'Bloatware'
)

$ErrorActionPreference = 'Stop'

# Use the Windows deployment API so Windows maintains package relationships.
# Never force-remove SystemApps, frameworks or records from StateRepository.
$groups = @{
    Bloatware = @(
        'Microsoft.Microsoft3DViewer', 'Microsoft.BingSearch',
        'Microsoft.WindowsCamera', 'Clipchamp.Clipchamp', 'Microsoft.WindowsAlarms',
        'Microsoft.Copilot', 'Microsoft.549981C3F5F10', 'Microsoft.Windows.DevHome',
        'MicrosoftCorporationII.MicrosoftFamily', 'Microsoft.WindowsFeedbackHub',
        'Microsoft.GetHelp', 'Microsoft.Getstarted', 'microsoft.windowscommunicationsapps',
        'Microsoft.WindowsMaps', 'Microsoft.MixedReality.Portal', 'Microsoft.BingNews',
        'Microsoft.MicrosoftOfficeHub', 'Microsoft.Office.OneNote', 'Microsoft.OutlookForWindows',
        'Microsoft.Paint', 'Microsoft.MSPaint', 'Microsoft.People',
        'Microsoft.PowerAutomateDesktop', 'MicrosoftCorporationII.QuickAssist',
        'Microsoft.SkypeApp', 'Microsoft.MicrosoftSolitaireCollection',
        'Microsoft.MicrosoftStickyNotes', 'MicrosoftTeams', 'MSTeams', 'Microsoft.Todos',
        'Microsoft.WindowsSoundRecorder', 'Microsoft.Wallet', 'Microsoft.BingWeather',
        'Microsoft.YourPhone', 'Microsoft.ZuneMusic', 'Microsoft.Messaging', 'Microsoft.OneConnect'
    )
    Xbox = @(
        'Microsoft.GamingApp', 'Microsoft.XboxApp', 'Microsoft.XboxSpeechToTextOverlay',
        'Microsoft.XboxIdentityProvider', 'Microsoft.Xbox.TCUI',
        'Microsoft.XboxGamingOverlay', 'Microsoft.XboxGameOverlay',
        'Microsoft.GamingServices', 'Microsoft.Edge.GameAssist'
    )
    OneDrive = @('Microsoft.OneDriveSync')
}

$names = $groups[$Group]
$installed = @(Get-AppxPackage -AllUsers -PackageTypeFilter Main, Bundle)
$protectedNames = @($installed | Where-Object {
    $_.NonRemovable -or $_.IsFramework -or $_.IsResourcePackage -or
    $_.InstallLocation -like "$env:windir\SystemApps\*"
} | Select-Object -ExpandProperty Name -Unique)

# Remove bundles through their parent, not each version/resource package.
$targets = @($installed | Where-Object {
    $_.Name -in $names -and $_.Name -notin $protectedNames
})
$bundleNames = @($targets | Where-Object IsBundle | Select-Object -ExpandProperty Name -Unique)
$targets = @($targets | Where-Object { $_.IsBundle -or $_.Name -notin $bundleNames } |
    Sort-Object PackageFullName -Unique)

foreach ($package in $targets) {
    if ($PSCmdlet.ShouldProcess($package.PackageFullName, 'Remove AppX package for all users')) {
        try {
            Remove-AppxPackage -Package $package.PackageFullName -AllUsers -ErrorAction Stop
        } catch {
            Write-Warning "[AppX] Kept $($package.PackageFullName): $($_.Exception.Message)"
        }
    }
}

foreach ($package in @(Get-AppxProvisionedPackage -Online)) {
    if ($package.DisplayName -notin $names -or $package.DisplayName -in $protectedNames) { continue }
    if ($PSCmdlet.ShouldProcess($package.PackageName, 'Remove AppX provisioning')) {
        try {
            Remove-AppxProvisionedPackage -Online -PackageName $package.PackageName -AllUsers -ErrorAction Stop | Out-Null
        } catch {
            Write-Warning "[AppX] Kept provisioning for $($package.DisplayName): $($_.Exception.Message)"
        }
    }
}
