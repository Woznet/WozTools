---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Invoke-InDirectory.md
schema: 2.0.0
---

# Invoke-InDirectory

## SYNOPSIS
Executes a script block within the context of specified directories.

## SYNTAX

```
Invoke-InDirectory [-Path] <String[]> [-ScriptBlock] <ScriptBlock> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Invoke-InDirectory function is designed to execute a provided script block in one or more specified directories.
This functionality is particularly useful for commands that are dependent on the current directory context, such as file system operations, git commands, or running scripts that use relative paths.

## EXAMPLES

### EXAMPLE 1
```
Invoke-InDirectory -Path 'C:\Projects\Project1' -ScriptBlock { Get-ChildItem }
```

This example executes 'Get-ChildItem' in the 'C:\Projects\Project1' directory.

### EXAMPLE 2
```
Get-ChildItem -Path 'C:\Projects\' -Directory | Invoke-InDirectory -ScriptBlock { git status }
```

This example fetches all directories under 'C:\Projects\' and runs 'git status' in each of them.

### EXAMPLE 3
```
'C:\Projects\Project1', 'C:\Projects\Project2' | Invoke-InDirectory -ScriptBlock { git pull }
```

This example demonstrates using the function with pipeline input to execute 'git pull' in both 'C:\Projects\Project1' and 'C:\Projects\Project2'.

## PARAMETERS

### -Path
Specifies one or more directories in which the script block will be executed.
The function changes to each directory and executes the script block.
This parameter accepts pipeline input and can be specified by property name.
A validation script ensures that each path provided is an existing directory.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ScriptBlock
Defines the script block that will be executed in the context of each specified directory.
The script block should contain the commands that you want to run.
This parameter is mandatory and cannot be empty.

```yaml
Type: System.Management.Automation.ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### System.String, System.IO.DirectoryInfo
### You can pipe string paths or directory objects to Invoke-InDirectory.
## OUTPUTS

### Depends on the script block's output. The function outputs whatever the script block returns for each directory.
## NOTES
Remember to ensure that the script block commands are appropriate for the directory context and that they handle any relative path dependencies correctly.

## RELATED LINKS

[https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject)

