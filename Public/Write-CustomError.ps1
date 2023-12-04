function Write-CustomError {
    <#
.SYNOPSIS
Formats and writes a custom error object based on a provided error record.

.DESCRIPTION
The Write-CustomError function takes an error record and creates a custom object that includes detailed information about the error. This custom object contains the type of the exception, the exception message, the reason for the error, the target of the error, and the location in the script where the error occurred.

.PARAMETER ErrorRecord
Specifies the error record to be formatted into a custom error object. This should be an instance of System.Management.Automation.ErrorRecord.

.EXAMPLE
try {
    Get-Item -Path .\non-existing-file.txt -ErrorAction Stop
}
catch {
    Write-CustomError -ErrorRecord $_
    # Further handling of the custom error
    throw $_
}

This example shows how to use Write-CustomError in a try-catch block to format and handle errors.

.INPUTS
System.Management.Automation.ErrorRecord

.OUTPUTS
PSCustomObject
Outputs a custom object with detailed error information.

.NOTES
This function is useful for standardizing error handling and logging in scripts and functions.

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord
#>
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )
    [PSCustomObject]@{
        Type = $ErrorRecord.Exception.GetType().FullName
        Exception = $ErrorRecord.Exception.Message
        Reason = $ErrorRecord.CategoryInfo.Reason
        Target = $ErrorRecord.CategoryInfo.TargetName
        Script = $ErrorRecord.InvocationInfo.ScriptName
        Message = $ErrorRecord.InvocationInfo.PositionMessage
    }
}
