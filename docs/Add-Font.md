---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Add-Font

## SYNOPSIS
Add fonts to system

## SYNTAX

```
Add-Font [-Path] <String[]> [-Remove] [<CommonParameters>]
```

## DESCRIPTION
Install a font from file path using CSharp code, compatitable fonts are available for use within the console font list.

## EXAMPLES

### EXAMPLE 1
```
Add-Font -Path C:\temp\mononoki-nerdfont.ttf
```

## PARAMETERS

### -Path
Path of Font File, can accept multiple font files
Supported File Types - .ttc, .ttf, .fnt, .otf, .fon

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
{{ Fill Remove Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Administartor privileges are required

## RELATED LINKS
