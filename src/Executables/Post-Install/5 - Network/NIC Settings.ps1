$ErrorActionPreference = 'SilentlyContinue'
$isLaptop = [bool]((Get-CimInstance -ClassName Win32_SystemEnclosure).ChassisTypes -match '^(8|9|10|11|12|14|18|21|30|31|32)$')

$vendorProfiles = @{

    '8086_NDIS' = {  # Intel Gigabit NDIS
        $base = [ordered]@{
            '*InterruptModeration'         = '0'
            'ITR'                          = '0'
            '*PriorityVLANTag'             = '0'
            '*WakeOnMagicPacket'           = '0'
            '*WakeOnPattern'               = '0'
            '*ModernStandbyWoLMagicPacket' = '0'
            'WakeOnLink'                   = '0'
            'WakeOnSlot'                   = '0'
            'WakeOn'                       = '0'
            'WakeFromS5'                   = '0'
            'EnablePME'                    = '0'
            'LogLinkStateEvent'            = '16'
            'WaitAutoNegComplete'          = '0'
            'LinkNegotiationProcess'       = '1'
            '*VMQ'                         = '0'
            'VMQSupported'                 = '0'
            'SipsEnabled'                  = '0'
            'EnableTss'                    = '0'
            'WaitForValidPhyIDRead'        = '0'
            'SleepWhileWaiting'            = '0'
            'EnableETW'                    = '0'
            'OBFFEnabled'                  = '0'
            'ForceLtrValue'                = '0'
            'LatencyToleranceReporting'    = '0'
            'EnablePHYFlexibleSpeed'       = '0'
            'EnablePHYWakeUp'              = '0'
            'EnableD0PHYFlexibleSpeed'     = '0'
            'EnableSavePowerNow'           = '0'
            'WakeOnFastStartup'            = '0'
            'EnableD3ColdInS0'             = '0'
            '*SSIdleTimeout'               = '0'
            'SSIdleTimeoutMS'              = '0'
            'EnableAdaptiveQueuing'        = '0'
            'StoreBadPackets'              = '0'
            '*StoreBadPackets'             = '0'
            'DropHighlyFragmentedPacket'   = '1'
            'EnableCoalesce'               = '0'
            'AllowFlowControlFrames'       = '0'
            'ReduceSpeedOnPowerDown'       = '0'
            'AdaptiveIFS'                  = '0'
            'ULPMode'                      = '0'
            'EnableK1'                     = '0'
            'SVOFFMode'                    = '0'
            '*NumRssQueues'                = '2'
            'I218DisablePLLShut'           = '1'
            'I218DisablePLLShutGiga'       = '1'
            'I219DisableK1Off'             = '1'
            'DMACoalescing'                = '0'
            'EnableLLI'                    = '0'
            'EnableWakeOnManagmentOnTCO'   = '0'
            '*PtpHardwareTimestamp'        = '0'
            '*SoftwareTimestamp'           = '0'
            'WakeOnPort'                   = '0'
        }
        if (-not $isLaptop) {
            $base['DynamicLTR']                              = '0'
            $base['*SelectiveSuspend']                       = '0'
            $base['EnableModernStandby']                     = '0'
            $base['EnablePowerManagement']                   = '0'
            $base['ForceWakeFromMagicPacketOnModernStandby'] = '0'
            $base['EnableDisconnectedStandby']               = '0'
            $base['*EnableDynamicPowerGating']               = '0'
            $base['*NicAutoPowerSaver']                      = '0'
            $base['AutoPowerSaveModeEnabled']                = '0'
            $base['DisableIntelRST']                         = '1'
        }
        $base
    }

    '8086_CX' = {  # Intel 2.5GbE NetAdapterCx
        $base = [ordered]@{
            '*InterruptModeration'         = '0'
            'ITR'                          = '0'
            '*PriorityVLANTag'             = '0'
            '*WakeOnMagicPacket'           = '0'
            '*WakeOnPattern'               = '0'
            '*ModernStandbyWoLMagicPacket' = '0'
            'WakeOnMagicPacketFromS5'      = '0'
            'WakeOnLink'                   = '0'
            'WakeOnSlot'                   = '0'
            'WakeOn'                       = '0'
            'WakeFromS5'                   = '0'
            '*EEE'                         = '0'
            '*IdleRestriction'             = '0'
            'IdleTimeoutMs'                = '0'
            'PollPhyId'                    = '0'
        }
        if (-not $isLaptop) {
            $base['DynamicLTR']                              = '0'
            $base['*SelectiveSuspend']                       = '0'
            $base['EnableModernStandby']                     = '0'
            $base['EnablePowerManagement']                   = '0'
            $base['ForceWakeFromMagicPacketOnModernStandby'] = '0'
            $base['EnableDisconnectedStandby']               = '0'
            $base['*EnableDynamicPowerGating']               = '0'
            $base['*NicAutoPowerSaver']                      = '0'
            $base['AutoPowerSaveModeEnabled']                = '0'
            $base['DisableIntelRST']                         = '1'
        }
        $base
    }

    '10EC_NDIS' = {  # Realtek NDIS
        $base = [ordered]@{
            '*InterruptModeration'         = '0'
            '*PriorityVLANTag'             = '0'
            '*NumRssQueues'                = '2'
            '*JumboPacket'                 = '1514'
            'PowerSavingMode'              = '0'
            'EnableGreenEthernet'          = '0'
            'GreenEthernet'                = '0'
            '*GreenEthernet'               = '0'
            'AdvancedEEE'                  = '0'
            'GigaLite'                     = '0'
            'AutoDisableGigabit'           = '0'
            'AutoLinkDownPcieMacOff'       = '0'
            '*WakeOnMagicPacket'           = '0'
            '*WakeOnPattern'               = '0'
            'S5WakeOnLan'                  = '0'
            'S4WakeOnLan'                  = '0'
            'WakeOnLinkUp'                 = '0'
            'WakeOnLinkChg'                = '0'
            'WolShutdownLinkSpeed'         = '2'
            'PowerDownPll'                 = '0'
            '*SSIdleTimeout'               = '0'
            '*SSIdleTimeoutScreenOff'      = '0'
        }
        if (-not $isLaptop) {
            $base['*SelectiveSuspend']                       = '0'
            $base['*IdleRestriction']                        = '0'
        }
        $base
    }

    '10EC_CX' = {  # Realtek NetAdapterCx
        $base = [ordered]@{
            '*InterruptModeration'         = '0'
            '*PriorityVLANTag'             = '0'
            '*NumRssQueues'                = '2'
            '*JumboPacket'                 = '1514'
            'PowerSavingMode'              = '0'
            'EnableGreenEthernet'          = '0'
            'AdvancedEEE'                  = '0'
            'GigaLite'                     = '0'
            '*WakeOnMagicPacket'           = '0'
            '*WakeOnPattern'               = '0'
            'S5WakeOnLan'                  = '0'
            'S4WakeOnLan'                  = '0'
            'WakeOnLinkUp'                 = '0'
            'WakeOnLinkChg'                = '0'
            'WolShutdownLinkSpeed'         = '2'
        }
        $base
    }
}

