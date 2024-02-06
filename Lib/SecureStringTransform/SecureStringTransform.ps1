<#
.SYNOPSIS
Transforms input into a SecureString.

.DESCRIPTION
The SecureStringTransformAttribute class is a custom argument transformation attribute for PowerShell. It is designed to convert input data into a SecureString object. This attribute handles three types of input:
- If the input is already a SecureString, it is returned as-is.
- If the input is a string, it is converted to a SecureString.
- If the input is a PSCredential object, the SecureString representing the password is extracted and returned.
The attribute throws an exception if the input type is not supported.

.PARAMETER EngineIntrinsics
Provides access to the PowerShell engine's intrinsic methods and properties.

.PARAMETER InputData
The data to be transformed into a SecureString. This can be a plain text string, a SecureString, or a PSCredential object.

.EXAMPLE
Using the attribute in a function:

function Test-SecureInput {
    param(
        [SecureStringTransform()]
        [securestring]$SecureInput
    )
    $SecureInput
}
# Pass string to SecureString parameter
Test-SecureInput -SecureInput 'regular string'

# Pass pscredential to SecureString parameter
$cred = Get-Credential 'TestUser'
Test-SecureInput -SecureInput $cred

This example shows a function where the SecureStringTransformAttribute is applied to a parameter, allowing it to accept different types of input and convert them to a SecureString.

.INPUTS
System.String
System.Security.SecureString
System.Management.Automation.PSCredential

.OUTPUTS
System.Security.SecureString

.NOTES
Be cautious when using this attribute with plain text strings, as it involves converting unsecured data to a SecureString, which should be handled securely.

.LINK
https://powershell.one/powershell-internals/attributes/transformation
https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.argumenttransformationattribute

#>
# create a transform attribute that transforms plain text and pscredential to secure string
class SecureStringTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    [object] Transform([System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, [object] $InputData) {
        if ($InputData -is [securestring]) {
            # Input is already a SecureString, return as-is:
            return $InputData
        }
        elseif ($InputData -is [string]) {
            if ([string]::IsNullOrWhiteSpace($InputData)) {
                throw 'Input string is null or empty.'
            }
            # Convert string to SecureString:
            $SecureString = $InputData | ConvertTo-SecureString -AsPlainText -Force
            # Consider clearing the original string from memory here
            return $SecureString
        }
        elseif ($InputData -is [pscredential]) {
            # Return the SecureString Password from PSCredential:
            return $InputData.Password
        }
        else {
            # Throw an exception for unsupported input types:
            throw [System.InvalidOperationException]::new('Input type not supported. Please provide a string, SecureString, or PSCredential.')
        }
    }
}
