function Create-DirandEnter {
  [CmdletBinding()]
  [alias('mdc')]
  param(
    [Parameter(Mandatory)]
    [String]$Name
  )
  $New = New-Item -Path $Name -ItemType Directory
  Set-Location -Path $New.FullName
}
