---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Test-PendingReboot

## SYNOPSIS
Test the pending reboot status on a local and/or remote computer.
Updated to be compatible with powershell 7+, converted Invoke-WmiMethod to Invoke-CimMethod.

## SYNTAX

```
Test-PendingReboot [[-ComputerName] <String[]>] [-Credential <PSCredential>] [-Detailed]
 [-SkipConfigurationManagerClientCheck] [-SkipPendingFileRenameOperationsCheck]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
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

## EXAMPLES

### EXAMPLE 1
```
Test-PendingReboot
```

ComputerName IsRebootPending
------------ ---------------
WKS01                   True

This example returns the ComputerName and IsRebootPending properties.

### EXAMPLE 2
```
(Test-PendingReboot).IsRebootPending
True
```

This example will return a bool value based on the pending reboot test for the local computer.

### EXAMPLE 3
```
Test-PendingReboot -ComputerName DC01 -Detailed
```

ComputerName                     : dc01
ComponentBasedServicing          : True
PendingComputerRenameDomainJoin  : False
PendingFileRenameOperations      : False
PendingFileRenameOperationsValue :
SystemCenterConfigManager        : False
WindowsUpdateAutoUpdate          : True
IsRebootPending                  : True

This example will test the pending reboot status for dc01, providing detailed information

### EXAMPLE 4
```
Test-PendingReboot -ComputerName DC01 -SkipConfigurationManagerClientCheck -SkipPendingFileRenameOperationsCheck -Detailed
```

CommputerName                    : dc01
ComponentBasedServicing          : True
PendingComputerRenameDomainJoin  : False
PendingFileRenameOperations      : False
PendingFileRenameOperationsValue :
SystemCenterConfigManager        :
WindowsUpdateAutoUpdate          : True
IsRebootPending                  : True

## PARAMETERS

### -ComputerName
A single computer name or an array of computer names. 
The default is localhost ($env:COMPUTERNAME).

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases: CN, Computer

Required: False
Position: 1
Default value: $env:COMPUTERNAME
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Credential
Specifies a user account that has permission to perform this action.
The default is the current user.
Type a username, such as User01, Domain01\User01, or User@Contoso.com.
Or, enter a PSCredential object,
such as an object that is returned by the Get-Credential cmdlet.
When you type a user name, you are
prompted for a password.

```yaml
Type: System.Management.Automation.PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [pscredential]::Empty
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detailed
Indicates that this function returns a detailed result of pending reboot information, why the system is
pending a reboot, not just a true/false response.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipConfigurationManagerClientCheck
Indicates that this function will not test the Client SDK WMI class that is provided by the System
Center Configuration Manager Client. 
This parameter is useful when SCCM is not used/installed on
the targeted systems.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipPendingFileRenameOperationsCheck
Indicates that this function will not test the PendingFileRenameOperations MultiValue String property
of the Session Manager registry key. 
This parameter is useful for eliminating possible false positives.
Many Anti-Virus packages will use the PendingFileRenameOperations MultiString Value in order to remove
stale definitions and/or .dat files.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author:  Woz
Updated: 12-4-2023

Original Author:  Brian Wilhite
Email:   bcwilhite (at) live.com



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

## RELATED LINKS
