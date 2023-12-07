function Get-GitHubApiGist {
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
            $ApiDataParams.Add('URI', ('https://api.github.com/users/{0}/gists?page={1}&per_page=100' -f $UserName, $Page))
            $Gist = Get-GitHubApiData @ApiDataParams
            if ($Gist) { $Gist } else { break }
            $Page++
        } while ($Gist.Count -gt 0)
    }
}
