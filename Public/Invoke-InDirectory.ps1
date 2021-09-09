function Invoke-InDirectory {
  # https://gist.github.com/chriskuech/a32f86ad2609719598b073293d09ca03#file-tryfinally-2-ps1
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({
          if(-not (Test-Path -Path $_ -PathType Container)) {
            throw 'Folder does not exist'
          }
          return $true
    })]
    [String[]]$Path,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [scriptblock]$ScriptBlock
  )
  process {
    foreach($Loc in $Path) {
      try {
        Push-Location -Path $Loc
        & $ScriptBlock
      }
      finally {
        Pop-Location
      }
    }
  }
}
