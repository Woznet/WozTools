function Get-GitHubApiGist {
  param(
    [Parameter(Mandatory, Position = 0)]
    [String]$UserName
  )
  process {
    $Page = 1
    do {
      $Gist = Get-GitHubApiData -URI ('https://api.github.com/users/{0}/gists?page={1}&per_page=100' -f $UserName, $Page)
      if ($Gist) { $Gist } else { break }
      $Page++
    } while ($Gist.Count -gt 0)
  }
}