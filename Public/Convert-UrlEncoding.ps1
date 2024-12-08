function Convert-UrlEncoding {
    <#
.SYNOPSIS
Encodes or decodes URLs based on the specified mode.

.DESCRIPTION
This function encodes or decodes one or more URLs. It supports pipeline input and can process multiple URLs in sequence.
Uses the UrlEncode and UrlDecode methods from the System.Net.WebUtility class

.PARAMETER Url
The URL(s) to encode or decode. This parameter accepts an array of strings.

.PARAMETER Mode
The mode of operation. Can be either 'Encode' or 'Decode'. Default is 'Decode'.

.EXAMPLE
Convert-UrlEncoding -Url "http://example.com/test?name=John Smith" -Mode 'Encode'
# Returns: http://example.com/test?name=John%20Smith

.EXAMPLE
"http://example.com/test?name=John%20Smith" | Convert-UrlEncoding -Mode 'Decode'
# Returns: http://example.com/test?name=John Smith

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.net.webutility
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Url,

        [Parameter()]
        [ValidateSet('Encode', 'Decode')]
        [string]$Mode = 'Decode'
    )
    process {
        foreach ($U in $Url) {
            switch ($Mode) {
                'Encode' { [System.Net.WebUtility]::UrlEncode($U) }
                'Decode' { [System.Net.WebUtility]::UrlDecode($U) }
            }
        }
    }
}
