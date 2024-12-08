function ConvertTo-TitleCase {
    <#
        .Synopsis
        Convert Text to TitleCase

        .Description
        Converts input text to title case based on the specified or current culture.

        .EXAMPLE
        ConvertTo-TitleCase -Text 'testing'

        .EXAMPLE
        Get-ChildItem -Path D:\temp | Select-Object -ExpandProperty Name | ConvertTo-TitleCase

        .PARAMETER Text
        The text to convert to title case.

        .PARAMETER Culture
        The culture info to use for title casing, defaults to current culture.

        .INPUTS
        System.String

        .OUTPUTS
        System.String
    #>
    [OutputType([String])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String[]]$Text,
        
        [Parameter()]
        [System.Globalization.CultureInfo]$Culture = [System.Globalization.CultureInfo]::CurrentCulture
    )
    Process {
        foreach ($Line in $Text) {
            try {
                if (-not [String]::IsNullOrWhiteSpace($Line)) {
                    $Culture.TextInfo.ToTitleCase($Line.ToLower($Culture))
                }
            }
            catch {
                Write-Error "Error processing line: $_"
            }
        }
    }
}
