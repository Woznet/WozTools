Function Test-Url {
[CmdletBinding()]
  param (
    [Parameter(Mandatory,ValueFromPipeline)]
    [String[]]$Url,
	[System.UriKind]$UriKind = [System.UriKind]::Absolute
  )
  Process {
  foreach($U in $Url) {
    if ([System.Uri]::IsWellFormedUriString($U, $UriKind)) {
      $true
    }
    else {
      $false
    }
  }
  }
}
