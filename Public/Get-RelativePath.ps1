function Get-RelativePath {
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not ($_|Test-Path -PathType Container -IsValid)) {
            throw 'invalid directory path'
          }
          return $true
    })]
    [string]$RelativeTo,
    [Parameter(ValueFromPipeline,Mandatory)]
    [ValidateScript({
          if (-not ($_|Test-Path -IsValid)) {
            throw 'invalid path'
          }
          return $true
    })]
    [string]$Path
  )
  process {
    [System.IO.Path]::GetRelativePath($RelativeTo,$Path)
  }
}


