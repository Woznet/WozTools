---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Invoke-Parser.md
schema: 2.0.0
---

# Invoke-Parser

## SYNOPSIS
Parses a PowerShell script, scriptblock, or function definition to extract used commands and variables.

## SYNTAX

### File
```
Invoke-Parser -Path <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Code
```
Invoke-Parser -Code <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FunctionName
```
Invoke-Parser -FunctionName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-Parser function analyzes PowerShell code from a file, a code snippet, or a function definition.
It extracts and lists all the commands and variables used in the input.
It supports three modes of input: File, Code, and FunctionName.

## EXAMPLES

### EXAMPLE 1
```
Invoke-Parser -Path 'C:\temp\random-script.ps1'
Parses the PowerShell script at the specified path and returns the commands and variables used in the script.
```

### EXAMPLE 2
```
Invoke-Parser -Code '$a = 1; Write-Output $a'
Parses the provided code snippet and returns the commands and variables used in it.
```

### EXAMPLE 3
```
Invoke-Parser -FunctionName 'Get-Process'
Parses the definition of the 'Get-Process' function and returns the commands and variables used in it.
```

## PARAMETERS

### -Path
Specifies the path to a PowerShell script file.
The function parses the file and extracts commands and variables used in it.

```yaml
Type: System.String
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Code
Specifies a string containing a block of PowerShell code.
The function parses the code to extract commands and variables.

```yaml
Type: System.String
Parameter Sets: Code
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FunctionName
Specifies the name of a PowerShell function.
The function parses the function definition to extract commands and variables.

```yaml
Type: System.String
Parameter Sets: FunctionName
Aliases:

Required: True
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

### String
## OUTPUTS

### PSCustomObject
## NOTES

## RELATED LINKS
