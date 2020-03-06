
function Push-GitRepo {
  [cmdletbinding()]
  Param(
    [string]$RepoPath = $PWD
  )
  Begin {
    if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)){
      throw 'git.exe is not installed or part of env:path'
    }
    $start = $PWD
  }
  Process {
    Set-Location -Path $RepoPath
    git add -A
    git commit -m 'update'
    git push --all
    
    Write-Host -Object ('Finished updating {0}' -f $(Split-Path -Path $RepoPath -Leaf)) -ForegroundColor Green
  }
  End {
    Set-Location -Path $start
  }
}
