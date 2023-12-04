---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/jasoth/Utility.PS
schema: 2.0.0
---

# Remove-Diacritics

## SYNOPSIS
Decompose characters to their base character equivilents and remove diacritics.

## SYNTAX

```
Remove-Diacritics [-InputStrings] <String[]> [-CompatibilityDecomposition] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Remove-Diacritics 'àáâãäåÀÁÂ ÄÅﬁ⁵ẛ'
```

Decompose characters to their base character equivilents and remove diacritics.

### EXAMPLE 2
```
Remove-Diacritics 'àáâãäåÀÁÂ ÄÅﬁ⁵ẛ' -CompatibilityDecomposition
```

Decompose composite characters to their base character equivilents and remove diacritics.

## PARAMETERS

### -InputStrings
String value to transform.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -CompatibilityDecomposition
Use compatibility decomposition instead of canonical decomposition which further decomposes composite characters and many formatting distinctions are removed.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
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

## NOTES

## RELATED LINKS

[https://github.com/jasoth/Utility.PS](https://github.com/jasoth/Utility.PS)

