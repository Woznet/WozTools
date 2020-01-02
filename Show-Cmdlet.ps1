function Show-Cmdlet {
  param(
    [parameter(Mandatory)]
    [string]$Command
  )
  $cmdinfo = Get-Command -Name $Command
  # resolve to command if this is an alias
  if ($cmdinfo.CommandType -eq 'Alias') {
    $cmdinfo = Get-Command -Name ($cmdinfo.definition)
  }
  if ($cmdinfo.DLL -eq $null) {
    throw 'No DLL for {0}' -f $command
  }

  if ($cmdinfo.ImplementingType -eq $null) {
    throw 'No ImplementingType for {0}' -f $command
  }

  $name = $cmdinfo.ImplementingType
  $dll = $cmdinfo.DLL
  $inspector = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'JetBrains\Installations\dotPeek192\dotPeek64.exe' -Resolve
  $cmdargs = '/select={0}!{1}' -f $dll,$name
  Start-Process -FilePath $inspector -ArgumentList $cmdargs
}