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
      Date Coded   : 09/07/2023
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

  Write-Verbose 'Getting list of choco installed apps using "choco list"'
  $CList = choco.exe list
  $CurrentApps = $CList.ForEach({
      $csplit = $_.Split(' ')
      if (($csplit.Count -eq 2) -and ($csplit[1] -as [version])) {
        [pscustomobject]@{
          Name = $csplit[0]
          Version = $csplit[1]
        }
      }
  })

  Write-Verbose 'Checking available upgrades using output from "choco upgrade all -whatif"'
  $CWhatIf = choco.exe upgrade all -whatif
  $SkipNum = $CWhatIf.IndexOf('Can upgrade:')
  $SkipNum++
  $CupApps = $CWhatIf | Select-Object -Skip $SkipNum
  $CupApps = $CupApps.Trim(' - ')
  $UpgradeApps = $CupApps.ForEach({
      $UpVer = $_.Split(' ')
      [pscustomobject]@{
        Name       = $UpVer[0]
        Version    = ($CurrentApps | Where-Object {$_.Name -eq $UpVer[0]}).Version
        NewVersion = $UpVer[1]
      }
      $UpVer = $null
  })
  if ($CheckOnly) {
    Write-Host ('Chocolatey can upgrade {0} packages.' -f $UpgradeApps.Count)
    return $UpgradeApps
  }
  else {
    Write-Host ('Chocolatey can upgrade {0} packages.' -f $UpgradeApps.Count)
    $UpgradeApps
    Write-Verbose 'Installing choco upgrades using "choco upgrade $UpgradeApps.Name --limit-output --no-progress"'
    return (choco.exe upgrade $UpgradeApps.Name --limit-output --no-progress)
  }
}
