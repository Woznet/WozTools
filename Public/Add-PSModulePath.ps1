function Add-PSModulePath {
  <#
      .SYNOPSIS
      Add a folder to the PSModulePath variable

      .DESCRIPTION
      Add a folder to the PSModulePath variable for the current process

      .PARAMETER Path

      .PARAMETER PassThru

      .INPUTS
      None

      .OUTPUTS
      String if PassThru parameter is used

      .EXAMPLE
      Add-PSModulePath -Path D:\test\module-dir

      .NOTES
        
  #>
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not (Test-Path -Path $_ -PathType Container)) {
            throw '{0} - Unable to access or locate Path' -f $_
          }
          return $true
    })]
    # Directory to add to PSModulePath
    [string]$Path,
    # Output PSModulePath after changes have been applied
    [switch]$PassThru
  )
  $env:PSModulePath = '{0};{1}' -f $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path).ProviderPath,$env:PSModulePath
  if ($PassThru) {
    return $env:PSModulePath.Split(';')
  }
}
