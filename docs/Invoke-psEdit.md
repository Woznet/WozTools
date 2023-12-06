---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Invoke-psEdit.md
schema: 2.0.0
---

# Invoke-psEdit

## SYNOPSIS
Opens files in the PowerShell Integrated Scripting Environment (ISE) editor.

## SYNTAX

```
Invoke-psEdit [-Path] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-psEdit function is designed to open specified files directly in the PowerShell ISE editor.
It is especially useful for quickly editing scripts or text files within the ISE environment.

## EXAMPLES

### EXAMPLE 1
```
Invoke-psEdit -Path 'C:\Scripts\MyScript.ps1'
This example opens the file 'MyScript.ps1' located at 'C:\Scripts\' in PowerShell ISE.
```

### EXAMPLE 2
```
'C:\Scripts\Script1.ps1', 'C:\Scripts\Script2.ps1' | Invoke-psEdit
This example demonstrates the use of pipeline input to open multiple files in PowerShell ISE.
```

## PARAMETERS

### -Path
Specifies the path(s) to the file(s) to be opened in PowerShell ISE.
The function accepts multiple file paths and can also accept input from the pipeline.

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

### System.String[]
### You can pipe a string array of file paths to Invoke-psEdit.
## OUTPUTS

### None
### This function does not produce any output. It opens files in the PowerShell ISE.
## NOTES
This function only works within the PowerShell Integrated Scripting Environment (ISE).
It will throw an error if executed in a different PowerShell host.

## RELATED LINKS

[https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/the-windows-powershell-ise?view=powershell-7.1](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/the-windows-powershell-ise?view=powershell-7.1)

