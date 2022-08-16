Function Test-Url {
  param (
    [Parameter(Mandatory,ValueFromPipeline)]
    [String]$Url
  )
  Process {
    if ([System.Uri]::IsWellFormedUriString($Url,[System.UriKind]::Absolute)) {
      $true
    }
    else {
      $false
    }
  }
}