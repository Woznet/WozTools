using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Security.AccessControl
using namespace Microsoft.Win32

function Get-InstalledSoftware {
    <#
    .NOTES
    Source: https://gist.github.com/SeeminglyScience/d7be8c59875bd389df820c8356f137f9
#>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string] $Name
    )
    begin {
        $AllNames = $null
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('Name') -or [string]::IsNullOrEmpty($Name)) {
            return
        }

        if ($null -eq $AllNames) {
            $StartingCapacity = 1
            if ($MyInvocation.ExpectingInput) {
                $StartingCapacity = 4
            }
            $AllNames = [List[string]]::new($StartingCapacity)
        }
        $AllNames.Add($Name)
    }
    end {
        if ($null -ne $AllNames) {
            $Wildcards = [WildcardPattern[]]::new($AllNames.Count)
            for ($I = 0; $I -lt $AllNames.Count; $I++) {
                $Wildcards[$I] = [WildcardPattern]::new(
                    $AllNames[$I],
                    [WildcardOptions]::IgnoreCase
                )
            }
        }

        $HKLM = $null
        $HKCU = $null

        $OwnsKeyHKLM = $false
        $OwnsKeyHKCU = $false
        try {
            $RegistryPaths = (
                @{
                    Path = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
                    Is64Bit = $true
                },
                @{
                    Path = 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
                    Is64Bit = $false
                })

            $HKLM = [Registry]::LocalMachine
            $HKCU = [Registry]::CurrentUser

            if (-not [Environment]::Is64BitProcess) {
                if ([Environment]::Is64BitOperatingSystem) {
                    $OwnsKeyHKLM = $true
                    $HKLM = [RegistryKey]::OpenBaseKey([RegistryHive]::LocalMachine, [RegistryView]::Registry64)

                    $OwnsKeyHKCU = $true
                    $HKCU = [RegistryKey]::OpenBaseKey([RegistryHive]::CurrentUser, [RegistryView]::Registry64)
                }
                else {
                    $RegistryPaths = @($RegistryPaths[0])
                    $RegistryPaths[0].Is64Bit = $false
                }
            }

            foreach ($RegHive in @($HKLM, $HKCU)) {

                foreach ($RegistryPath in $RegistryPaths) {
                    $Software = $null
                    try {

                        if (Join-Path -Path ('registry::{0}' -f $RegHive.Name) -ChildPath $RegistryPath.Path -Resolve -ErrorAction SilentlyContinue) {

                            $Software = $RegHive.OpenSubKey($RegistryPath.Path)
                            foreach ($SubKeyName in $Software.GetSubKeyNames()) {
                                $SubKey = $null
                                try {
                                    $SubKey = $Software.OpenSubKey($SubKeyName, [RegistryRights]::QueryValues)

                                    $DisplayName = $SubKey.GetValue('DisplayName')
                                    if ([string]::IsNullOrEmpty($DisplayName)) {
                                        continue
                                    }

                                    if ($Wildcards.Length -gt 0) {
                                        $WasMatchFound = $false
                                        foreach ($Wildcard in $Wildcards) {
                                            if ($Wildcard.IsMatch($DisplayName)) {
                                                $WasMatchFound = $true
                                                break
                                            }
                                        }
                                        if (-not $WasMatchFound) {
                                            continue
                                        }
                                    }

                                    $InstalledOn = $SubKey.GetValue('InstallDate')
                                    if (-not [string]::IsNullOrWhiteSpace($InstalledOn)) {
                                        try {
                                            $InstalledOn = [datetime]$InstalledOn
                                        }
                                        catch {
                                            $InstalledOn = [datetime]::ParseExact($InstalledOn, 'yyyyMMdd', $null)
                                        }
                                    }
                                    $PSPath = 'Registry::{0}\{1}\{2}' -f $RegHive.Name, $RegistryPath.Path, $SubKeyName
                                    [PSCustomObject]@{
                                        PSTypeName = 'Utility.InstalledSoftware'
                                        Name = $DisplayName
                                        Publisher = $SubKey.GetValue('Publisher')
                                        DisplayVersion = $SubKey.GetValue('DisplayVersion')
                                        Uninstall = $SubKey.GetValue('UninstallString')
                                        Guid = (.{try {[guid]$SubKeyName}catch {$SubKeyName}})
                                        InstallDate = $InstalledOn
                                        Is64Bit = $RegistryPath.Is64Bit
                                        RegKey = $PSPath | Convert-Path
                                        PSPath = $PSPath
                                    }
                                }
                                catch {
                                    Write-Error -Exception $_
                                }
                                finally {
                                    if ($null -ne $SubKey) {
                                        $SubKey.Dispose()
                                    }
                                }
                            }
                        }
                    }
                    finally {
                        if ($null -ne $Software) {
                            $Software.Dispose()
                        }
                        $DisplayName, $InstalledOn = $null
                    }
                }
            }
        }
        finally {
            if ($OwnsKeyHKLM -and $null -ne $HKLM) {
                $HKLM.Dispose()
            }
            if ($OwnsKeyHKCU -and $null -ne $HKCU) {
                $HKCU.Dispose()
            }
        }
    }
}
