---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Add-EnvPath.md
schema: 2.0.0
---

# Add-EnvPath

## SYNOPSIS
Add a Folder to Environment Variable PATH

## SYNTAX

```
Add-EnvPath [-Path] <String[]> [[-VariableTarget] <EnvironmentVariableTarget>] [-PassThru]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Add Folders to Environment Variable PATH for Machine, User or Process scope
And removes missing PATH locations

## EXAMPLES

### EXAMPLE 1
```
Add-EnvPath -Path 'C:\temp' -VariableTarget Machine
```

## PARAMETERS

### -Path
Folder or Folders to add to PATH

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

### -VariableTarget
Which Env Path the directory gets added to.
Machine, User or Process

```yaml
Type: System.EnvironmentVariableTarget
Parameter Sets: (All)
Aliases:
Accepted values: Process, User, Machine

Required: False
Position: 2
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Display updated PATH variable

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

### [String] - Folder Path, accepts multiple folders
## OUTPUTS

### String - List of the New Path Variable
## NOTES

## RELATED LINKS
