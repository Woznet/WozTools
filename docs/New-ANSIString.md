---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# New-ANSIString

## SYNOPSIS
Generate ANSI escape code string for outputting text with color.

## SYNTAX

### Foreground (Default)
```
New-ANSIString [[-Red] <Int32>] [[-Green] <Int32>] [[-Blue] <Int32>] [-Foreground]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Background
```
New-ANSIString [[-Red] <Int32>] [[-Green] <Int32>] [[-Blue] <Int32>] [-Background]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Reset
```
New-ANSIString [-Reset] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Create ANSI color escape code using a RGB color value.
This function can generate strings to set text color (foreground), background color, or to reset text style to default.

## EXAMPLES

### EXAMPLE 1
```
$ANSI1 = New-ANSIString
$Reset = New-ANSIString -Reset
$Text = 'This is a test.  More testing... and testing'
'{0}{1}{2}' -f $ANSI1, $Text, $Reset
This example demonstrates setting a random text color for a string and then resetting it.
```

### EXAMPLE 2
```
$ANSIFG1 = New-ANSIString -Red 55 -Green 120 -Blue 190 -Foreground
$ANSIBG1 = New-ANSIString -Green 100 -Background
$Reset = New-ANSIString -Reset
$Text = 'This is a test.  More testing... and testing'
$Text2 = 'More and more and more!'
'{0}{1}{2}{3}{4}' -f $ANSIFG1, $Text, $ANSIBG1, $Text2, $Reset
This example sets both the foreground and background colors for different parts of a text.
```

### EXAMPLE 3
```
$RedText = New-ANSIString -Red 255 -Foreground
$Reset = New-ANSIString -Reset
$Text = 'This text is red'
'{0}{1}{2}' -f $RedText, $Text, $Reset
This example shows creating a red text string.
```

## PARAMETERS

### -Red
{{ Fill Red Description }}

```yaml
Type: System.Int32
Parameter Sets: Foreground, Background
Aliases:

Required: False
Position: 1
Default value: (Get-Random -Minimum 0 -Maximum 255)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Green
{{ Fill Green Description }}

```yaml
Type: System.Int32
Parameter Sets: Foreground, Background
Aliases:

Required: False
Position: 2
Default value: (Get-Random -Minimum 0 -Maximum 255)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Blue
{{ Fill Blue Description }}

```yaml
Type: System.Int32
Parameter Sets: Foreground, Background
Aliases:

Required: False
Position: 3
Default value: (Get-Random -Minimum 0 -Maximum 255)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Foreground
{{ Fill Foreground Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Foreground
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Background
{{ Fill Background Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Background
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reset
{{ Fill Reset Description }}

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: Reset
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

### [string]
### The function outputs a string containing the ANSI escape code.
## NOTES
Remember to reset the text style after every stylized text, otherwise the ANSI effects will continue to be applied to all that get output later.

## RELATED LINKS
