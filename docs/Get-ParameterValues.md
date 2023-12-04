---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://gist.github.com/Jaykul/72f30dce2cca55e8cd73e97670db0b09/
schema: 2.0.0
---

# Get-ParameterValues

## SYNOPSIS
Get the actual values of parameters which have manually set (non-null) default values or values passed in the call

## SYNTAX

```
Get-ParameterValues [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Unlike $PSBoundParameters, the hashtable returned from Get-ParameterValues includes non-empty default parameter values.
NOTE: Default values that are the same as the implied values are ignored (e.g.: empty strings, zero numbers, nulls).

## EXAMPLES

### EXAMPLE 1
```
function Test-Parameters {
[CmdletBinding()]
param(
$Name = $Env:UserName,
$Age
)
$Parameters = Get-ParameterValues
# This WILL ALWAYS have a value...
Write-Host $Parameters["Name"]
# But this will NOT always have a value...
Write-Host $PSBoundParameters["Name"]
}
```

## PARAMETERS

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

## NOTES

## RELATED LINKS

[https://gist.github.com/Jaykul/72f30dce2cca55e8cd73e97670db0b09/](https://gist.github.com/Jaykul/72f30dce2cca55e8cd73e97670db0b09/)

[https://gist.github.com/elovelan/d697882b99d24f1b637c7e7a97f721f2/](https://gist.github.com/elovelan/d697882b99d24f1b637c7e7a97f721f2/)

