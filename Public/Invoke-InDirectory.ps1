function Invoke-InDirectory {
  # https://gist.github.com/chriskuech/a32f86ad2609719598b073293d09ca03#file-tryfinally-2-ps1
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [ValidateScript({
          Test-Path -Path $_ -PathType Container
    })]
    [string]$Path,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [scriptblock]$ScriptBlock
  )
  try {
    Push-Location -Path $Path
    & $ScriptBlock
  }
  finally {
    Pop-Location
  }
}