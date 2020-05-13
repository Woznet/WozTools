function Stop-Sleep {
  [CmdletBinding()]
  #[Alias('')]
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if(!(Test-Path -Path $_ -Include 'Caffeinated.exe')){
            throw 'Set Caffeinated.exe Path'
          } ; return $true
    })]
    [string]$Caffeinated = 'V:\tools\Caffeinated.exe'
    
  )
  if (Get-Process -Name Caffeinated -ea SilentlyContinue){
    Write-Verbose -Message 'Closing current Caffeinated process' -Verbose:$VerbosePreference
    Get-Process -Name Caffeinated | Stop-Process
    Start-Sleep -Milliseconds 350
    Get-Process -Name explorer | Stop-Process -Force -Confirm:$false
  }
  Write-Verbose -Message 'Starting Caffeinated' -Verbose:$VerbosePreference
  & $Caffeinated
}