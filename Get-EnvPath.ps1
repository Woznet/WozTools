Function Get-EnvPath {
  param(
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  Return ([environment]::GetEnvironmentVariable('PATH',$VariableTarget)).Split(';')
}