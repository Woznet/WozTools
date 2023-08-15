function Test-PendingReboot {
  <#
      .SYNOPSIS
      Test the pending reboot status on a local and/or remote computer.
      Updated to be compatible with powershell 7+, converted Invoke-WmiMethod to Invoke-CimMethod.


      .DESCRIPTION
      This function will query the registry on a local and/or remote computer and determine if the
      system is pending a reboot, from Microsoft/Windows updates, Configuration Manager Client SDK, Pending
      Computer Rename, Domain Join, Pending File Rename Operations and Component Based Servicing.

      ComponentBasedServicing = Component Based Servicing
      WindowsUpdate = Windows Update / Auto Update
      CCMClientSDK = SCCM 2012 Clients only (DetermineifRebootPending method) otherwise $null value
      PendingComputerRenameDomainJoin = Detects a pending computer rename and/or pending domain join
      PendingFileRenameOperations = PendingFileRenameOperations, when this property returns true,
      it can be a false positive
      PendingFileRenameOperationsValue = PendingFilerenameOperations registry value; used to filter if need be,
      Anti-Virus will leverage this key property for def/dat removal,
      giving a false positive

      .PARAMETER ComputerName
      A single computer name or an array of computer names.  The default is localhost ($env:COMPUTERNAME).

      .PARAMETER Credential
      Specifies a user account that has permission to perform this action. The default is the current user.
      Type a username, such as User01, Domain01\User01, or User@Contoso.com. Or, enter a PSCredential object,
      such as an object that is returned by the Get-Credential cmdlet. When you type a user name, you are
      prompted for a password.

      .PARAMETER Detailed
      Indicates that this function returns a detailed result of pending reboot information, why the system is
      pending a reboot, not just a true/false response.

      .PARAMETER SkipConfigurationManagerClientCheck
      Indicates that this function will not test the Client SDK WMI class that is provided by the System
      Center Configuration Manager Client.  This parameter is useful when SCCM is not used/installed on
      the targeted systems.

      .PARAMETER SkipPendingFileRenameOperationsCheck
      Indicates that this function will not test the PendingFileRenameOperations MultiValue String property
      of the Session Manager registry key.  This parameter is useful for eliminating possible false positives.
      Many Anti-Virus packages will use the PendingFileRenameOperations MultiString Value in order to remove
      stale definitions and/or .dat files.

      .EXAMPLE
      PS C:\> Test-PendingReboot

      ComputerName IsRebootPending
      ------------ ---------------
      WKS01                   True

      This example returns the ComputerName and IsRebootPending properties.

      .EXAMPLE
      PS C:\> (Test-PendingReboot).IsRebootPending
      True

      This example will return a bool value based on the pending reboot test for the local computer.

      .EXAMPLE
      PS C:\> Test-PendingReboot -ComputerName DC01 -Detailed

      ComputerName                     : dc01
      ComponentBasedServicing          : True
      PendingComputerRenameDomainJoin  : False
      PendingFileRenameOperations      : False
      PendingFileRenameOperationsValue :
      SystemCenterConfigManager        : False
      WindowsUpdateAutoUpdate          : True
      IsRebootPending                  : True

      This example will test the pending reboot status for dc01, providing detailed information

      .EXAMPLE
      PS C:\> Test-PendingReboot -ComputerName DC01 -SkipConfigurationManagerClientCheck -SkipPendingFileRenameOperationsCheck -Detailed

      CommputerName                    : dc01
      ComponentBasedServicing          : True
      PendingComputerRenameDomainJoin  : False
      PendingFileRenameOperations      : False
      PendingFileRenameOperationsValue :
      SystemCenterConfigManager        :
      WindowsUpdateAutoUpdate          : True
      IsRebootPending                  : True

      .LINK
      Background:
      https://blogs.technet.microsoft.com/heyscriptingguy/2013/06/10/determine-pending-reboot-statuspowershell-style-part-1/
      https://blogs.technet.microsoft.com/heyscriptingguy/2013/06/11/determine-pending-reboot-statuspowershell-style-part-2/

      Component-Based Servicing:
      http://technet.microsoft.com/en-us/library/cc756291(v=WS.10).aspx

      PendingFileRename/Auto Update:
      http://support.microsoft.com/kb/2723674
      http://technet.microsoft.com/en-us/library/cc960241.aspx
      http://blogs.msdn.com/b/hansr/archive/2006/02/17/patchreboot.aspx

      CCM_ClientSDK:
      http://msdn.microsoft.com/en-us/library/jj902723.aspx

      .NOTES
      Author:  Woz
      Updated: 8-14-2023

      Original Author:  Brian Wilhite
      Email:   bcwilhite (at) live.com
  #>
  [CmdletBinding()]
  param(
    [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('CN', 'Computer')]
    [String[]]
    $ComputerName = $env:COMPUTERNAME,

    [Parameter()]
    [System.Management.Automation.Credential()]
    [pscredential]
    $Credential = [pscredential]::Empty,

    [Parameter()]
    [Switch]
    $Detailed,

    [Parameter()]
    [Switch]
    $SkipConfigurationManagerClientCheck,

    [Parameter()]
    [Switch]
    $SkipPendingFileRenameOperationsCheck
  )
  process {
    foreach ($Computer in $ComputerName) {
      try {

        $InvokeCimMethodParameters = @{
          Namespace    = 'root/default'
          ClassName    = 'StdRegProv'
          Name         = 'EnumKey'
          ComputerName = $Computer
          ErrorAction  = 'Stop'
        }

        $HKLM = [UInt32] '0x80000002'

        if ($PSBoundParameters.ContainsKey('Credential')) {
          $InvokeCimMethodParameters.Credential = $Credential
        }

        ## Query the Component Based Servicing Reg Key
        $InvokeCimMethodParameters.Arguments = @{
          hDefKey = $HKLM
          sSubKeyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\'
        }

        $RegistryComponentBasedServicing = (Invoke-CimMethod @InvokeCimMethodParameters).sNames -contains 'RebootPending'

        ## Query WUAU from the registry
        $InvokeCimMethodParameters.Arguments = @{
          hDefKey = $HKLM
          sSubKeyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\'
        }
        $RegistryWindowsUpdateAutoUpdate = (Invoke-CimMethod @InvokeCimMethodParameters).sNames -contains 'RebootRequired'

        ## Query JoinDomain key from the registry - These keys are present if pending a reboot from a domain join operation
        $InvokeCimMethodParameters.Arguments = @{
          hDefKey = $HKLM
          sSubKeyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\'
        }
        $RegistryNetlogon = (Invoke-CimMethod @InvokeCimMethodParameters).sNames
        $PendingDomainJoin = ($RegistryNetlogon -contains 'JoinDomain') -or ($RegistryNetlogon -contains 'AvoidSpnSet')

        ## Query ComputerName and ActiveComputerName from the registry and setting the MethodName to GetMultiStringValue
        $InvokeCimMethodParameters.Name = 'GetMultiStringValue'
        $InvokeCimMethodParameters.Arguments = @{
          hDefKey = $HKLM
          sSubKeyName = 'SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\'
          sValueName = 'ComputerName'
        }
        $RegistryActiveComputerName = (Invoke-CimMethod @InvokeCimMethodParameters).sNames

        $InvokeCimMethodParameters.Arguments = @{
          hDefKey = $HKLM
          sSubKeyName = 'SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\'
          sValueName = 'ComputerName'
        }
        $RegistryComputerName = (Invoke-CimMethod @InvokeCimMethodParameters).sNames

        $PendingComputerRename = $RegistryActiveComputerName -ne $RegistryComputerName -or $PendingDomainJoin

        ## Query PendingFileRenameOperations from the registry
        if (-not $PSBoundParameters.ContainsKey('SkipPendingFileRenameOperationsCheck')) {
          $InvokeCimMethodParameters.Arguments = @{
            hDefKey = $HKLM
            sSubKeyName = 'SYSTEM\CurrentControlSet\Control\Session Manager\'
            sValueName = 'PendingFileRenameOperations'
          }
          $RegistryPendingFileRenameOperations = (Invoke-CimMethod @InvokeCimMethodParameters).sValue
          $RegistryPendingFileRenameOperationsBool = [bool]$RegistryPendingFileRenameOperations
        }

        ## Query ClientSDK for pending reboot status, unless SkipConfigurationManagerClientCheck is present
        if (-not $PSBoundParameters.ContainsKey('SkipConfigurationManagerClientCheck')) {
          $InvokeCimMethodParameters.NameSpace = 'ROOT\ccm\ClientSDK'
          $InvokeCimMethodParameters.ClassName = 'CCM_ClientUtilities'


          # DetermineifRebootPending
          $InvokeCimMethodParameters.Name = 'DetermineifRebootPending'
          $InvokeCimMethodParameters.Remove('Arguments')

          try {
            $SCCMClientSDK = Invoke-CimMethod @InvokeCimMethodParameters
            $SystemCenterConfigManager = $SCCMClientSDK.ReturnValue -eq 0 -and ($SCCMClientSDK.IsHardRebootPending -or $SCCMClientSDK.RebootPending)
          }
          catch {
            $SystemCenterConfigManager = $null
            Write-Verbose -Message ($script:LocalizedData.invokeWmiClientSDKError -f $Computer)
          }
        }

        $IsRebootPending = $RegistryComponentBasedServicing -or `
        $PendingComputerRename -or `
        $PendingDomainJoin -or `
        $RegistryPendingFileRenameOperationsBool -or `
        $SystemCenterConfigManager -or `
        $RegistryWindowsUpdateAutoUpdate


        $Results = [PSCustomObject]@{
          ComputerName                     = $Computer
          ComponentBasedServicing          = $RegistryComponentBasedServicing
          PendingComputerRenameDomainJoin  = $PendingComputerRename
          PendingFileRenameOperations      = $RegistryPendingFileRenameOperationsBool
          PendingFileRenameOperationsValue = $RegistryPendingFileRenameOperations
          SystemCenterConfigManager        = $SystemCenterConfigManager
          WindowsUpdateAutoUpdate          = $RegistryWindowsUpdateAutoUpdate
          IsRebootPending                  = $IsRebootPending
        }

        if ($PSBoundParameters.ContainsKey('Detailed')) {
          $Results
        }
        else {

          $Results | Select-Object -Property ComputerName,IsRebootPending
        }
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
        Write-Verbose -Message ('{0}: {1}' -f $Computer, $_)
      }
    }
  }
}
