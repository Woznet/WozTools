function Test-Url {
    <#
.SYNOPSIS
Tests if a given URI string is well-formed.

.DESCRIPTION
The Test-Url function checks if the provided URI string is well-formed according to the specified URI kind (Absolute or Relative).

.PARAMETER Uri
Specifies the URI string to be tested. This parameter is mandatory and accepts input from the pipeline.

.PARAMETER UriKind
Specifies the kind of the URI to be tested (Absolute or Relative). The default is Absolute.

.EXAMPLE
Test-Url -Uri 'http://www.example.com'

Returns True if the URL is well-formed, otherwise returns False.

.EXAMPLE
'www.example.com' | Test-Url

Tests the URI string received from the pipeline and returns True if it is well-formed, otherwise False.

.OUTPUTS
Boolean
Returns True if the URI is well-formed, otherwise returns False.

.NOTES
Use this function to validate URI strings in your scripts, especially when working with web requests or handling user input.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [String]$Uri,

        [System.UriKind]$UriKind = [System.UriKind]::Absolute
    )
    Process {
        try {
            if ([uri]::IsWellFormedUriString($Uri, $UriKind)) {
                $true
            }
            else {
                $false
            }
        }
        catch {
            Write-Error ('An error occurred while testing the URI: {0}' -f $_)
            $false
        }
    }
}
