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
    [Parameter()]
		[switch]$ReArm,
    [switch]$Restart,

    [int]$Port,
    [System.Management.Automation.Credential()]
    [pscredential]$Credential
  )
  $NewCimParams = @{}
  if ($Port) { $NewCimParams.Port = $Port }
  if ($Credential) { $NewCimParams.Credential = $Credential }
  $NewCimParams.ErrorAction = 'Stop'

  foreach ($Computer in $ComputerName) {

    try {
      $NewCimParams.ComputerName = $Computer
      $Cim = New-CimSession @NewCimParams
      $SLP = Get-CimInstance -ClassName 'SoftwareLicensingProduct' -CimSession $Cim -ErrorAction Stop | Where-Object { $_.Name -like 'Windows*' }
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
        Message   = $e.InvocationInfo.PositionMessage
      }
      throw $_
    }

    try {
      $GraceLeft = [DateTime]::Now.Add([TimeSpan]::FromMinutes($SLP.GracePeriodRemaining))
			$TimeSpan = [TimeSpan]::FromMinutes($SLP.GracePeriodRemaining)
    }
    catch {
      Write-Warning -Message 'Grace peroid has ended, evaluation has expired!'
    }
    $CurrentInfo = [pscustomobject] @{
      ComputerName   = $Computer
			LicenseStatus  = [WozDev.LicenseStatus]$SLP.LicenseStatus
      ReArmLeft      = $SLP.RemainingSkuReArmCount
      ExpirationDate = if ($TimeSpan) {
        '({0} Days) {1}' -f [int]$TimeSpan.TotalDays, [datetime]::Now.AddMinutes($TimeSpan.TotalMinutes).ToShortDateString()
      }
			else {
				'Expired'
			}
    }

		$CurrentInfo

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
            Message   = $e.InvocationInfo.PositionMessage
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
  }
}