$common = [ordered]@{
    '*DeviceSleepOnDisconnect'            = '0'
    '*EEE'                                = '0'
    '*FlowControl'                        = '0'
    '*RscIPv4'                            = '0'
    '*RscIPv6'                            = '0'
    '*IPChecksumOffloadIPv4'              = '3'
    '*LsoV1IPv4'                          = '0'
    '*LsoV2IPv4'                          = '0'
    '*LsoV2IPv6'                          = '0'
    '*TCPChecksumOffloadIPv4'             = '3'
    '*TCPChecksumOffloadIPv6'             = '3'
    '*UDPChecksumOffloadIPv4'             = '3'
    '*UDPChecksumOffloadIPv6'             = '3'
    '*PMARPOffload'                       = '0'
    '*PMNSOffload'                        = '0'
    '*PMWiFiRekeyOffload'                 = '0'
    '*ModernStandbyWoLMagicPacket'        = '0'
}

$classPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}'

Get-ChildItem $classPath | Where-Object { $_.PSChildName -match '^\d{4}$' } | ForEach-Object {

    $path = $_.PSPath
    $data = Get-ItemProperty -Path $path
    $ndi  = Get-ItemProperty -Path "$path\Ndi" -ErrorAction SilentlyContinue
    $service = $ndi.Service
    $dev  = $data.MatchingDeviceId

    if ([string]::IsNullOrWhiteSpace($dev) -or $dev -notmatch '^PCI\\') { return }
    if ($dev -notmatch 'VEN_([0-9A-Fa-f]{4})') { return }

    $vendorId = $Matches[1].ToUpper()

    $svcDeps = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\$service" -ErrorAction SilentlyContinue).DependOnService
    $isCx    = ($svcDeps -contains 'NetAdapterCx') -or ($vendorId -eq '10EC' -and $service -match 'cx')

    $profileKey = switch ($vendorId) {
        '8086' { if ($isCx) { '8086_CX' } else { '8086_NDIS' } }
        '10EC' { if ($isCx) { '10EC_CX' } else { '10EC_NDIS' } }
        default { $vendorId }
    }

    if (-not $vendorProfiles.ContainsKey($profileKey)) { return }

    Remove-ItemProperty -Path $path -Name '*SpeedDuplex' -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $path -Name 'SpeedDuplex'  -ErrorAction SilentlyContinue

    $config = [ordered]@{}
    $common.Keys | ForEach-Object { $config[$_] = $common[$_] }
    $vendorConfig = $vendorProfiles[$profileKey].Invoke()[0]
    $vendorConfig.Keys | ForEach-Object { $config[$_] = $vendorConfig[$_] }

    $dwordKeys = @(
        'PnPCapabilities', 'TxOptimizeThreshold', 'RxOptimizeThreshold', 
        'SwIML', 'SwIML100', 'SwIMLV2', 'SwIML100V2',
        'HwOption', 'HwOptionV2', 'HwOptionV3', 
        'DACount', 'DAInterval', 'RtIdleTimeout', 'IntMitiInterval', 'WakeOnPort'
    )
    $config.Keys | ForEach-Object {
        $type = if ($_ -in $dwordKeys) { 'DWord' } else { 'String' }
        Set-ItemProperty -Path $path -Name $_ -Value $config[$_] -Type $type -Force
    }

    if ($data.NetCfgInstanceId) {
        $adapter = Get-NetAdapter | Where-Object { $_.InterfaceGuid -eq $data.NetCfgInstanceId }
        if ($adapter) {
            Disable-NetAdapter -Name $adapter.Name -Confirm:$false
            Start-Sleep -Seconds 2
            Enable-NetAdapter -Name $adapter.Name -Confirm:$false
        }
    }

    Write-Host "[$profileKey] $($data.DriverDesc) - done." -ForegroundColor Cyan
}

Get-NetAdapter | ForEach-Object {
    $netbtPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\Tcpip_$($_.InterfaceGuid)"
    if (Test-Path $netbtPath) {
        Set-ItemProperty -Path $netbtPath -Name 'NetbiosOptions' -Value 2 -Type DWord -Force
    }
}

$unnecessaryProtocols = @(
    'ms_tcpip6',
    'ms_msclient',
    'ms_server',
    'ms_lltdio',
    'ms_rspndr',
    'ms_lldp'
)
Get-NetAdapterBinding -Name '*' -ComponentID $unnecessaryProtocols -ErrorAction SilentlyContinue | Disable-NetAdapterBinding -PassThru -ErrorAction SilentlyContinue | Out-Null

Write-Host 'Network Adapter optimization complete.' -ForegroundColor Green
pause
