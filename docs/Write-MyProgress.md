---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Write-MyProgress.md
schema: 2.0.0
---

# Write-MyProgress

## SYNOPSIS
Displays a progress bar within a Windows PowerShell command window.

## SYNTAX

### Normal
```
Write-MyProgress -Object <Array> -StartTime <DateTime> -CounterValue <Int32> [-Id <Int32>] [-ParentId <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Completed
```
Write-MyProgress [-Id <Int32>] [-ParentId <Int32>] [-Completed] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Write-Progress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.

## EXAMPLES

### EXAMPLE 1
```
$GetProcess = Get-Process
```

$CounterValue = 0
$StartTime = Get-Date
foreach($Process in $GetProcess) {
$CounterValue++
Write-MyProgress -StartTime $StartTime -Object $GetProcess -CounterValue $CounterValue

Write-Host "-\> $($Process.ProcessName)"
Start-Sleep -Seconds 1
}
Write-MyProgress -Completed

## PARAMETERS

### -Object
Objects used in your foreach processing

```yaml
Type: System.Array
Parameter Sets: Normal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
StartTime of the process

```yaml
Type: System.DateTime
Parameter Sets: Normal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CounterValue
Current position within the loop

```yaml
Type: System.Int32
Parameter Sets: Normal
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies an ID that distinguishes each progress bar from the others.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentId
Specifies the parent activity of the current activity.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Completed
Cleanup any uncleared Progress bars

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Completed
Aliases:

Required: True
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
https://github.com/Netboot-France/Write-MyProgress

## RELATED LINKS
