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
        if (-not ($null -eq $Host.UI.RawUI.WindowSize.Width)) {
            $DirChar = [System.IO.Path]::DirectorySeparatorChar
            $WindowSizeFactor = 3  # Determines how much of the window width the path should fill
            $MaxPromptPath = [int]($Host.UI.RawUI.WindowSize.Width / $WindowSizeFactor)
            $CurrPath = $Path -replace '^[^:]+::'

            if ($CurrPath.Length -ge $MaxPromptPath) {
                $PathParts = $CurrPath.Split($DirChar)
                $MyPath = $PathParts[0], '...', $PathParts[$PathParts.Length - 1] -join $DirChar
                $Counter = $PathParts.Length - 2

                while (($MyPath.Replace('...', ('...', $PathParts[$Counter] -join $DirChar)).Length -lt $MaxPromptPath) -and ($Counter -ne 0)) {
                    $MyPath = $MyPath.Replace('...', ('...', $PathParts[$Counter] -join $DirChar))
                    $Counter--
                }
            }
            else {
                $MyPath = $CurrPath
            }

            return $MyPath
        }
    }
}
