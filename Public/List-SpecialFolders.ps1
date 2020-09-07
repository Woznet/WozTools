function List-SpecialFolders{
  [CmdletBinding(DefaultParameterSetName='All')]
  param(
    [parameter(ParameterSetName = 'Single')]
    [Environment+SpecialFolder]$Name
  )
  Begin{
    $ErrorActionPreference = 'SilentlyContinue'
  }
  Process{
    $specloc = switch ($PSCmdlet.ParameterSetName) {
      'All' { [Enum]::GetNames([Environment+SpecialFolder]) | ForEach-Object {
          [PSCustomObject]@{
            Name = $_
            Path = [IO.DirectoryInfo]::new([Environment]::GetFolderPath($_))
          }
        } ; break
      }
      'Single' { [PSCustomObject]@{
          Name = $Name
          Path = [IO.DirectoryInfo]::new([Environment]::GetFolderPath($Name))
        } ; break
      }
    }
    return $specloc
  }
}
