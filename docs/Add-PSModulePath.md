---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Add-PSModulePath.md
schema: 2.0.0
---

# Add-PSModulePath

## SYNOPSIS
Add a folder to the PSModulePath variable

## SYNTAX

```
Add-PSModulePath [-Path] <String> [-PassThru] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add a folder to the PSModulePath variable for the current process

## EXAMPLES

### EXAMPLE 1
```
Add-PSModulePath -Path D:\test\module-dir
```

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{ Fill PassThru Description }}

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

### None
## OUTPUTS

### String if PassThru parameter is used
## NOTES

## RELATED LINKS
