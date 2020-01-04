function List-SpecialFolders{
  [CmdletBinding(DefaultParameterSetName='All')]
  param(
    [parameter(Mandatory,ParameterSetName = 'Single')]
    [Environment+specialfolder]$Name
  )
  Begin{
    $ErrorActionPreference = 'SilentlyContinue'
  }
  Process{
    $specloc = switch ($PSCmdlet.ParameterSetName) {
      'All' { [enum]::GetNames([Environment+specialfolder]) | ForEach-Object {
          [pscustomobject]@{
            Name = $_
            Path = [IO.DirectoryInfo]::new([Environment]::GetFolderPath($_))
          }
      } ; break}
      'Single' { [pscustomobject]@{
          Name = $Name
          Path = [IO.DirectoryInfo]::new([Environment]::GetFolderPath($Name))
      } ; break}
    }
    return $specloc
  }
}