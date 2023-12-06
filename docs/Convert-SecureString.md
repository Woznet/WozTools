---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Convert-SecureString.md
schema: 2.0.0
---

# Convert-SecureString

## SYNOPSIS
Converts a SecureString to a plain text string.

## SYNTAX

```
Convert-SecureString [-SecureString] <SecureString> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Convert-SecureString function decrypts a SecureString object and returns the corresponding plain text string.
It accepts a SecureString or types convertible to SecureString, thanks to the SecureStringTransform attribute.

## EXAMPLES

### EXAMPLE 1
```
$SecureString = ConvertTo-SecureString 'PlainTextPassword' -AsPlainText -Force
Convert-SecureString -SecureString $SecureString
# This example shows how to convert a plaintext password to a SecureString and then back to a plaintext string.
```

### EXAMPLE 2
```
$Credential = Get-Credential
$Credential | Convert-SecureString
# This example demonstrates converting the password from a PSCredential object into a plaintext string.
```

## PARAMETERS

### -SecureString
Specifies the SecureString to convert.
This parameter can accept a SecureString, a regular string (which will be converted to a SecureString), or a PSCredential object (from which the password will be extracted).
The parameter accepts input from the pipeline.

```yaml
Type: System.Security.SecureString
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

### System.Security.SecureString, System.String, System.Management.Automation.PSCredential
## OUTPUTS

### System.String
### Outputs the plain text representation of the SecureString.
## NOTES
This function uses .NET interop to convert the SecureString, and it ensures that memory is securely cleaned up after the conversion to avoid leaving sensitive data in memory.

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/api/system.security.securestring](https://docs.microsoft.com/en-us/dotnet/api/system.security.securestring)

