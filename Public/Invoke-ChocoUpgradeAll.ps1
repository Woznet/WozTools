function Invoke-ChocoUpgradeAll {
  <#
      .SYNOPSIS
      Update chocolatey apps or just display the available updates new version and currently installed version.

      .DESCRIPTION
      Use choco to retreive a list of the packages installed using chocolatey and then show any upgrades available.

      .PARAMETER CheckOnly
      Don't upgrade any apps, just report which updates are available.

      .EXAMPLE
      Invoke-ChocoUpgradeAll

      .NOTES
      FunctionName : Invoke-ChocoUpgradeAll
      Created by   : Woz
      Date Coded   : 10/16/2023
  #>
  [CmdletBinding()]
  param(
    [switch]$CheckOnly
  )
  try {
    Write-Verbose 'Checking for choco.exe'
    $null = Get-Command -Name choco -ErrorAction Stop
  }
  catch {
    [System.Management.Automation.ErrorRecord]$e = $_
    [PSCustomObject]@{
      Type      = $e.Exception.GetType().FullName
      Exception = $e.Exception.Message
      Reason    = $e.CategoryInfo.Reason
      Target    = $e.CategoryInfo.TargetName
      Script    = $e.InvocationInfo.ScriptName
      Message   = $e.InvocationInfo.PositionMessage
    }
    Write-Warning 'unable to locate choco.exe, is it installed?'
    throw $_
  }

  Write-Verbose 'Checking outdated choco apps using "choco outdated --limit-output"'
  $UpgradeApps = choco outdated --limit-output | ConvertFrom-Csv -Delimiter '|' -Header Name,Version,NewVersion,Pinned | Select-Object -Property Name,@{n='Version';e={$_.Version -as [version]}},@{n='NewVersion';e={$_.NewVersion -as [version]}}
  if ($UpgradeApps.Count) {
    if ($CheckOnly) {
      Write-Host ('Chocolatey can upgrade {0} packages.' -f $UpgradeApps.Count)
      return $UpgradeApps
    }
    else {
      Write-Host ('Chocolatey can upgrade {0} packages.' -f $UpgradeApps.Count)
      $UpgradeApps
      Write-Verbose ('Installing choco upgrades using "choco upgrade --no-progress --limit-output {0}"' -f ($UpgradeApps.Name -join ' '))
      return (choco.exe upgrade --no-progress --limit-output $UpgradeApps.Name)
    }
  }
  else {
    Write-Host 'All choco apps are up to date'
  }
}
