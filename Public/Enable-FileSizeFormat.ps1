function Enable-FileSizeFormat {
  [CmdletBinding()]
  param()

Update-FormatData -AppendPath ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'Lib\Formatting\Show-LinkTarget.format.ps1xml'))
Update-TypeData -AppendPath ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'Lib\Formatting\MyTypes.types.ps1xml'))

}

