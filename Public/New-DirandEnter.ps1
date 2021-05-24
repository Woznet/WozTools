function New-DirandEnter {
  [CmdletBinding()]
  [Alias('mdc')]
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if(-not ($_ | Test-Path -PathType Container)) {
            throw 'Folder exists'
          }
          return $true
    })]
    [String]$Path
  )
  New-Item -Path $Path -ItemType Directory -Force | Set-Location
}

