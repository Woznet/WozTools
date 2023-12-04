---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Join-Url

## SYNOPSIS
Joins a base URI with a child path segment.

## SYNTAX

```
Join-Url [-Base] <Uri> [-Child] <String> [-OutUri] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Join-Url function takes a base URI and a child path segment, and combines them into a single well-formed URI.
It handles the proper inclusion of slashes between the base and child segments.
By default, it outputs the combined URI as a string, but it can also return a URI object.

## EXAMPLES

### EXAMPLE 1
```
Join-Url -Base 'http://example.com' -Child 'path/segment'
```

Returns 'http://example.com/path/segment'.

### EXAMPLE 2
```
Join-Url -Base 'http://example.com' -Child '/path/segment' -OutUri
```

Returns a URI object for 'http://example.com/path/segment'.

## PARAMETERS

### -Base
The base URI to which the child path will be appended.
It must be a valid URI.

```yaml
Type: System.Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Child
The child path segment to append to the base URI.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutUri
If specified, the function returns the result as a \[uri\] object.
Otherwise, it returns a string.

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

### [uri], [string]
## OUTPUTS

### [uri] or [string]
## NOTES

## RELATED LINKS
