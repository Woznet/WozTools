function Get-RelativePath {
    <#
    .SYNOPSIS
    Calculates the relative path from one directory to another.

    .DESCRIPTION
    This function returns the relative path from a base directory to a target path. It can be useful in scripts where path manipulation is required.

    .PARAMETER Path
    The target path for which the relative path is calculated.

    .PARAMETER RelativeTo
    The base path from which the relative path is calculated. Defaults to the current working directory.

    .EXAMPLE
    Get-RelativePath -Path "C:\Windows\System32" -RelativeTo "C:\Windows"
    # Returns: "..\System32"

    .EXAMPLE
    "C:\Windows\System32" | Get-RelativePath -RelativeTo "C:\Windows"
    # Returns: "..\System32"
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [ValidateScript({
                if (-not ($_ | Test-Path -IsValid)) {
                    throw 'The path provided is invalid.'
                }
                return $true
            })]
        [string]$Path,

        [Parameter(Position = 1)]
        [ValidateScript({
                if (-not ($_ | Test-Path -PathType Container -IsValid)) {
                    throw 'The path provided is not a valid directory path.'
                }
                return $true
            })]
        [string]$RelativeTo = $PWD.ProviderPath
    )
    process {
        try {
            [System.IO.Path]::GetRelativePath($RelativeTo, $Path)
        }
        catch {
            [System.Management.Automation.ErrorRecord]$e = $_
            [PSCustomObject]@{
                Type = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason = $e.CategoryInfo.Reason
                Target = $e.CategoryInfo.TargetName
                Script = $e.InvocationInfo.ScriptName
                Message = $e.InvocationInfo.PositionMessage
            } | Out-String | Write-Error
            throw $_
        }
    }
}
