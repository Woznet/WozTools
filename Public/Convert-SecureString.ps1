function Convert-SecureString {
    <#
.SYNOPSIS
Converts a SecureString to a plain text string.

.DESCRIPTION
The Convert-SecureString function decrypts a SecureString object and returns the corresponding plain text string. It accepts a SecureString or types convertible to SecureString, thanks to the SecureStringTransform attribute.

.PARAMETER SecureString
Specifies the SecureString to convert. This parameter can accept a SecureString, a regular string (which will be converted to a SecureString), or a PSCredential object (from which the password will be extracted). The parameter accepts input from the pipeline.

.EXAMPLE
$SecureString = ConvertTo-SecureString 'PlainTextPassword' -AsPlainText -Force
Convert-SecureString -SecureString $SecureString
# This example shows how to convert a plaintext password to a SecureString and then back to a plaintext string.

.EXAMPLE
$Credential = Get-Credential
$Credential | Convert-SecureString
# This example demonstrates converting the password from a PSCredential object into a plaintext string.

.INPUTS
System.Security.SecureString, System.String, System.Management.Automation.PSCredential

.OUTPUTS
System.String
Outputs the plain text representation of the SecureString.

.NOTES
This function uses .NET interop to convert the SecureString, and it ensures that memory is securely cleaned up after the conversion to avoid leaving sensitive data in memory.

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.security.securestring
#>

    [CmdletBinding()]
    [OutputType([String])]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [SecureStringTransform()]
        [SecureString]$SecureString
    )
    Process {
        try {
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
        }
        finally {
            if ($null -ne $BSTR) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
            }
        }
    }
}
