function Enable-FileSize {
  [CmdletBinding()]
  param()
  Update-FormatData -PrependPath ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'Show-LinkTarget.format.ps1xml'))
  Update-TypeData -PrependPath ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'MyTypes.types.ps1xml'))

}

