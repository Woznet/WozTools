function New-DevPad {
    <#
.SYNOPSIS
Creates a new development folder (DevPad) and optionally sets an environment variable.

.DESCRIPTION
The New-DevPad function creates a folder for development purposes based on the current date and optionally sets a system environment variable 'DevPad' to this folder's path. The folder is created under a specified path or defaults to 'D:\_dev\DPad'.

.PARAMETER Path
Specifies the base path where the DevPad folder will be created. The default path is 'D:\_dev\DPad'. The final folder includes the current year and date.

.PARAMETER NoEnvVariable
Specifies whether to skip setting the 'DevPad' environment variable. If this switch is not set, and the function is run with administrative privileges, it sets the 'DevPad' environment variable at the system level to the newly created folder's path.

.EXAMPLE
New-DevPad -Path 'C:\MyDevFolders'
Creates a new DevPad folder under 'C:\MyDevFolders' and sets the 'DevPad' environment variable to this folder's path.

.EXAMPLE
New-DevPad -NoEnvVariable
Creates a new DevPad folder in the default location ('D:\_dev\DPad') without setting the environment variable.

.INPUTS
None
You cannot pipe objects to this function.

.OUTPUTS
None
This function does not produce any output.

.NOTES
To successfully set the 'DevPad' environment variable, this function must be run with administrative privileges. The function checks for administrative rights before attempting to modify the system environment variables.

.LINK
https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/environment-provider
#>
    [Cmdletbinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateScript({
                Test-Path -Path $_ -PathType Container
            })]
        [String]$Path = 'D:\_dev\DPad',

        [switch]$NoEnvVariable
    )
    process {
        $DevPad = [System.IO.Path]::Combine($Path, [datetime]::Now.Year, [datetime]::Now.ToString('MM.dd'))
        Write-Verbose -Message ('Creating DevPad folder if it does not exist and setting the current working location - {0}' -f $DevPad)
        New-Item -ItemType Directory -Force -Path $DevPad | Set-Location

        if (-not $NoEnvVariable) {
            try {
                if (Test-IfAdmin) {
                    $RegHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
                    $RegKey = $RegHive.OpenSubKey('System\CurrentControlSet\Control\Session Manager\Environment', $true)

                    if ($RegKey.GetValue('DevPad') -ne $DevPad) {
                        Write-Verbose -Message "Setting env:DevPad - $DevPad"
                        $RegKey.SetValue('DevPad', $DevPad, [Microsoft.Win32.RegistryValueKind]::String)
                        # Broadcast a message to update the environment variable for the system
                        # [Additional Windows API call might be required here]
                    }
                    else {
                        Write-Verbose -Message 'env:DevPad is already set'
                    }
                }
                else {
                    Write-Warning 'Administrative privileges are required to set the environment variable.'
                }
            }
            catch {
                Write-CustomError -ErrorRecord $_
                Write-Warning "Failed to set environment variable: $_"
            }
            finally {
                if ($null -ne $RegKey) {
                    $RegKey.Close()
                }
            }
        }
    }
}
