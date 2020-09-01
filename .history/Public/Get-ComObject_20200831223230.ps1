function Get-ComObject {
  param(
    [Parameter(Mandatory,ParameterSetName='FilterByName')]
    [string]$Filter,
    [Parameter(Mandatory,ParameterSetName='ListAllComObjects')]
    [switch]$ListAll
  )
  $ListofObjects = Get-ChildItem -Path 'HKLM:\Software\Classes' -ErrorAction SilentlyContinue |
  Where-Object {
    $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path -Path "$($_.PSPath)\CLSID")
  } | Select-Object -ExpandProperty PSChildName

  if ($Filter) {
    $ListofObjects | Where-Object {$_ -like $Filter}
  } else {
    $ListofObjects
  }
}