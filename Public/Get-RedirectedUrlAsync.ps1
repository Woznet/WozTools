function Get-RedirectedUrlAsync {
    <#
.SYNOPSIS
Asynchronously retrieves the final redirected URL(s) of the given URI(s).

.DESCRIPTION
The Get-RedirectedUrlAsync function performs asynchronous HTTP HEAD requests to the specified URI(s) and retrieves the final redirected URL(s). It is designed to handle multiple URIs efficiently by making concurrent HTTP requests.

.PARAMETER Uri
Specifies the URI(s) for which to retrieve the final redirected URL. The URI must be an absolute URI. This parameter accepts multiple URIs and supports pipeline input.

.EXAMPLE
Get-RedirectedUrlAsync -Uri 'https://aka.ms/ad/list'
#Result: https://github.com/microsoft/aka#readme
This example retrieves the final redirected URL for 'https://aka.ms/ad/list'.

.EXAMPLE
'https://aka.ms/admin', 'https://aka.ms/ad/list' | Get-RedirectedUrlAsync
#Result: https://admin.microsoft.com/
#        https://github.com/microsoft/aka#readme
This example demonstrates using the function with pipeline input to retrieve redirected URLs for multiple URIs.

.INPUTS
System.String[]
You can pipe a string array of absolute URIs to Get-RedirectedUrlAsync.

.OUTPUTS
System.String
Outputs the final redirected URL for each input URI.

.NOTES
This function requires the System.Net.Http assembly and uses the HttpClient class for asynchronous web requests. It is ideal for scenarios where performance is a concern and multiple URIs need to be processed.

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient
#>
    [CmdletBinding()]
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
        $Tasks = [System.Collections.Generic.List[System.Object]]::new()
    }
    process {
        foreach ($Url in $Uri) {
            $HttpRequestMessage = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $Url)
            $Task = $HttpClient.SendAsync($HttpRequestMessage)
            $Tasks.Add($Task)
        }
    }
    end {
        try {
            # Wait for all tasks to complete
            [System.Threading.Tasks.Task]::WaitAll($Tasks)
            # Process results
            foreach ($Task in $Tasks) {
                if ($Task.IsCompletedSuccessfully) {
                    $Response = $Task.Result
                    $Response.RequestMessage.RequestUri.AbsoluteUri
                }
                elseif ($Task.IsFaulted) {
                    Write-Warning ('Request failed: {0}' -f $Task.Exception)
                }
            }
        }
        finally {
            $HttpRequestMessage.Dispose()
            $HttpClient.Dispose()
        }
    }
}
