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
    $Parameter = [Management.Automation.RuntimeDefinedParameter]::new($ParamName, [String], $AttributeList)
    $Bucket.Add($ParamName, $Parameter)
    $Bucket
  }
  Begin{
    if (!(Get-Command -Name git.exe)) {
      throw 'Install git.exe'
    }
    $StartDir = $PWD.Path
    $UserPath = Join-Path -Path 'V:\git\users' -ChildPath $($PSBoundParameters[$ParamName])
  }
  Process{
    $DirList = Get-ChildItem -Path $UserPath -Directory -Exclude '_gist'
    switch ($List){
      $true {
        Write-Host -Object ('{1}{0} - Repositories' -f $DirList.Count,"`n")
        return $DirList
      }
      $false {
        $DirList | ForEach-Object FullName | ForEach-Object {
          Write-Verbose -Message ('Pulling Git Repo - {0}' -f $_) -Verbose
          Set-Location -Path $_
          if (Test-Path -Path .\.git){
            git pull --all --recurse-submodules
          }
          else{
            $ermsg = ('{0} - missing .git folder' -f $_)
            Write-Error -Message $ermsg
          }
        }
        Set-Location -Path $StartDir
      }
    }
  }
}