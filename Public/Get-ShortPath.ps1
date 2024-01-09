function Get-ShortPath {
    <#
.SYNOPSIS
Shortens a file path based on the width of the PowerShell host window.

.DESCRIPTION
The Get-ShortPath function takes a file path and shortens it if necessary, based on the current width of the PowerShell host window. It ensures that the path is displayed in a more readable format, especially useful in environments with limited screen space.

.PARAMETER Path
Specifies the file path to shorten. If not provided, the function uses the current working directory. The path must be a valid file system path.

.EXAMPLE
Get-ShortPath -Path 'C:\Users\Username\Documents\PowerShell\Scripts\MyVeryLongScriptName.ps1'
Shortens the specified file path based on the current PowerShell window width.

.EXAMPLE
'C:\Users\Username\Documents\PowerShell\Scripts\MyVeryLongScriptName.ps1' | Get-ShortPath
Demonstrates how to use the function with pipeline input.

.INPUTS
System.String
You can pipe a string representing the file path to Get-ShortPath.

.OUTPUTS
System.String
Outputs the shortened file path.

.NOTES
The function is particularly useful for displaying paths in a concise manner in scenarios like custom PowerShell prompts or logging where screen real estate is limited.

.LINK
https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-paths
#>
    param(
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
                if (-not ($_ | Test-Path -IsValid)) {
                    throw 'Path is not valid.'
                }
                return $true
            })]
        [string]$Path = $PWD.Path
    )
    process {
        if ($null -ne $Host.UI.RawUI.WindowSize.Width) {
            $MaxPromptPath = [int]($Host.UI.RawUI.WindowSize.Width / 3)
            $CurrPath = $Path -replace '^[^:]+::'
            $DSC = [System.IO.Path]::DirectorySeparatorChar

            if ($CurrPath.Length -ge $MaxPromptPath) {
                $PathParts = $CurrPath.Split($DSC)
                $EndPath = [System.Text.StringBuilder]::new()

                for ($i = $PathParts.Length - 1; $i -gt 0; $i--) {
                    $TempPart = $PathParts[$i]
                    $TempPath = [System.IO.Path]::Combine($EndPath.ToString(), $TempPart)
                    if ($TempPath.Length -lt $MaxPromptPath) {
                        [void]$EndPath.Insert(0, $TempPart + $DSC)
                    }
                    else {
                        break
                    }
                }
                $GSPath = '{0}{1}...{1}{2}' -f $PathParts[0], $DSC, $EndPath.ToString().TrimEnd($DSC)
            }
            else {
                $GSPath = $CurrPath
            }
            return $GSPath
        }
    }
}
