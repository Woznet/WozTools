---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Get-ElementName.md
schema: 2.0.0
---

# Get-ElementName

## SYNOPSIS
Get the name of an element.

## SYNTAX

```
Get-ElementName [-Expression] <ScriptBlock> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function returns the name of an element.

## EXAMPLES

### EXAMPLE 1
```
Get-ElementName { $PSVersionTable }
PSVersionTable
```

## PARAMETERS

### -Expression
The expression to get the name of.

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

## RELATED LINKS
