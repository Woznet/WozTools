---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Write-MyProgress

## SYNOPSIS
Displays a progress bar within a Windows PowerShell command window.

## SYNTAX

### Normal
```
Write-MyProgress -Object <Array> -StartTime <DateTime> -Count <Int32> [-Id <Int32>] [-ParentId <Int32>]
 [<CommonParameters>]
```

### Cleanup
```
Write-MyProgress [-Id <Int32>] [-ParentId <Int32>] [-Cleanup] [<CommonParameters>]
```

## DESCRIPTION
The Write-Progress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.

## EXAMPLES

### EXAMPLE 1
```
$GetProcess = Get-Process
```

$Count = 0
$StartTime = Get-Date
foreach($Process in $GetProcess) {
$Count++
Write-MyProgress -StartTime $StartTime -Object $GetProcess -Count $Count

Write-Host "-\> $($Process.ProcessName)"
Start-Sleep -Seconds 1
}

## PARAMETERS

### -Object
Object use in your foreach processing

```yaml
Type: Array
Parameter Sets: Normal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
StartTime of the foreach processing

```yaml
Type: DateTime
Parameter Sets: Normal
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Count
Foreach Count variable

```yaml
Type: Int32
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
Type: Int32
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
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cleanup
Cleanup Write-Progress display in console

```yaml
Type: SwitchParameter
Parameter Sets: Cleanup
Aliases:

Required: True
Position: Named
Default value: False
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
