---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Get-EnvPath

## SYNOPSIS
Retrieves the directories listed in the PATH environment variable.

## SYNTAX

```
Get-EnvPath [[-VariableTarget] <EnvironmentVariableTarget>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-EnvPath function lists all directories specified in the PATH environment variable for a specified scope: either the current user or the machine.

## EXAMPLES

### EXAMPLE 1
```
Get-EnvPath
Lists all directories in the PATH environment variable for the machine.
```

### EXAMPLE 2
```
Get-EnvPath -VariableTarget User
Lists all directories in the PATH environment variable for the current user.
```

## PARAMETERS

### -VariableTarget
Specifies the scope of the environment variable.
Acceptable values are 'Machine' and 'User'.
The default is 'Machine'.

```yaml
Type: System.EnvironmentVariableTarget
Parameter Sets: (All)
Aliases:
Accepted values: Process, User, Machine

Required: False
Position: 1
Default value: Machine
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

### System.String[]
### Each line of output represents a directory in the PATH environment variable.
## NOTES

## RELATED LINKS
