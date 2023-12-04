---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://docs.microsoft.com/en-us/dotnet/api/system.net.dnshostentry
schema: 2.0.0
---

# Get-HostEntry

## SYNOPSIS
Retrieves DNS host entry information for given IP addresses or hostnames.

## SYNTAX

```
Get-HostEntry [[-Address] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-HostEntry function queries DNS to get the host entry information for a specified list of IP addresses or hostnames.
It accepts input directly or via the pipeline and outputs the corresponding System.Net.IPHostEntry objects.

## EXAMPLES

### EXAMPLE 1
```
Get-HostEntry -Address 'www.example.com'
Retrieves the host entry information for 'www.example.com'.
```

### EXAMPLE 2
```
'8.8.8.8', '8.8.4.4' | Get-HostEntry
Retrieves the host entry information for the IP addresses '8.8.8.8' and '8.8.4.4' using pipeline input.
```

## PARAMETERS

### -Address
Specifies the IP address or hostname for which to get the host entry information.
This parameter accepts an array of strings, each representing an IP address or hostname.
It can also accept input from the pipeline.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 127.0.0.1
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
### You can pipe a string array of IP addresses or hostnames to Get-HostEntry.
## OUTPUTS

### System.Net.IPHostEntry
### Returns an array of IPHostEntry objects that represent the DNS host entry information for each IP address or hostname provided.
## NOTES
Ensure that the input addresses or hostnames are valid.
The function validates if each input is a well-formed IP address or URI but does not verify their existence in DNS.

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/api/system.net.dnshostentry](https://docs.microsoft.com/en-us/dotnet/api/system.net.dnshostentry)

