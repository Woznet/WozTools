function Get-GitHubApiData {
    param(
        [Parameter(Mandatory, Position = 0)]
        [String]$Uri,
        [string]$UserAgent,
        [string]$Token
    )
    process {
        try {
            if (-not ($UserAgent)) {
                $UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where({$_.Name -eq 'UserAgent'}).GetValue($null, $null)
            }
            $Headers = @{
                'User-Agent' = $UserAgent
            }
            if ($Token) { $Headers.Add('Authorization', 'Token {0}' -f $Token) }
            else {
                Write-Warning -Message '"Token" is not set.  Only 60 requests per hour when unauthenticated.'
            }
            $Data = Invoke-RestMethod -Uri $Uri -Headers $Headers -ErrorAction Stop
            if ($Data.Count -gt 0) { $Data } else { $null }
        }
        catch [System.Net.WebException] {
            [System.Management.Automation.ErrorRecord]$e = $_
            [PSCustomObject]@{
                Type = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason = $e.CategoryInfo.Reason
                Target = $e.CategoryInfo.TargetName
                Script = $e.InvocationInfo.ScriptName
                Message = $e.InvocationInfo.PositionMessage
            }
            Write-Error $_
        }
    }
}
