function Join-Url {
    <#
.SYNOPSIS
Joins a base URI with a child path segment.

.DESCRIPTION
The Join-Url function takes a base URI and a child path segment, and combines them into a single well-formed URI. It handles the proper inclusion of slashes between the base and child segments. By default, it outputs the combined URI as a string, but it can also return a URI object.

.PARAMETER Base
The base URI to which the child path will be appended. It must be a valid URI.

.PARAMETER Child
The child path segment to append to the base URI.

.PARAMETER OutUri
If specified, the function returns the result as a [uri] object. Otherwise, it returns a string.

.EXAMPLE
Join-Url -Base 'http://example.com' -Child 'path/segment'

Returns 'http://example.com/path/segment'.

.EXAMPLE
Join-Url -Base 'http://example.com' -Child '/path/segment' -OutUri

Returns a URI object for 'http://example.com/path/segment'.

.INPUTS
[uri], [string]

.OUTPUTS
[uri] or [string]
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [uri]$Base,

        [Parameter(Mandatory, Position = 1)]
        [string]$Child,

        [switch]$OutUri
    )

    process {
        try {
            # Convert base URI to string once for efficiency
            $BaseUriString = $Base.ToString()

            # Ensure the base URI ends with a slash
            if (-not $BaseUriString.EndsWith('/')) {
                $BaseUriString += '/'
            }

            # Create the combined URI
            $Uri = [uri]::new($BaseUriString, $Child.TrimStart('/'))

            # Return either URI object or string based on OutUri switch
            if ($OutUri) {
                return $Uri
            }
            else {
                return $Uri.ToString()
            }
        }
        catch {
            [System.Management.Automation.ErrorRecord]$e = $_
            [PSCustomObject]@{
                Type = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason = $e.CategoryInfo.Reason
                Target = $e.CategoryInfo.TargetName
                Script = $e.InvocationInfo.ScriptName
                Message = $e.InvocationInfo.PositionMessage
            }
            Write-Error "Error in joining URI: $_"
        }
    }
}
