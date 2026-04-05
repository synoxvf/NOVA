$ErrorActionPreference = 'SilentlyContinue'
sc.exe stop SysMain
sc.exe config SysMain start= disabled
