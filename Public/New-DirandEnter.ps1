function New-DirandEnter {
  [CmdletBinding()]
  [Alias('mdc')]
  param(
    [Parameter(Mandatory)]
    [String]$Path
  )
  New-Item -Path $Path -ItemType Directory | Set-Location
}
