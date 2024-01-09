function Invoke-UrlEncode {
    <#
    .SYNOPSIS
    Encodes a URL.

    .DESCRIPTION
    The Invoke-UrlEncode function performs encoding of URLs. It uses the System.Net.WebUtility class to perform the operations.

    .PARAMETER Url
    Specifies the URL(s) to be encoded. This parameter accepts an array of strings and supports pipeline input.

    .EXAMPLE
    Invoke-UrlEncode -Url 'https://www.example.com?q=PowerShell Scripts' -Action Encode
    This example encodes the URL 'https://www.example.com?q=PowerShell%20Scripts'.

    .EXAMPLE
    'https://www.example.com?q=PowerShell Scripts' | Invoke-UrlEncode
    This example demonstrates pipeline input, encoding the URL.

    .INPUTS
    String[]
    You can pipe a string array to Invoke-UrlEncode.

    .OUTPUTS
    String
    Invoke-UrlEncode returns the encoded URL(s).

    .NOTES
    This function can handle multiple URLs at once if provided as an array or via pipeline input. It uses the .NET System.Net.WebUtility class for encoding.

    .LINK
    https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility
#>
    [CmdletBinding()]
    param(
        # Specifies the URL(s) to be encoded. This parameter accepts an array of strings and supports pipeline input.
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Url
    )
    process {
        foreach ($U in $Url) {
            [System.Net.WebUtility]::UrlEncode($U) | Write-Output
        }
    }
}

