---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient
schema: 2.0.0
---

# Get-RedirectedUrlAsync

## SYNOPSIS
Asynchronously retrieves the final redirected URL(s) of the given URI(s).

## SYNTAX

```
Get-RedirectedUrlAsync [-Uri] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-RedirectedUrlAsync function performs asynchronous HTTP HEAD requests to the specified URI(s) and retrieves the final redirected URL(s).
It is designed to handle multiple URIs efficiently by making concurrent HTTP requests.

## EXAMPLES

### EXAMPLE 1
```
Get-RedirectedUrlAsync -Uri 'https://aka.ms/ad/list'
#Result: https://github.com/microsoft/aka#readme
This example retrieves the final redirected URL for 'https://aka.ms/ad/list'.
```

### EXAMPLE 2
```
'https://aka.ms/admin', 'https://aka.ms/ad/list' | Get-RedirectedUrlAsync
#Result: https://admin.microsoft.com/
#        https://github.com/microsoft/aka#readme
This example demonstrates using the function with pipeline input to retrieve redirected URLs for multiple URIs.
```

## PARAMETERS

### -Uri
Specifies the URI(s) for which to retrieve the final redirected URL.
The URI must be an absolute URI.
This parameter accepts multiple URIs and supports pipeline input.

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

### System.String[]
### You can pipe a string array of absolute URIs to Get-RedirectedUrlAsync.
## OUTPUTS

### System.String
### Outputs the final redirected URL for each input URI.
## NOTES
This function requires the System.Net.Http assembly and uses the HttpClient class for asynchronous web requests.
It is ideal for scenarios where performance is a concern and multiple URIs need to be processed.

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient)

