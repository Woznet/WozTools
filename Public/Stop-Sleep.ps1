function Stop-Sleep {
  [CmdletBinding()]
  [Alias('Awake')]
  param()
  if (Get-Process -Name Caffeinated -ea SilentlyContinue){
    Write-Verbose -Message 'Closing current Caffeinated process' -Verbose:$VerbosePreference
    Get-Process -Name Caffeinated | Stop-Process
    Start-Sleep -Milliseconds 250
  }
  Write-Verbose -Message 'Starting Caffeinated' -Verbose:$VerbosePreference
  & V:\tools\Caffeinated.exe
}