function Invoke-UrlUtility {
  <#
      .SYNOPSIS
      Encodes or decodes a URL.

      .DESCRIPTION
      The Invoke-UrlUtility function performs encoding or decoding of URLs. It uses the System.Net.WebUtility class to perform the operations. By default, it decodes URLs, but it can also encode them based on the action parameter.

      .PARAMETER Url
      Specifies the URL(s) to be encoded or decoded. This parameter accepts an array of strings and supports pipeline input.

      .PARAMETER Action
      Specifies the action to be performed on the URL(s). The valid actions are 'Encode' and 'Decode'. The default action is 'Decode'.

      .EXAMPLE
      Invoke-UrlUtility -Url 'https://www.example.com?q=PowerShell%20Scripts'
      This example decodes the URL 'https://www.example.com?q=PowerShell%20Scripts'.

      .EXAMPLE
      Invoke-UrlUtility -Url 'https://www.example.com?q=PowerShell Scripts' -Action Encode
      This example encodes the URL 'https://www.example.com?q=PowerShell Scripts'.

      .EXAMPLE
      'https://www.example.com?q=PowerShell%20Scripts' | Invoke-UrlUtility
      This example demonstrates pipeline input, decoding the URL.

      .INPUTS
      String[]
      You can pipe a string array to Invoke-UrlUtility.

      .OUTPUTS
      String
      Invoke-UrlUtility returns the encoded or decoded URL(s).

      .NOTES
      This function can handle multiple URLs at once if provided as an array or via pipeline input. It uses the .NET System.Net.WebUtility class for encoding and decoding.

      .LINK
      https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility
  #>
  [CmdletBinding()]
  param(
    # Specifies the URL(s) to be encoded or decoded. This parameter accepts an array of strings and supports pipeline input.
    [Parameter(Mandatory, ValueFromPipeline)]
    [string[]]$Url,

    # Specifies the action to be performed on the URL(s). The valid actions are 'Encode' and 'Decode'. The default action is 'Decode'.
    [ValidateSet('Decode', 'Encode')]
    [string]$Action = 'Decode'
  )
  process {
    switch ($Action) {
      'Decode' {
        [System.Net.WebUtility]::UrlDecode($Url) | Write-Output
      }
      'Encode' {
        [System.Net.WebUtility]::UrlEncode($Url) | Write-Output
      }
    }
  }
}

