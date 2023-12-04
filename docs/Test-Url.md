---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Test-Url

## SYNOPSIS
Tests if a given URI string is well-formed.

## SYNTAX

```
Test-Url [-Uri] <String> [[-UriKind] <UriKind>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Test-Url function checks if the provided URI string is well-formed according to the specified URI kind (Absolute or Relative).

## EXAMPLES

### EXAMPLE 1
```
Test-Url -Uri 'http://www.example.com'
```

Returns True if the URL is well-formed, otherwise returns False.

### EXAMPLE 2
```
'www.example.com' | Test-Url
```

Tests the URI string received from the pipeline and returns True if it is well-formed, otherwise False.

## PARAMETERS

### -Uri
Specifies the URI string to be tested.
This parameter is mandatory and accepts input from the pipeline.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UriKind
Specifies the kind of the URI to be tested (Absolute or Relative).
The default is Absolute.

```yaml
Type: System.UriKind
Parameter Sets: (All)
Aliases:
Accepted values: RelativeOrAbsolute, Absolute, Relative

Required: False
Position: 2
Default value: Absolute
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

### Boolean
### Returns True if the URI is well-formed, otherwise returns False.
## NOTES
Use this function to validate URI strings in your scripts, especially when working with web requests or handling user input.

## RELATED LINKS
