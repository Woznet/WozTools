function Invoke-ReArmLicense {
  [CmdletBinding(DefaultParameterSetName='Rearm')]
  [Alias('ReArm')]
  param(
    [Parameter()]
    [ValidateScript({
          if (-not (Test-Connection -Quiet -Count 1 -ComputerName $_)) {
            throw '{0} - Computer Unavailable' -f $_
          }
          return $true
    })]
    [string[]]$ComputerName = $env:COMPUTERNAME,
    [Parameter(ParameterSetName='Grace')]
    [switch]$GracePeriod,
    [switch]$Restart,
    [switch]$Force
  )
  foreach ($Computer in $ComputerName) {
    $Cim = New-CimSession -ComputerName $Computer
    $SLP = Get-CimInstance -ClassName 'SoftwareLicensingProduct' -CimSession $Cim
    try {
      $GraceLeft = [DateTime]::Now.Add([TimeSpan]::FromMinutes($SLP.GracePeriodRemaining))
    }
    catch {
	  Write-Warning -Message 'Grace peroid has ended, evaluation has expired! Using current date.'
      $GraceLeft = Get-Date
    }
    switch ($PSCmdlet.ParameterSetName) {
      'Grace' {
        [pscustomobject] @{
          ComputerName = $Computer
          Date = $GraceLeft.ToShortDateString()
          RemainingReArmCount = $SLP.RemainingSkuReArmCount
        }
        break
      }
      default {
        if (($GraceLeft.AddDays(-7) -le (Get-Date)) -or $Force) {
          $SLS = Get-CimInstance -ClassName 'SoftwareLicensingService' -CimSession $Cim
          if ($SLS.RemainingWindowsReArmCount -gt 0) {
            $SLS | Invoke-CimMethod -MethodName 'ReArmWindows'
            if ($Restart) { Restart-Computer -ComputerName $Computer -Force }
          }
          else {
            throw '{0} - Windows ReArm Count: 0' -f $Computer
          }
        }
        else {
          Write-Output ('{0}: Evaluation License expires: {1}{2}Use -Force to ReArm now' -f $Computer,$GraceLeft.ToShortDateString(),("`n"))
        }
        break
      }
    }
  }
}

