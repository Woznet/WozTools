﻿---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Add-Font.md
schema: 2.0.0
---

# Add-Font

## SYNOPSIS
Add fonts to system

## SYNTAX

```
Add-Font [-Path] <String[]> [-Remove] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
Type: System.String[]
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

## OUTPUTS

## NOTES
Administartor privileges are required

## RELATED LINKS
