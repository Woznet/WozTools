function Add-PSModulePath {
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not(Test-Path -Path $_ -PathType Container)) {
            throw '{0} - Invalid Path' -f $_
          }
          return $true
    })]
    [string]$Path
  )
  $env:PSModulePath = ($env:PSModulePath.Split(';') + (Resolve-Path -Path $Path).Path).TrimEnd('\') -join ';'
}