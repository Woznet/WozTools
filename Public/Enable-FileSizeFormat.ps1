function Enable-FileSizeFormat {
  [CmdletBinding()]
  param()
  Update-FormatData -PrependPath ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'Lib\Formatting\MyCustomFileInfo.format.ps1xml'))
}
