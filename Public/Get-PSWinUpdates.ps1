function Get-PSWinUpdates {
  <#
      .SYNOPSIS
      Get available Windows Updates

      .DESCRIPTION
      Uses PSWindowsUpdate to install available Windows Updates via this fuction - Get-WindowsUpdate

      .PARAMETER Reboot
      Reboot Computer if needed to finish installed the Windows Updates

      .INPUTS
      None. You cannot pipe objects to Get-PSWinUpdates.

      .OUTPUTS
      Table - Get-PSWinUpdates outputs the properties X,ComputerName,Result,KB,Size,Title from the Get-WindowsUpdate function

      .EXAMPLE
      PS> Get-PSWinUpdates

      .EXAMPLE
      PS> Get-PSWinUpdates -Reboot

      .LINK
      Online version: https://github.com/Woznet/WozTools/blob/main/docs/Get-PSWinUpdates.md

      .LINK
      Get-PSWinUpdates
  #>
  [CmdletBinding()]
  param(
    # Reboot Computer if needed to finish installed the Windows Updates
    [Parameter()]
    [switch]$Reboot,
    [switch]$AddServiceManager
  )

  try {
    Import-Module -Name PSWindowsUpdate -ErrorAction Stop
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
    Write-Warning -Message 'Unable to import PSWindowsUpdate, has this module been installed?'
    throw $_
  }
  if ($AddServiceManager) {
    $null = Add-WUServiceManager -ServiceID '7971f918-a847-4430-9279-4a52d1efe18d' -AddServiceFlag 7 -Confirm:$false
  }


  $WUParams = @{
    Criteria  = 'IsInstalled=0 and DeploymentAction=*'
    Install   = $true
    AcceptAll = $true
  }
  if ($Reboot) { $WUParams.Add('AutoReboot', $true) } else { $WUParams.Add('IgnoreReboot', $true) }
  Get-WindowsUpdate @WUParams | Format-Table -Property X,ComputerName,Result,KB,Size,Title
}
