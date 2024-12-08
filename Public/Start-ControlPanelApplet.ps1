$CplApplets = @{
    'appwiz.cpl'   = 'Programs and Features (Add/Remove Programs)'
    'bthprops.cpl' = 'Bluetooth Settings'
    'desk.cpl'     = 'Display Settings'
    'firewall.cpl' = 'Windows Defender Firewall'
    'hdwwiz.cpl'   = 'Device Manager'
    'inetcpl.cpl'  = 'Internet Options'
    'intl.cpl'     = 'Region and Language Settings'
    'irprops.cpl'  = 'Infrared Settings'
    'joy.cpl'      = 'Game Controllers'
    'main.cpl'     = 'Mouse Properties'
    'mmsys.cpl'    = 'Sound (Audio Devices)'
    'ncpa.cpl'     = 'Network Connections'
    'powercfg.cpl' = 'Power Options'
    'sysdm.cpl'    = 'System Properties'
    'TabletPC.cpl' = 'Tablet PC Settings'
    'telephon.cpl' = 'Phone and Modem Options'
    'timedate.cpl' = 'Date and Time Settings'
    'wscui.cpl'    = 'Security and Maintenance (Action Center)'
}

function Start-ControlPanelApplet {
    [CmdletBinding()]
    [Alias('Start-Cpl')]
    param(
        [Parameter()]
        [ArgumentCompleter({
                param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
                $CplApplets.Keys.Where({ $_ -like "$WordToComplete*" }) | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new(
                        $_,
                        ('{0} ({1})' -f $_, $CplApplets[$_]),
                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                        ('{0} ({1})' -f $_, $CplApplets[$_])
                    )
                }
            })]
        [string]$Applet
    )
    # Start the specified applet
    Start-Process $Applet
}
