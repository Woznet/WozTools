function Install-PSWinUpdate {
  <#
      .SYNOPSIS
      Installs pending Windows updates and optionally adds Microsoft product updates and handles system reboots.

      .DESCRIPTION
      Uses PSWindowsUpdate module to install available Windows updates. It can also enable updates for other Microsoft products and manage automatic system reboots if needed.

      .PARAMETER Reboot
      The computer will reboot automatically if required by the installed updates.

      .INPUTS
      None. You cannot pipe objects to Install-PSWinUpdate.

      .OUTPUTS
      Table - Install-PSWinUpdate outputs the properties X,ComputerName,Result,KB,Size,Title from the Get-WindowsUpdate function

      .EXAMPLE
      PS> Install-PSWinUpdate

      .EXAMPLE
      PS> Install-PSWinUpdate -Reboot
#>
  [CmdletBinding()]
  [Alias('Get-PSWinUpdate')]
  param(
    # Reboot Computer if needed to finish installed the Windows Updates
    [Parameter()]
    [switch]$Reboot,
    # Enable Microsoft Updates
    [switch]$AddServiceManager
  )
  try {
    Import-Module -Name PSWindowsUpdate -ErrorAction Stop -PassThru:$false
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
    Write-Host "Microsoft update services enabled."
  }

  $WUParams = @{
    Criteria  = 'IsInstalled=0 and DeploymentAction=*'
    Install   = $true
    AcceptAll = $true
  }
  if ($Reboot) { $WUParams.Add('AutoReboot', $true) } else { $WUParams.Add('IgnoreReboot', $true) }
  Get-WindowsUpdate @WUParams | Format-Table -AutoSize -Property X,ComputerName,Result,KB,Size,Title
}
