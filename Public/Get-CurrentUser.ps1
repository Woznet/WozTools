Function Get-CurrentUser {
  [CmdletBinding()]
  [Alias('CUser')]
  param()
  [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
}

