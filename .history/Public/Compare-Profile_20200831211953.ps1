function Compare-Profile {
  $wozprofile = '\\wozcore\ADMIN$\System32\WindowsPowerShell\v1.0\profile.ps1'
  $localprofile = 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'

  if (! (Test-Path -Path $wozprofile)){
    throw 'Unable to access - {0}' -f $wozprofile
  }

  if (! (Test-Path -Path $localprofile)){
    throw 'Unable to access - {0}' -f $localprofile
  }

  $wozcontent = Get-Content -Path $wozprofile
  $localcontent = Get-Content -Path $localprofile
  $compare = @{
    ReferenceObject = $wozcontent
    DifferenceObject = $localcontent
  }

  if (Compare-Object @compare){
    # Write-Host -ForegroundColor Red 'Profile is out of date, syncing with WozCore'
    Write-Verbose 'Profile is out of date, syncing with WozCore' -Verbose
    Set-Content -Path $localprofile -Value $wozcontent -Force
  }
}