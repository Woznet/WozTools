function Get-GitHubApiRepositoryLanguage {
  param(
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Def')]
    [String]$UserName,
    [Parameter(Mandatory, Position = 1, ParameterSetName = 'Def')]
    [string]$Repository,
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'InputObject', ValueFromPipelineByPropertyName)]
    [string]$languages_url
  )
  process {
    if ($languages_url) {
      $RepoLang = Get-GitHubApiData -URI $languages_url
    }
    else {
      $RepoLang = Get-GitHubApiData -URI ('https://api.github.com/repos/{0}/{1}/languages' -f $UserName, $Repository)
    }
    if ($RepoLang) { $RepoLang } else { break }
  }
}
