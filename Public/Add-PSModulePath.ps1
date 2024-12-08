function Add-PSModulePath {
    <#
    .SYNOPSIS
    Add a folder to the PSModulePath variable

    .DESCRIPTION
    Add a folder to the PSModulePath variable for the current process

    .PARAMETER Path
    Directory to add to PSModulePath

    .PARAMETER PassThru
    Output PSModulePath after changes have been applied

    .EXAMPLE
    Add-PSModulePath -Path D:\test\module-dir
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({
                if (-not (Test-Path -Path $_ -PathType Container)) {
                    throw ('{0} - Unable to access or locate Path' -f $_)
                }
                return $true
            })]
        # Directory to add to PSModulePath
        [string]$Path,
        # Output PSModulePath after changes have been applied
        [switch]$PassThru
    )
    $JoinChar = [System.IO.Path]::PathSeparator
    $env:PSModulePath = '{0}{2}{1}' -f $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path).ProviderPath, $env:PSModulePath,$JoinChar
    if ($PassThru) {
        return $env:PSModulePath.Split($JoinChar)
    }
}
