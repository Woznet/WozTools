---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Invoke-Parser

## SYNOPSIS
Get the Commands and Variables used in a script (ps1,psm1,etc), code/scriptblock or, function definition.

## SYNTAX

### File
```
Invoke-Parser -Path <String> [<CommonParameters>]
```

### Code
```
Invoke-Parser -Code <String> [<CommonParameters>]
```

### FunctionName
```
Invoke-Parser -FunctionName <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-Parser -Path C:\temp\random-script.ps1
```

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Code
{{ Fill Code Description }}

```yaml
Type: String
Parameter Sets: Code
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionName
{{ Fill FunctionName Description }}

```yaml
Type: String
Parameter Sets: FunctionName
Aliases:

Required: True
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

## RELATED LINKS
