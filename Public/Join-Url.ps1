function Join-Url {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [uri]$Base,
    [Parameter(Mandatory)]
    [string]$Child,
    [switch]$OutUri
  )
  process {
    if (-not ($Base.ToString().EndsWith('/'))) {
      [uri]$Base = '{0}/' -f $Base.ToString()
    }
    $Uri = [uri]::new($Base,$Child)
    if ($OutUri) {
      return $Uri
    }
    else {
      return $Uri.ToString()
    }
  }
}
