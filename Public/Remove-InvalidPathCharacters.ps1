function Remove-InvalidPathCharacters {
    <#
    .Synopsis
    Remove invalid filename characters

    .DESCRIPTION
    Replaces the invalid filename characters with an empty string.

    .PARAMETER String
    String that will have invalid filename characters removed from.

    .EXAMPLE
    'How To: A guide to do stuff?' | Remove-InvalidPathCharacters

    .EXAMPLE
    Remove-InvalidPathCharacters 'This on?'

    .INPUTS
    String

    .OUTPUTS
    String

    .NOTES
    Source: https://virot.eu/cleaning-downloaded-filenames-of-invalid-characters/
#>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param(
        # String that will have invalid filename characters removed from
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )
    Begin {
        $BadChars = [string]::Join('', ([System.IO.Path]::GetInvalidFileNameChars())) -replace '\\', '\\'
        $BadChars2 = [string]::Join('', ([System.IO.Path]::GetInvalidPathChars())) -replace '\\', '\\'
    }
    Process {
        $String -replace "[$BadChars]" -replace "[$BadChars2]"
    }
}
