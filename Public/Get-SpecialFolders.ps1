function Get-SpecialFolders {
  [CmdletBinding()]
  param(
    [AllowNull()]
    [Environment+SpecialFolder]$Name
  )
  Process{
    $ErrorActionPreference = 'SilentlyContinue'
    if($Name) {
      [PSCustomObject]@{
        Name = $Name
        Path = [System.IO.DirectoryInfo]::new([Environment]::GetFolderPath($Name))
      }
    }
    else {
      [Enum]::GetNames([Environment+SpecialFolder]) | ForEach-Object {
        [PSCustomObject]@{
          Name = $_
          Path = [System.IO.DirectoryInfo]::new([Environment]::GetFolderPath($_))
        }
      }
    }
  }
}

