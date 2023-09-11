function Get-RelativePath {
  param(
    [Parameter(Mandatory,ValueFromPipeline,Position = 0)]
    [ValidateScript({
          if (-not ($_|Test-Path -IsValid)) {
            throw 'invalid path'
          }
          return $true
    })]
    [string]$Path,
    [Parameter(Position = 1)]
    [ValidateScript({
          if (-not ($_|Test-Path -PathType Container -IsValid)) {
            throw 'invalid directory path'
          }
          return $true
    })]
    [string]$RelativeTo = $PWD.ProviderPath
  )
  process {
    [System.IO.Path]::GetRelativePath($RelativeTo,$Path)
  }
}


