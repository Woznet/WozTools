---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Invoke-ChocoUpgradeAll.md
schema: 2.0.0
---

# Invoke-ChocoUpgradeAll

## SYNOPSIS
Upgrades all outdated Chocolatey packages.

## SYNTAX

```
Invoke-ChocoUpgradeAll [-CheckOnly] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Invoke-ChocoUpgradeAll function checks for outdated Chocolatey packages and optionally upgrades them.
It requires Chocolatey to be installed and accessible in the system PATH.

## EXAMPLES

### EXAMPLE 1
```
Invoke-ChocoUpgradeAll
This example checks for outdated Chocolatey packages and upgrades them.
```

### EXAMPLE 2
```
Invoke-ChocoUpgradeAll -CheckOnly
This example only checks for outdated packages without upgrading them.
```

## PARAMETERS

### -CheckOnly
If specified, the function will only check for outdated packages without performing any upgrades.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

### None
### You cannot pipe input to this function.
## OUTPUTS

### Dependent on the Chocolatey command output.
### If -CheckOnly is specified, outputs the list of outdated packages. Otherwise, it outputs the results of the upgrade process.
## NOTES
This function requires Chocolatey to be installed on the system and throws an error if 'choco.exe' is not found.

## RELATED LINKS

[https://chocolatey.org/docs/commands-upgrade](https://chocolatey.org/docs/commands-upgrade)

