function Remove-Diacritics {
  <#
      .SYNOPSIS
      Decompose characters to their base character equivilents and remove diacritics.

      .EXAMPLE
      PS >Remove-Diacritics 'àáâãäåÀÁÂÃÄÅﬁ⁵ẛ'

      Decompose characters to their base character equivilents and remove diacritics.

      .EXAMPLE
      PS >Remove-Diacritics 'àáâãäåÀÁÂÃÄÅﬁ⁵ẛ' -CompatibilityDecomposition

      Decompose composite characters to their base character equivilents and remove diacritics.

      .INPUTS
      System.String

      .LINK
      https://github.com/jasoth/Utility.PS
  #>
  [CmdletBinding()]
  param(
    # String value to transform.
    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [AllowEmptyString()]
    [string[]] $InputStrings,
    # Use compatibility decomposition instead of canonical decomposition which further decomposes composite characters and many formatting distinctions are removed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch] $CompatibilityDecomposition
  )
  process {
    [System.Text.NormalizationForm] $NormalizationForm = [System.Text.NormalizationForm]::FormD
    if ($CompatibilityDecomposition) { $NormalizationForm = [System.Text.NormalizationForm]::FormKD }
    foreach ($InputString in $InputStrings) {
      $NormalizedString = $InputString.Normalize($NormalizationForm)
      $OutputString = [System.Text.StringBuilder]::new()

      foreach ($Char in $NormalizedString.ToCharArray()) {
        if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($Char) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
          $null =  $OutputString.Append($Char)
        }
      }

      Write-Output $OutputString.ToString()
    }
  }
}