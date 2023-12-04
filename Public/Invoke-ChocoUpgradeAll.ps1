function Invoke-ChocoUpgradeAll {
  <#
.SYNOPSIS
Upgrades all outdated Chocolatey packages.

.DESCRIPTION
The Invoke-ChocoUpgradeAll function checks for outdated Chocolatey packages and optionally upgrades them. It requires Chocolatey to be installed and accessible in the system PATH.

.PARAMETER CheckOnly
If specified, the function will only check for outdated packages without performing any upgrades.

.EXAMPLE
Invoke-ChocoUpgradeAll
This example checks for outdated Chocolatey packages and upgrades them.

.EXAMPLE
Invoke-ChocoUpgradeAll -CheckOnly
This example only checks for outdated packages without upgrading them.

.INPUTS
None
You cannot pipe input to this function.

.OUTPUTS
Dependent on the Chocolatey command output.
If -CheckOnly is specified, outputs the list of outdated packages. Otherwise, it outputs the results of the upgrade process.

.NOTES
This function requires Chocolatey to be installed on the system and throws an error if 'choco.exe' is not found.

.LINK
https://chocolatey.org/docs/commands-upgrade
#>
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [Parameter()]
    [switch]$CheckOnly
  )

  try {
    Write-Verbose 'Checking for choco.exe'
    $null = Get-Command -Name choco -ErrorAction Stop
  }
  catch {
    Write-Warning 'Unable to locate choco.exe, is it installed?'
    throw $_
  }

  Write-Verbose 'Checking outdated choco apps using "choco outdated --limit-output"'
  $UpgradeApps = choco outdated --limit-output | ConvertFrom-Csv -Delimiter '|' -Header Name, Version, NewVersion, Pinned | Select-Object -Property Name, @{n = 'Version'; e = { $_.Version -as [version] } }, @{n = 'NewVersion'; e = { $_.NewVersion -as [version] } }

  if ($UpgradeApps.Count) {
    $message = "Chocolatey can upgrade $($UpgradeApps.Count) packages."
    Write-Output $message

    if ($CheckOnly) {
      return $UpgradeApps
    }
    else {
      if ($PSCmdlet.ShouldProcess($message, 'Perform upgrades')) {
        Write-Verbose "Installing choco upgrades using 'choco upgrade --no-progress --limit-output $($UpgradeApps.Name -join ' ')'"
        $CounterValue = 0
        $StartTime = [DateTime]::Now
        foreach ($UpApp in $UpgradeApps.Name) {
          $CounterValue++
          Write-MyProgress -StartTime $StartTime -Object $UpgradeApps.Name -CounterValue $CounterValue

          choco.exe upgrade --no-progress --limit-output $UpApp
        }
        Write-MyProgress -Completed
      }
    }
  }
  else {
    Write-Output 'All choco apps are up to date'
  }
}
