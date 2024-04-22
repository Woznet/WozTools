function Get-RedirectedUrl {
    <#
.SYNOPSIS
Checks URI redirection using HTTP HEAD requests.

.DESCRIPTION
'Get-RedirectedUrl' determines if URIs redirect to other locations by performing HTTP HEAD requests.
It can operate in synchronous mode, processing each URI sequentially, or in asynchronous mode,
handling multiple URIs in parallel for enhanced efficiency.

.PARAMETER Uri
Specifies an array of absolute URIs for HTTP HEAD requests. Mandatory and accepts pipeline input.

.PARAMETER NoAsync
Switches to synchronous operation, processing URIs sequentially.

.EXAMPLE
PS> Get-RedirectedUrl -Uri 'http://example.com', 'http://example.org'

.EXAMPLE
PS> 'http://example.com', 'http://example.org' | Get-RedirectedUrl -NoAsync

.INPUTS
System.String[]
You can pipe a string array of absolute URIs to Get-RedirectedUrl.

.OUTPUTS
System.String
Outputs the final redirected URL for each input URI.

.NOTES
This script requires the System.Net.Http assembly

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
        [string[]]$Uri,
        [switch]$NoAsync
    )
    begin {
        Add-Type -AssemblyName System.Net.Http -PassThru:$false -ErrorAction Stop
        $HttpClient = [System.Net.Http.HttpClient]::new()
        $Tasks = if (-not $NoAsync) {
            [System.Collections.Generic.List[System.Threading.Tasks.Task[System.Net.Http.HttpResponseMessage]]]::new()
        }
    }
    process {
        foreach ($Url in $Uri) {
            try {
                $HttpRequestMessage = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $Url)
                if ($NoAsync) {
                    # Synchronous execution
                    $Response = $HttpClient.SendAsync($HttpRequestMessage).GetAwaiter().GetResult()
                    $Response.RequestMessage.RequestUri.AbsoluteUri
                    $Response.Dispose()
                }
                else {
                    # Asynchronous execution
                    $Task = $HttpClient.SendAsync($HttpRequestMessage)
                    $Task.ContinueWith({param($t) $HttpRequestMessage.Dispose()})
                    $Tasks.Add($Task)
                }
            }
            catch {
                $e = [System.Management.Automation.ErrorRecord]$_
                $errorDetails = [pscustomobject]@{
                    Type = $e.Exception.GetType().FullName
                    Exception = $e.Exception.Message
                    Reason = $e.CategoryInfo.Reason
                    Target = $e.CategoryInfo.TargetName
                    Script = $e.InvocationInfo.ScriptName
                    Message = $e.InvocationInfo.PositionMessage
                }
                Write-Error $errorDetails
            }
            finally {
                if ($NoAsync) {
                    $HttpRequestMessage.Dispose()
                }
            }
        }
    }
    end {
        if (-not $NoAsync) {
            try {
                [System.Threading.Tasks.Task]::WaitAll($Tasks.ToArray())
                foreach ($Task in $Tasks) {
                    if ($Task.IsCompletedSuccessfully) {
                        $Response = $Task.Result
                        $Response.RequestMessage.RequestUri.AbsoluteUri
                        $Response.Dispose()
                    }
                    elseif ($Task.IsFaulted) {
                        $e = [System.Management.Automation.ErrorRecord]$Task.Exception
                        $errorDetails = [pscustomobject]@{
                            Type = $e.Exception.GetType().FullName
                            Exception = $e.Exception.Message
                            Reason = $e.CategoryInfo.Reason
                            Target = $e.CategoryInfo.TargetName
                            Script = $e.InvocationInfo.ScriptName
                            Message = $e.InvocationInfo.PositionMessage
                        }
                        Write-Error $errorDetails
                    }
                }
            }
            finally {
                $HttpClient.Dispose()
            }
        }
        else {
            $HttpClient.Dispose()
        }
    }
}