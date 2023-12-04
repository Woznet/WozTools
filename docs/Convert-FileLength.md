---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Convert-FileLength

## SYNOPSIS
Converts a file length to a human readable format.

## SYNTAX

```
Convert-FileLength [-Length] <Int64> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Converts a file length to a human readable format.

## EXAMPLES

### EXAMPLE 1
```
Convert-FileLength -Length 123456789
```

Converts the file length 123456789 to a human readable format.

### EXAMPLE 2
```
Get-ChildItem | Select-Object -ExpandProperty Length | Convert-FileLength
```

Converts the file lengths of all files in the current directory to a human readable format.

## PARAMETERS

### -Length
The file length to convert.

```yaml
Type: System.Int64
Parameter Sets: (All)
Aliases: Size

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName, ByValue)
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
Author: Woz

## RELATED LINKS
