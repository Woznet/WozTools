function Sync-Profile {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [ValidateScript({
          if( -Not ($_ | Test-Path -PathType Leaf) ){
            throw ('File does not exist - {0}' -f $_)
          }
          return $true
    })]
    [String]$LocalProfile = '\\localhost\ADMIN$\System32\WindowsPowerShell\v1.0\profile.ps1',
    [ValidateScript({
          if( -Not ($_ | Test-Path -PathType Leaf) ){
            throw ('File does not exist - {0}' -f $_)
          }
          return $true
    })]
    [String]$WozProfile = '\\wozcore\ADMIN$\System32\WindowsPowerShell\v1.0\profile.ps1'
  )
  if (-not ([System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)){
    throw 'Admin privileges required'
  }
  if (Compare-Object -ReferenceObject (Get-FileHash -Path $WozProfile) -DifferenceObject (Get-FileHash -Path $LocalProfile) -Property Hash){
    Copy-Item -Path $WozProfile -Destination $LocalProfile -Force -PassThru -Confirm:$ConfirmPreference
  }
}


