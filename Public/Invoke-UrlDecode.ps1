function Invoke-UrlDecode {
    <#
        .SYNOPSIS
        Decodes a URL.

        .DESCRIPTION
        The Invoke-UrlDecode function performs decoding of URLs. It uses the System.Net.WebUtility class to perform the operations.

        .PARAMETER Url
        Specifies the URL(s) to be decoded. This parameter accepts an array of strings and supports pipeline input.

        .EXAMPLE
        Invoke-UrlDecode -Url 'https://www.example.com?q=PowerShell%20Scripts'
        URL Decoded 'https://www.example.com?q=PowerShell Scripts'

        .EXAMPLE
        'https://www.example.com?q=PowerShell%20Scripts' | Invoke-UrlDecode
        This example demonstrates pipeline input, decoding the URL.

        .INPUTS
        String[]
        You can pipe a string array to Invoke-UrlDecode.

        .OUTPUTS
        String
        Invoke-UrlDecode returns the decoded URL(s).

        .NOTES
        This function can handle multiple URLs at once if provided as an array or via pipeline input. It uses the .NET System.Net.WebUtility class for decoding.

        .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility
#>
    [CmdletBinding()]
    param(
        # Specifies the URL(s) to be decoded. This parameter accepts an array of strings and supports pipeline input.
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Url
    )
    process {
        foreach ($U in $Url) {
            [System.Net.WebUtility]::UrlDecode($U) | Write-Output
        }
    }
}

