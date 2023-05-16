function Invoke-ReArmLicense {
  [CmdletBinding()]
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
    [switch]$ReArm,
    [switch]$Restart
  )
  foreach ($Computer in $ComputerName) {

    try {
      $Cim = New-CimSession -ComputerName $Computer -ErrorAction Stop
      $SLP = Get-CimInstance -ClassName 'SoftwareLicensingProduct' -CimSession $Cim -ErrorAction Stop | Where-Object {$_.Name -match 'Windows|Eval'}
      $SLS = Get-CimInstance -ClassName 'SoftwareLicensingService' -CimSession $Cim -ErrorAction Stop
    }
    catch {
      [System.Management.Automation.ErrorRecord]$e = $_
      [PSCustomObject]@{
        Type      = $e.Exception.GetType().FullName
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
      throw $_
    }

    try {
      $GraceLeft = [DateTime]::Now.Add([TimeSpan]::FromMinutes($SLP.GracePeriodRemaining))
    }
    catch {
      Write-Warning -Message 'Grace peroid has ended, evaluation has expired!'
    }
    [pscustomobject] @{
      ComputerName = $Computer
      ReArmLeft = $SLP.RemainingSkuReArmCount
      ExpirationDate = if ($GraceLeft) {
        '({0} Days) {1}' -f [TimeSpan]::FromMinutes($SLP.GracePeriodRemaining).Days,$GraceLeft.ToShortDateString()
      }
    }
    if ($ReArm) {
      if ($SLS.RemainingWindowsReArmCount -gt 0) {
        try {
          $SLS | Invoke-CimMethod -MethodName 'ReArmWindows' -ErrorAction Stop
        }
        catch {
          [System.Management.Automation.ErrorRecord]$e = $_
          [PSCustomObject]@{
            Type      = $e.Exception.GetType().FullName
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
          }
          throw $_
        }
        if ($Restart) {
          Restart-Computer -ComputerName $Computer -Force
        }
        else {
          Write-Output 'Restart required to complete the ReArm process.'
        }
      }
      else {
        throw 'Unable to extend the trial license, the ReArm Count has reached 0.'
      }
    }
    else {
      Write-Output ('{2}{2}{0}: Evaluation License expires: {1}{2}Use -ReArm to ReArm now' -f $Computer,$GraceLeft.ToShortDateString(),("`n"))
    }
  }
}
