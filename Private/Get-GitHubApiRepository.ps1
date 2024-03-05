function Get-GitHubApiRepository {
    param(
        [Parameter(Mandatory, Position = 0)]
        [String]$UserName,
        [Parameter(Position = 1)]
        [string]$Token
    )
    process {
        $Page = 1
        do {
            $ApiDataParams = @{}
            if ($Token) { $ApiDataParams.Add('Token', $Token) }
            $ApiDataParams.Add('Uri', ('https://api.github.com/users/{0}/repos?page={1}&per_page=100' -f $UserName, $Page))
            $Repo = Get-GitHubApiData @ApiDataParams
            if ($Repo) { $Repo } else { break }
            $Page++
        } while ($Repo.Count -gt 0)
    }
}
