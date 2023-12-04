---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord
schema: 2.0.0
---

# Write-CustomError

## SYNOPSIS
Formats and writes a custom error object based on a provided error record.

## SYNTAX

```
Write-CustomError [-ErrorRecord] <ErrorRecord> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Write-CustomError function takes an error record and creates a custom object that includes detailed information about the error.
This custom object contains the type of the exception, the exception message, the reason for the error, the target of the error, and the location in the script where the error occurred.

## EXAMPLES

### EXAMPLE 1
```
try {
    Get-Item -Path .\non-existing-file.txt -ErrorAction Stop
}
catch {
    Write-CustomError -ErrorRecord $_
    # Further handling of the custom error
    throw $_
}
```

This example shows how to use Write-CustomError in a try-catch block to format and handle errors.

## PARAMETERS

### -ErrorRecord
Specifies the error record to be formatted into a custom error object.
This should be an instance of System.Management.Automation.ErrorRecord.

```yaml
Type: System.Management.Automation.ErrorRecord
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

### System.Management.Automation.ErrorRecord
## OUTPUTS

### PSCustomObject
### Outputs a custom object with detailed error information.
## NOTES
This function is useful for standardizing error handling and logging in scripts and functions.

## RELATED LINKS

[https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord)

