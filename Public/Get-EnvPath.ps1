function Get-EnvPath {
  param(
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  Return ([System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget)).Split(';')
}
