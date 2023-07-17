function Test-Url {
  [CmdletBinding(PositionalBinding)]
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [String]$Uri,
    [System.UriKind]$UriKind = [System.UriKind]::Absolute
  )
  Process {
    if ([uri]::IsWellFormedUriString($Uri, $UriKind)) {
      $true
    }
    else {
      $false
    }
  }
}
