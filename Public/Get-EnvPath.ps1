function Get-EnvPath {
  [CmdletBinding()]
  param(
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  $PathSort = ([System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget)).Split(';').TrimEnd('\') | Sort-Object
  Return $PathSort
}
