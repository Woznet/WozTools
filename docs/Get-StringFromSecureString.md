---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Get-StringFromSecureString

## SYNOPSIS
Decrypt SecureString

## SYNTAX

```
Get-StringFromSecureString [-SecureString] <SecureString> [<CommonParameters>]
```

## DESCRIPTION
Convert securestring to string with
\[Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache\]::GetStringFromSecureString

## EXAMPLES

### EXAMPLE 1
```
$test = Get-Credential # Username - Tester, Password test1
$test.Password | Get-StringFromSecureString
```

### EXAMPLE 2
```
Get-StringFromSecureString -SecureString $test.Password
```

## PARAMETERS

### -SecureString
{{ Fill SecureString Description }}

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: Password

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### securestring
## OUTPUTS

### string
## NOTES

## RELATED LINKS
