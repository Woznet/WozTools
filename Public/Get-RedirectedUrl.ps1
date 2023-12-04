Function Get-RedirectedUrl {
    <#
.SYNOPSIS
Retrieves the final redirected URL(s) of the given URI(s).

.DESCRIPTION
The Get-RedirectedUrl function performs synchronous HTTP HEAD requests to the specified URI(s) and retrieves the final redirected URL(s). It can handle multiple URIs and is designed to be used in scenarios where you need to resolve the final destination of URL redirections.

.PARAMETER Uri
Specifies the URI(s) for which to retrieve the final redirected URL. The URI must be an absolute URI. This parameter accepts multiple URIs and supports pipeline input.

.EXAMPLE
Get-RedirectedUrl 'https://aka.ms/ad/list'
This example retrieves the final redirected URL for 'https://aka.ms/ad/list'.

.EXAMPLE
'https://aka.ms/admin', 'https://aka.ms/ad/list' | Get-RedirectedUrl
This example demonstrates using the function with pipeline input to retrieve redirected URLs for multiple URIs.

.INPUTS
System.String[]
You can pipe a string array of absolute URIs to Get-RedirectedUrl.

.OUTPUTS
System.String
Outputs the final redirected URL for each input URI.

.NOTES
This function uses the System.Net.Http.HttpClient class to perform web requests. Each URI is processed synchronously, and the function disposes of all resources properly upon completion.

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient
#>
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [ValidateScript({
                if (-not ([uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute))) {
                    throw ('Invalid URI: {0}. The URI must be an absolute URI.' -f $_)
                }
                return $true
            })]
        [string[]]$Uri
    )
    begin {
        Add-Type -AssemblyName System.Net.Http -PassThru:$false -ErrorAction Stop
        $HttpClient = [System.Net.Http.HttpClient]::new()
    }
    process {
        foreach ($Url in $Uri) {
            try {
                $HttpRequestMessage = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $Url)
                $Response = $HttpClient.SendAsync($HttpRequestMessage).GetAwaiter().GetResult()
                $Response.RequestMessage.RequestUri.AbsoluteUri
            }
            finally {
                $HttpRequestMessage.Dispose()
                $Response.Dispose()
            }
        }
    }
    end {
        $HttpClient.Dispose()
    }
}
