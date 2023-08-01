function Invoke-ChocoUpgradeAll {
  [CmdletBinding()]
  param(
    [switch]$CheckOnly
  )
  try {
    Write-Verbose 'Checking for choco.exe'
    $null = Get-Command choco -ErrorAction Stop
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

  Write-Verbose 'Checking available upgrades using "choco upgrade all -whatif"'
  $CWhatIf = choco upgrade all -whatif
  $SkipNum = $CWhatIf.IndexOf('Can upgrade:')
  $SkipNum++
  $CupApps = $CWhatIf | Select-Object -Skip $SkipNum
  $CupApps = $CupApps.Trim(' - ')
  Write-Verbose 'Formatting output from "choco upgrade all -whatif"'
  $UpgradeApps = $CupApps.ForEach({
      $UpVer = $_.Split(' ')
      [pscustomobject]@{
        Name    = $UpVer[0]
        Version = $UpVer[1]
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
    return (choco upgrade $UpgradeApps.Name --limit-output --no-progress)
  }
}
