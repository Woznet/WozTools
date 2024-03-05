function Get-GitHubApiRepositoryLanguage {
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Def')]
        [String]$UserName,
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'Def')]
        [string]$Repository,
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'InputObject', ValueFromPipelineByPropertyName)]
        [string]$languages_url,
        [Parameter(Position = 2, ParameterSetName = 'Def')]
        [Parameter(Position = 1, ParameterSetName = 'InputObject')]
        [string]$Token
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Def' { $Uri = 'https://api.github.com/repos/{0}/{1}/languages' -f $UserName, $Repository }
            'InputObject' { $Uri = $languages_url }
        }
        $ApiDataParams = @{}
        if ($Token) { $ApiDataParams.Add('Token', $Token) }
        $ApiDataParams.Add('Uri', $Uri)
        $RepoLang = Get-GitHubApiData @ApiDataParams
        if ($RepoLang) { $RepoLang } else { break }
    }
}
