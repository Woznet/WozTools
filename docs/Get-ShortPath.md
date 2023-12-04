---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-paths
schema: 2.0.0
---

# Get-ShortPath

## SYNOPSIS
Shortens a file path based on the width of the PowerShell host window.

## SYNTAX

```
Get-ShortPath [[-Path] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-ShortPath function takes a file path and shortens it if necessary, based on the current width of the PowerShell host window.
It ensures that the path is displayed in a more readable format, especially useful in environments with limited screen space.

## EXAMPLES

### EXAMPLE 1
```
Get-ShortPath -Path 'C:\Users\Username\Documents\PowerShell\Scripts\MyVeryLongScriptName.ps1'
Shortens the specified file path based on the current PowerShell window width.
```

### EXAMPLE 2
```
'C:\Users\Username\Documents\PowerShell\Scripts\MyVeryLongScriptName.ps1' | Get-ShortPath
Demonstrates how to use the function with pipeline input.
```

## PARAMETERS

### -Path
Specifies the file path to shorten.
If not provided, the function uses the current working directory.
The path must be a valid file system path.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $PWD.Path
Accept pipeline input: True (ByValue)
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
### You can pipe a string representing the file path to Get-ShortPath.
## OUTPUTS

### System.String
### Outputs the shortened file path.
## NOTES
The function is particularly useful for displaying paths in a concise manner in scenarios like custom PowerShell prompts or logging where screen real estate is limited.

## RELATED LINKS

[https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-paths](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-paths)

