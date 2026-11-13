# Xbox and Microsoft Store compatibility

This change addresses playbook operations that can interfere with installing or
updating packaged applications, as reported in [issue #7](https://github.com/synoxvf/NOVA/issues/7).
It is intended for a fresh Windows installation. It does not rebuild an already
damaged AppX repository.

## Behavior

Optional apps are removed through `Remove-AppxPackage` and
`Remove-AppxProvisionedPackage`, using exact package names. Frameworks, resource
packages, non-removable packages and packages under `Windows\SystemApps` are
retained. Bundle removal targets the parent bundle. If Windows rejects a removal,
the script reports a warning and leaves Windows responsible for the package's
files, registrations and service entries.

The playbook preserves WebView2 and the shared Edge updater, enables Store update
tasks, and sets the documented Store `AutoDownload` policy to `4`. Windows Update
pause settings are cleared from `HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings`.
Suspending Windows updates or disabling NTFS compression requires selecting the
corresponding new option; both are unchecked by default. Forced component-store
cleanup at the end of OOBE is removed. Cleanup preserves update payloads and
AppX/servicing diagnostic logs without stopping delivery services.

The existing six options for removing Edge, installing replacement software,
removing Xbox, disabling Game Bar/DVR, disabling BitLocker and disabling
hibernation remain **checked by default**, now explicitly with `IsChecked="true"`.
This preserves upstream's existing defaults (AME checkboxes default to checked).

- To keep Xbox installed, uncheck **Remove Xbox services and apps**.
- To keep Game Bar recording and overlays, also uncheck **Disable GameBar and DVR**.
- Selecting Xbox removal uninstalls the optional apps through Windows. It does
  not manually delete Gaming Services registry keys, profile data or system Xbox
  packages. Keeping the deployment infrastructure permits later Store installs;
  this is not a guarantee for every pre-existing Windows installation.

## Validation

Run in Windows PowerShell 5.1 or later:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tests\run.ps1
python -m pip install -r requirements-dev.txt
python tools\build_playbook.py
```

The PowerShell tests use mocked package operations and Game Bar's `TestMode`, so
they do not remove host apps or change host services. They cover bundle parents,
exact-name matching, protected/system/framework packages, failed removals,
explicit Xbox removal and `WhatIf`. The build script checks XML/YAML, feature
defaults, file references and servicing rules, creates `dist\NOVA.apbx` with AME's
`malte` password, then extracts it and compares every file with the sources.

The modified playbook's user reported it working in their setup. A complete
automated clean-install and Xbox uninstall/reinstall matrix has not been run.
Issue #7's exact root cause is still unconfirmed: the reporter already tested
restoring NTFS compression and changing update policies without resolving the
failure. These changes remove unsafe deployment operations and conflicting
settings without claiming that either setting alone explains `0x80070490`.

## References

- [AME checkbox defaults](https://docs.amelabs.net/developers/features/pages/checkboxpage.html)
- [Microsoft Store policy values](https://learn.microsoft.com/en-us/windows/msix/group-policy-msix)
- [Remove-AppxPackage bundle behavior](https://learn.microsoft.com/en-us/powershell/module/appx/remove-appxpackage)
- [AME playbook packaging](https://docs.amelabs.net/creating_playbooks.html)
