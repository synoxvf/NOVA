$publicDesktop = [Environment]::GetFolderPath('CommonDesktopDirectory')
$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $publicDesktop "Post-Install.lnk"))
$shortcut.TargetPath = "$env:windir\Post-Install"
$shortcut.Save()