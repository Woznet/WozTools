---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# New-ANSIString

## SYNOPSIS
Generate ANSI escape code string for outputing text with color

## SYNTAX

### Foreground (Default)
```
New-ANSIString [[-Red] <Int32>] [[-Green] <Int32>] [[-Blue] <Int32>] [-Foreground] [<CommonParameters>]
```

### Background
```
New-ANSIString [[-Red] <Int32>] [[-Green] <Int32>] [[-Blue] <Int32>] [-Background] [<CommonParameters>]
```

### Reset
```
New-ANSIString [-Reset] [<CommonParameters>]
```

## DESCRIPTION
Create ANSI color escape code using a RGB color value

## EXAMPLES

### EXAMPLE 1
```
# Create variable with desired color
$ANSI1 = New-ANSIString
# Create variable to reset ANSI effects
$Reset = New-ANSIString -Reset
# String getting colored
$Text = 'This is a test.  More testing... and testing'
```

'{0}{1}{2}' -f $ANSI1,$Text,$Reset

### EXAMPLE 2
```
# Create variable with desired foreground color
$ANSIFG1 = New-ANSIString -Red 55 -Green 120 -Blue 190 -Foreground
# Create variable with desired background color
$ANSIBG1 = New-ANSIString -Green 100 -Background
# Create variable to reset ANSI effects
$Reset = New-ANSIString -Reset
# String getting colored
$Text = 'This is a test.  More testing... and testing'
$Text2 = 'More and more and more!'
```

'{0}{1}{2}{3}{4}' -f $ANSIFG1,$Text,$ANSIBG1,$Text2,$Reset

## PARAMETERS

### -Red
Param1 help description

```yaml
Type: Int32
Parameter Sets: Foreground, Background
Aliases:

Required: False
Position: 1
Default value: (Get-Random -Minimum 0 -Maximum 255)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Green
Param2 help description

```yaml
Type: Int32
Parameter Sets: Foreground, Background
Aliases:

Required: False
Position: 2
Default value: (Get-Random -Minimum 0 -Maximum 255)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Blue
Param3 help description

```yaml
Type: Int32
Parameter Sets: Foreground, Background
Aliases:

Required: False
Position: 3
Default value: (Get-Random -Minimum 0 -Maximum 255)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Foreground
Param4 help description

```yaml
Type: SwitchParameter
Parameter Sets: Foreground
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Background
Param5 help description

```yaml
Type: SwitchParameter
Parameter Sets: Background
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reset
Param6 help description

```yaml
Type: SwitchParameter
Parameter Sets: Reset
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

### [string]
## NOTES
FYI: Remeber to reset the text style after every stylized text, otherwise the ANSI effects will continue to be applied to all that get output later.

## RELATED LINKS
