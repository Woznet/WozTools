function Remove-BadCharacters {
  <#
      .Synopsis
      Remove invalid filename characters

      .DESCRIPTION
      Replaces the invalid filename characters with an empty string.

      .PARAMETER String

      .EXAMPLE
      'How To: A guide to do shit?' | Remove-BadCharacters

      .EXAMPLE
      Remove-BadCharacters 'This on?'

      .INPUTS
      String

      .OUTPUTS
      String

      .NOTES
      Source: https://virot.eu/cleaning-downloaded-filenames-of-invalid-characters/
  #>
  [CmdletBinding(
      SupportsShouldProcess,
      PositionalBinding=$false
  )]
  [Alias('FixChars')]
  [OutputType([String])]
  Param(
    # String that will have invalid filename characters removed from
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        Position=0
    )]
    [ValidateNotNullOrEmpty()]
    [string]$String
  )
  Begin {
    $BadChars = [string]::join('',([System.IO.Path]::GetInvalidFileNameChars())) -replace '\\','\\'
  }
  Process {
    $String -replace "[$BadChars]"
  }
}
