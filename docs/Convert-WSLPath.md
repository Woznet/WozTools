---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Convert-WSLPath

## SYNOPSIS
Covert a path in between the Windows and the WSL path formats

## SYNTAX

### WSL (Default)
```
Convert-WSLPath -Path <String[]> [-ToWSL] [<CommonParameters>]
```

### Win
```
Convert-WSLPath -Path <String[]> [-ToWindows] [<CommonParameters>]
```

## DESCRIPTION
Use "wslpath" to convert the path

## EXAMPLES

### EXAMPLE 1
```
# Convert Windows Path to WSL
Convert-WSLPath -Path 'C:\temp\'
```

### EXAMPLE 2
```
# Convert WSL Path to Windows
Convert-WSLPath -Path '/usr/bin/ssh' -ToWindows
```

## PARAMETERS

### -Path
Path to be converted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ToWindows
Convert Path from WSL format to Windows format

```yaml
Type: SwitchParameter
Parameter Sets: Win
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToWSL
Convert Path from Windows format to WSL format - Default

```yaml
Type: SwitchParameter
Parameter Sets: WSL
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

## RELATED LINKS
