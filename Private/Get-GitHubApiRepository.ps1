function Get-GitHubApiRepository {
  param(
    [Parameter(Mandatory, Position = 0)]
    [String]$UserName
  )
  process {
    $Page = 1
    do {
      $Repo = Get-GitHubApiData -URI ('https://api.github.com/users/{0}/repos?page={1}&per_page=100' -f $UserName, $Page)
      if ($Repo) { $Repo } else { break }
      $Page++
    } while ($Repo.Count -gt 0)
  }
}

