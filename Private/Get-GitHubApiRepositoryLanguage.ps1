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
        $ApiDataParams = @{}
        if ($Token) { $ApiDataParams.Add('Token', $Token) }
        $ApiDataParams.Add('URI', ( . {
                    switch ($PSCmdlet.ParameterSetName) {
                        'Def' { 'https://api.github.com/repos/{0}/{1}/languages' -f $UserName, $Repository }
                        'InputObject' { $languages_url }
                    }
                }))

        $RepoLang = Get-GitHubApiData @ApiDataParams

        if ($RepoLang) { $RepoLang } else { break }
    }
}
