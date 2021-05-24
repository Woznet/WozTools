function Get-StringFromSecureString {
  <#
      .Synopsis
      Decrypt SecureString

      .DESCRIPTION
      Convert securestring to string with
      [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::GetStringFromSecureString

      .EXAMPLE
      $test = Get-Credential # Username - Tester, Password test1
      $test.Password | Get-StringFromSecureString

      .EXAMPLE
      Get-StringFromSecureString -SecureString $test.Password

      .INPUTS
      securestring

      .OUTPUTS
      string
  #>
  [CmdletBinding()]
  [Alias('Convert-SecureString')]
  [OutputType([String])]
  Param(
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
    )]
    [Alias('Password')]
    [ValidateNotNullOrEmpty()]
    [securestring]$SecureString
  )
  Process {
    [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::GetStringFromSecureString($SecureString)
  }
}
