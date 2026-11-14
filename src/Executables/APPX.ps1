$ErrorActionPreference = 'SilentlyContinue'

$bloatList = @(
    '*Microsoft.Microsoft3DViewer*',
    '*Microsoft.MixedReality.Portal*',
    '*MixedReality.Portal*',
    '*Microsoft.BingSearch*',
    '*Microsoft.BingNews*',
    '*Microsoft.BingWeather*',
    '*Bing*',
    '*Clipchamp.Clipchamp*',
    '*Microsoft.WindowsAlarms*',
    '*Microsoft.WindowsCamera*',
    '*Microsoft.WindowsFeedbackHub*',
    '*Microsoft.GetHelp*',
    '*Microsoft.Getstarted*',
    '*microsoft.windowscommunicationsapps*',
    '*Microsoft.WindowsMaps*',
    '*Microsoft.MicrosoftOfficeHub*',
    '*Microsoft.Office.OneNote*',
    '*Microsoft.OutlookForWindows*',
    '*OutlookForWindows*',
    '*OutlookPWA*',
    '*Microsoft.Paint*',
    '*Microsoft.MSPaint*',
    '*Microsoft.People*',
    '*Microsoft.PowerAutomateDesktop*',
    '*MicrosoftCorporationII.QuickAssist*',
    '*Microsoft.SkypeApp*',
    '*Microsoft.MicrosoftSolitaireCollection*',
    '*Microsoft.MicrosoftStickyNotes*',
    '*MicrosoftTeams*',
    '*MSTeams*',
    '*MicrosoftCorporationII.MailforSurfaceHub*',
    '*Microsoft.MicrosoftTeamsforSurfaceHub*',
    '*Microsoft.Todos*',
    '*Microsoft.WindowsSoundRecorder*',
    '*Microsoft.YourPhone*',
    '*Microsoft.Whiteboard*',
    '*Microsoft.MicrosoftPowerBIForWindows*',
    '*Sway*',
    '*Microsoft.ZuneMusic*',
    '*Microsoft.ZuneVideo*',
    '*Microsoft.Copilot*',
    '*Microsoft.Windows.Copilot*',
    '*Client.CoPilot*',
    '*Ai.Copilot*',
    '*Microsoft.549981C3F5F10*',
    '*MicrosoftWindows.Client.CoreAI*',
    '*MicrosoftWindows.Client.AIX*',
    '*MicrosoftWindows.Client.WebExperience*',
    '*Microsoft.WidgetsPlatformRuntime*',
    '*WebExperience*',
    '*WebExperienceHost*',
    '*Microsoft.StartExperiencesApp*',
    '*Microsoft.Edge.GameAssist*',
    '*ContentDeliveryManager*',
    '*DesktopSpotlight*',
    '*MicrosoftWindows.LKG.DesktopSpotlight*',
    '*IrisService*',
    '*MicrosoftWindows.LKG.IrisService*',
    '*Global.IrisService*',
    '*Global.ValueBanner*',
    '*Global.DesktopSpotlight*',
    '*CrossDeviceResume*',
    '*CrossDeviceResumeApp*',
    '*MicrosoftWindows.CrossDevice*',
    '*Microsoft.WindowsPhone*',
    '*MicrosoftCorporationII.MicrosoftFamily*',
    '*Parental*',
    '*ParentalControls*',
    '*Microsoft.Advertising*',
    '*Microsoft.Windows.DevHome*',
    '*DevHome*',
    '*Microsoft.Windows.SecureAssessmentBrowser*',
    '*PeopleExperienceHost*',
    '*AssignedAccessLockApp*',
    '*PinningConfirmationDialog*',
    '*Apprep.Chx*',
    '*CamoStudio*',
    '*Microsoft.Messaging*',
    '*Microsoft.OneConnect*',
    '*OOBENetwork*',
    '*SpotifyAB.SpotifyMusic*',
    '*Spotify*',
    '*Disney*',
    '*Flipgrid*'
)

$provisioned = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
if ($provisioned) {
    foreach ($pkg in $provisioned) {
        foreach ($pattern in $bloatList) {
            if ($pkg.PackageName -like $pattern -or $pkg.DisplayName -like $pattern) {
                Remove-AppxProvisionedPackage -Online -PackageName $pkg.PackageName -ErrorAction SilentlyContinue | Out-Null
                break
            }
        }
    }
}

$installed = Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue
if ($installed) {
    foreach ($pkg in $installed) {
        if ($pkg.IsFramework -or $pkg.NonRemovable) {
            continue
        }
        foreach ($pattern in $bloatList) {
            if ($pkg.Name -like $pattern -or $pkg.PackageFullName -like $pattern) {
                Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction SilentlyContinue
                break
            }
        }
    }
}

exit 0
