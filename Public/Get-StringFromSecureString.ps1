function Get-StringFromSecureString
{
  <#
      .Synopsis
      Decrypt SecureString
      .DESCRIPTION
      Get unecrypted string from a secure string
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
  [CmdletBinding(
      PositionalBinding=$true
  )]
  [Alias('Convert-SecureString')]
  [OutputType([String])]
  Param (
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
    )]
    [Alias('Password')]
    [ValidateNotNullOrEmpty()]
    [securestring]$SecureString
  )
  Process
  {
    [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::GetStringFromSecureString($SecureString)
  }
}