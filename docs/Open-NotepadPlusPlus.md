---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Open-NotepadPlusPlus

## SYNOPSIS
Open file in NotepadPlusPlus

## SYNTAX

```
Open-NotepadPlusPlus [[-Path] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Open-NotepadPlusPlus -Path .\Path\of\a\File.ps1
```

### EXAMPLE 2
```
### BAD EXAMPLE - funciton is stupid and will open all resolved paths
gci .\* | Open-NotepadPlusPlus
```

## PARAMETERS

### -Path
\[Parameter(ValueFromPipeline)\]

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### FileInfo, String
## OUTPUTS

### none
## NOTES
assumes notepad++.exe is within $env:PATH
Install with chocolatey if needed

## RELATED LINKS
