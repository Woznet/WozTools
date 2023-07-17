---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Get-PSWinUpdates

## SYNOPSIS
Get available Windows Updates

## SYNTAX

```
Get-PSWinUpdates [-Reboot] [<CommonParameters>]
```

## DESCRIPTION
Uses PSWindowsUpdate to install available Windows Updates via this fuction - Get-WindowsUpdate

## EXAMPLES

### EXAMPLE 1
```
Get-PSWinUpdates
```

### EXAMPLE 2
```
Get-PSWinUpdates -Reboot
```

## PARAMETERS

### -Reboot
Reboot Computer if needed to finish installed the Windows Updates

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Get-PSWinUpdates.
## OUTPUTS

### Table - Get-PSWinUpdates outputs the properties X,ComputerName,Result,KB,Size,Title from the Get-WindowsUpdate function
## NOTES

## RELATED LINKS

[Online version: https://github.com/Woznet/WozTools/blob/main/docs/Get-PSWinUpdates.md]()

[Get-PSWinUpdates]()

