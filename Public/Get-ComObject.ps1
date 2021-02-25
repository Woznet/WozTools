function Get-ComObject {
  [CmdletBinding()]
  param(
    [string[]]$Filter
  )
  $ListofObjects = Get-ChildItem -Path 'registry::HKEY_CLASSES_ROOT\' -ErrorAction SilentlyContinue |
  Where-Object { $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path -Path ('{0}\CLSID' -f $_.PSPath)) } | Select-Object -ExpandProperty PSChildName
  if ($Filter) {
    $ListofObjects | Where-Object {$_ -match ($Filter -join '|')}
  }
  else {
    $ListofObjects
  }
}
