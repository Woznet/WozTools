function Get-ComObject {
  param(
    [Parameter(Mandatory,ParameterSetName='FilterByName')]
    [string]$Filter,
    [Parameter(Mandatory,ParameterSetName='ListAllComObjects')]
    [switch]$ListAll
  )
  $ListofObjects1 = Get-ChildItem -Path 'HKLM:\Software\Classes' -ErrorAction SilentlyContinue |
  #$ListofObjects = Get-ChildItem -Path 'registry::HKEY_CLASSES_ROOT\' -ErrorAction SilentlyContinue |
  Where-Object {
    $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path -Path ('{0}\CLSID' -f $_.PSPath))
  } | Select-Object -ExpandProperty PSChildName
  if ($Filter) {
    $ListofObjects | Where-Object {$_ -like $Filter}
  }
  else {
    $ListofObjects
  }
}

$ListofObjects1.Count
$ListofObjects1[0]

$ListofObjects = Resolve-Path -Path 'registry::HKEY_CLASSES_ROOT\*\CLSID' | gci | Select-Object -ExpandProperty PSChildName
$ListofObjects[0]

$ListofObjects2 = Resolve-Path -Path 'registry::HKEY_CLASSES_ROOT\*\CLSID' | gci | Select-Object -ExpandProperty PSChildName

$ListofObjects2[0]

$ListofObjects3 = Resolve-Path -Path 'registry::HKEY_CLASSES_ROOT\*\CLSID' | gi
$ListofObjects3[0]


$ListofObjectsHKCR = Get-ChildItem -Path 'registry::HKEY_CLASSES_ROOT\' -ErrorAction SilentlyContinue |
Where-Object { $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path -Path ('{0}\CLSID' -f $_.PSPath)) } | Select-Object -ExpandProperty PSChildName

$ListofObjectsHKCR

$n0 = New-Object -ComObject 'VisualStudio.DTE'
$n0|gm
$n1 = New-Object -ComObject 'VisualStudio.Solution'


