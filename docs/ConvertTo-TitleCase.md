---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# ConvertTo-TitleCase

## SYNOPSIS
Convert Text to TitleCase

## SYNTAX

```
ConvertTo-TitleCase [-Text] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-TitleCase -Text 'testing'
```

### EXAMPLE 2
```
Get-ChildItem -Path D:\temp | Select-Object -ExpandProperty Name | ConvertTo-TitleCase
```

## PARAMETERS

### -Text
{{ Fill Text Description }}

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### System.String
## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
