$ErrorActionPreference = 'SilentlyContinue'

$runtimeDirectory = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
$env:PATH = "$runtimeDirectory;$env:PATH"

[AppDomain]::CurrentDomain.GetAssemblies().Location |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    ForEach-Object {
        ngen install $_ | Out-Null
    }

exit 0