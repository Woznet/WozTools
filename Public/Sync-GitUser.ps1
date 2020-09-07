function Sync-GitUser {
  [CmdletBinding()]
  [OutputType([IO.DirectoryInfo])]
  [Alias('GPull')]
  param(
    [switch]$List
  )
  dynamicparam {
    $ParamName = 'User'
    [String[]]$Values = Get-ChildItem -Path 'V:\git\users' -Directory | ForEach-Object Name
    $Bucket = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
    $AttributeList = [Collections.ObjectModel.Collection[System.Attribute]]::new()
    $AttribValidateSet = [ValidateSet]::new($Values)
    $AttributeList.Add($AttribValidateSet)
    $AttribParameter = [Parameter]::new()
    $AttribParameter.Mandatory = $true
    $AttributeList.Add($AttribParameter)
    $Parameter = [Management.Automation.RuntimeDefinedParameter]::new($ParamName, [String[]], $AttributeList)
    $Bucket.Add($ParamName, $Parameter)
    $Bucket
  }
  Begin{
    if (!(Get-Command -Name git.exe)) {
      throw 'Install git.exe'
    }
    $GitUser = $($PSBoundParameters[$ParamName])
  }
  Process{
    foreach ($User in $GitUser) {
      Write-Host -Object "`n"
      $UserPath = Join-Path -Path 'V:\git\users' -ChildPath $User
      $DirList = Get-ChildItem -Path $UserPath -Directory -Exclude '_gist'
      switch ($List){
        $true {
          $GitRepos = Get-GitHubRepository -OwnerName $User
          Write-Host -Object ('{0} - Local Repositories' -f $DirList.Count)
          Write-Host -Object ('{0} - GitHub Repositories' -f $GitRepos.Count)
          Write-Host -Object "`n"
        }
        $false {
          $DirList | ForEach-Object {
            Write-Verbose -Message ('Pulling Git Repo - {1}/{0}' -f $PSItem.Name,$User) -Verbose
            Invoke-InDirectory -Path $PSItem.FullName -ScriptBlock {
              git pull --all --recurse-submodules
            }
          }
        }
      }
    }
  }
}
