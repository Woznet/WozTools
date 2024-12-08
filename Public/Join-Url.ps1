function Join-Url {
    <#
.SYNOPSIS
Combines a base URI with one or more child segments into a single valid URL.

.DESCRIPTION
The Join-Url function takes a base URI and one or more child segments and combines them into a complete URL.
It ensures proper handling of trailing and leading slashes to avoid malformed URLs.
The function can output the result as either a [string] or a [uri] object.

.PARAMETER Base
The base URI to which child segments will be appended. This must be a valid URI object.

.PARAMETER Child
One or more child segments to append to the base URI.
Each segment will be normalized to avoid duplicate slashes or missing slashes.

.PARAMETER OutUri
If specified, the function returns the combined URL as a [uri] object.
By default, the function returns the URL as a [string].

.EXAMPLE
Join-Url -Base 'https://example.com' -Child 'path', 'to', 'resource'
https://example.com/path/to/resource

.EXAMPLE
'https://example.com' | Join-Url -Child 'nested/path','funtimes'
https://example.com/nested/path/funtimes

#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [uri]$Base,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Child,

        [switch]$OutUri
    )
    process {
        try {
            # Convert base URI to string once for efficiency
            $BaseString = $Base.ToString().Trim()

            # Ensure the base URI ends with a single slash
            if ($BaseString -notmatch '/$') {
                $BaseString += '/'
            }

            # Normalize and join child strings
            $ChildString = $Child.ForEach({$_.Split('/').TrimStart('/')}) -join '/'

            # Create the combined URI
            $Uri = [uri]::new(([uri]$BaseString), $ChildString)

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
            $e | Write-Error
        }
    }
}
