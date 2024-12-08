function Remove-PreInstalledPwshModules {
    <#
    .SYNOPSIS
    Removes specified modules from the PowerShell Core AllUsers module folder.

    .DESCRIPTION
    This function removes the following modules from the PowerShell Core (version 7+) AllUsers module folder:
    Microsoft.PowerShell.PSResourceGet, PackageManagement, PowerShellGet, PSReadLine.
    This is useful to avoid conflicts when the same modules are also installed in the PowerShell Desktop (version 5.1) AllUsers module folder.

    .PARAMETER None
    This function does not take any parameters.

    .EXAMPLE
    Remove-PwshModule
    Removes the specified modules from the PowerShell Core AllUsers module folder.

    .NOTES
    Author: Woz
    Date: 6-18-2024
#>
    [CmdletBinding(SupportsShouldProcess)]
    param()
    Process {
        try {
            $ModsRemove = @('Microsoft.PowerShell.PSResourceGet', 'PackageManagement', 'PowerShellGet', 'PSReadLine')
            $PwshMods = Get-Item -Path 'C:\Program Files\PowerShell\7\Modules\*' -Include $ModsRemove -ErrorAction Stop
            if ($PwshMods) {
                foreach ($Mod in $PwshMods) {
                    if ($PSCmdlet.ShouldProcess($Mod.FullName, 'Remove module')) {
                        Remove-Item -Path $Mod.FullName -Recurse -Force -ErrorAction Stop
                        Write-Host "Removed: $($Mod.Name)" -ForegroundColor Green
                    }
                }
            }
            else {
                Write-Host 'No specified modules found to remove.' -ForegroundColor Yellow
            }
        }
        catch {
            [System.Management.Automation.ErrorRecord]$e = $_
            [PSCustomObject]@{
                Type      = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason    = $e.CategoryInfo.Reason
                Target    = $e.CategoryInfo.TargetName
                Script    = $e.InvocationInfo.ScriptName
                Message   = $e.InvocationInfo.PositionMessage
            }
            throw $_
        }
    }
}
