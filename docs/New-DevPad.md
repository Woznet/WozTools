---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/environment-provider
schema: 2.0.0
---

# New-DevPad

## SYNOPSIS
Creates a new development folder (DevPad) and optionally sets an environment variable.

## SYNTAX

```
New-DevPad [[-Path] <String>] [-NoEnvVariable] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-DevPad function creates a folder for development purposes based on the current date and optionally sets a system environment variable 'DevPad' to this folder's path.
The folder is created under a specified path or defaults to 'D:\_dev\DPad'.

## EXAMPLES

### EXAMPLE 1
```
New-DevPad -Path 'C:\MyDevFolders'
Creates a new DevPad folder under 'C:\MyDevFolders' and sets the 'DevPad' environment variable to this folder's path.
```

### EXAMPLE 2
```
New-DevPad -NoEnvVariable
Creates a new DevPad folder in the default location ('D:\_dev\DPad') without setting the environment variable.
```

## PARAMETERS

### -Path
Specifies the base path where the DevPad folder will be created.
The default path is 'D:\_dev\DPad'.
The final folder includes the current year and date.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: D:\_dev\DPad
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoEnvVariable
Specifies whether to skip setting the 'DevPad' environment variable.
If this switch is not set, and the function is run with administrative privileges, it sets the 'DevPad' environment variable at the system level to the newly created folder's path.

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
### You cannot pipe objects to this function.
## OUTPUTS

### None
### This function does not produce any output.
## NOTES
To successfully set the 'DevPad' environment variable, this function must be run with administrative privileges.
The function checks for administrative rights before attempting to modify the system environment variables.

## RELATED LINKS

[https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/environment-provider](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/environment-provider)

