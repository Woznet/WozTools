function Add-PSModulePath {
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not (Test-Path -Path $_ -PathType Container)) {
            throw '{0} - Unable to access or locate Path' -f $_
          }
          return $true
    })]
    [string]$Path,
    [switch]$PassThru
  )
  # $env:PSModulePath = ($env:PSModulePath.Split(';') + (Resolve-Path -Path $Path).ProviderPath).TrimEnd('\') -join ';'
  $env:PSModulePath = ((Resolve-Path -Path $Path).ProviderPath , $env:PSModulePath.Split(';')).TrimEnd('\') -join ';'
  if ($PassThru) {
    return $env:PSModulePath.Split(';')
  }
}
