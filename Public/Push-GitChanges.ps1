function Push-GitChanges {
  Param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not (Join-Path -Path $_ -ChildPath '.git' -Resolve)) {
            throw 'RepoPath must contain .git directory'
          }
          return $true
    })]
    [string]$RepoPath,
    [string]$Msg = (Get-Date).ToShortDateString()
  )
  Process{
    Invoke-InDirectory -Path $RepoPath -ScriptBlock {
      git add --all .
      git commit --all --message "$Msg"
      git push --all
    }
  }
}
