---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Invoke-InDirectory

## SYNOPSIS
Invoke a scriptblock from within one or more directories

## SYNTAX

```
Invoke-InDirectory [-Path] <String[]> [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
```

## DESCRIPTION
A longer description.

## EXAMPLES

### EXAMPLE 1
```
Invoke-InDirectory -Path 'X:\git\WozTools' -ScriptBlock { git fetch --all }
```

### EXAMPLE 2
```
Get-ChildItem -Path 'X:\git\' -Directory  | Invoke-InDirectory  -ScriptBlock { git fetch --all }
```

### EXAMPLE 3
```
'X:\git\WozTools','.\Git Stuff'  | Invoke-InDirectory  -ScriptBlock { git fetch --all }
```

## PARAMETERS

### -Path
Path of one or more directories which the scriptblock will be invoked in

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ScriptBlock
Specifies the commands to run

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.DirectoryInfo
### System.String
### You can pipe the output from Get-Item,
### DirectoryInfo object,
### A string that contains a path
## OUTPUTS

### This function will output whatever is returned from the scriptblock each time it is run.
## NOTES
Original Source:
https://gist.github.com/chriskuech/a32f86ad2609719598b073293d09ca03#file-tryfinally-2-ps1

## RELATED LINKS
