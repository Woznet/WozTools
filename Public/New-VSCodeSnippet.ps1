function New-VSCodeSnippet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Prefix,

        [Parameter(Mandatory)]
        [string[]]$Body,

        [Parameter()]
        [string]$Description = [string]::Empty
    )

    # Helper function to escape problematic characters
    function Invoke-EscapeSnippetBody {
        param(
            [Parameter(ValueFromPipeline)]
            [string]$Line
        )
        process {
            # Replace problematic characters for JSON
            $Line.Replace('\', '\\').Replace('"', '\"').Replace('$', '\$')
        }
    }

    # Split the body into individual lines, then escape each line
    $BodyLines = $Body -join "`n" -split "`n" # Split multiline string into lines
    $EscapedBody = $BodyLines | Invoke-EscapeSnippetBody

    # Define the snippet as a PowerShell object
    $Snippet = @{
        $Name = [ordered]@{
            prefix = $Prefix
            description = $Description
            body = $EscapedBody
        }
    }

    # Convert the snippet object to JSON
    $SnippetJson = $Snippet | ConvertTo-Json -Depth 2
    # Output the JSON content to the console
    $SnippetJson
}
