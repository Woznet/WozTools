function Get-ShortPath {
    <#
.SYNOPSIS
Shortens a filesystem path based on the width of the PowerShell window.

.DESCRIPTION
This function takes a filesystem path and shortens it if necessary to fit within one-third of the PowerShell window's width, focusing on preserving the end of the path.

.PARAMETER Path
The filesystem path to shorten. If not provided, defaults to the current working directory.

.EXAMPLE
Get-ShortPath -Path 'C:\Users\ExampleUser\Documents\PowerShell\Scripts\VeryLongDirectoryName'

.EXAMPLE
'C:\Users\ExampleUser\Documents\PowerShell\Scripts\VeryLongDirectoryName' | Get-ShortPath
#>
    [CmdletBinding()]
    [Alias('GetShortPath')]
    param(
        [ValidateScript({
                if (-not ($_ | Test-Path -IsValid -PathType Container)) {
                    throw ('{0} - Invalid Directory Path' -f $_)
                }
                return $true
            })]
        [Parameter(ValueFromPipeline)]
        [string]$Path = $PWD.Path
    )
    process {
        if ($Host.UI.RawUI.BufferSize.Width) {
            $MaxPromptPath = [int]($Host.UI.RawUI.BufferSize.Width / 3)
        }
        else {
            $MaxPromptPath = 48
        }
        $CurrPath = $Path -replace '^[^:]+::'
        $DSC = [System.IO.Path]::DirectorySeparatorChar

        if ($CurrPath.Length -gt ($MaxPromptPath + 4)) {
            $PathParts = $CurrPath.Split($DSC)
            $EndPath = [System.Text.StringBuilder]::new()
            $ShortPath = [System.Text.StringBuilder]::new()

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
            $null = $ShortPath.Append($PathParts[0])
            $null = $ShortPath.Append($DSC)
            $null = $ShortPath.Append([char]::ConvertFromUtf32(8230))
            $null = $ShortPath.Append($DSC)
            $null = $ShortPath.Append($EndPath.ToString().TrimEnd($DSC))
            $GSPath = $ShortPath.ToString()
        }
        else {
            $GSPath = $CurrPath
        }
        return $GSPath
    }
}
