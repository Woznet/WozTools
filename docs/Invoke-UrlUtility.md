---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Invoke-UrlUtility.md
schema: 2.0.0
---

# Invoke-UrlUtility

## SYNOPSIS
Encodes or decodes a URL.

## SYNTAX

```
Invoke-UrlUtility [-Url] <String[]> [[-Action] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Invoke-UrlUtility function performs encoding or decoding of URLs.
It uses the System.Net.WebUtility class to perform the operations.
By default, it decodes URLs, but it can also encode them based on the action parameter.

## EXAMPLES

### EXAMPLE 1
```
Invoke-UrlUtility -Url 'https://www.example.com?q=PowerShell%20Scripts'
This example decodes the URL 'https://www.example.com?q=PowerShell%20Scripts'.
```

### EXAMPLE 2
```
Invoke-UrlUtility -Url 'https://www.example.com?q=PowerShell Scripts' -Action Encode
This example encodes the URL 'https://www.example.com?q=PowerShell Scripts'.
```

### EXAMPLE 3
```
'https://www.example.com?q=PowerShell%20Scripts' | Invoke-UrlUtility
This example demonstrates pipeline input, decoding the URL.
```

## PARAMETERS

### -Url
Specifies the URL(s) to be encoded or decoded.
This parameter accepts an array of strings and supports pipeline input.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Action
Specifies the action to be performed on the URL(s).
The valid actions are 'Encode' and 'Decode'.
The default action is 'Decode'.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Decode
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

### String[]
### You can pipe a string array to Invoke-UrlUtility.
## OUTPUTS

### String
### Invoke-UrlUtility returns the encoded or decoded URL(s).
## NOTES
This function can handle multiple URLs at once if provided as an array or via pipeline input.
It uses the .NET System.Net.WebUtility class for encoding and decoding.

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility](https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility)

