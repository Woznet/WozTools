function Get-GitHubApiData {
    param(
        [Parameter(Mandatory, Position = 0)]
        [String]$Uri,
        [string]$UserAgent,
        [string]$Token
    )
    begin {
        if (-not $UserAgent) {
            $PSUserAgent = [Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where{ $_.Name -eq 'UserAgent' }.GetValue($null, $null)
            if (-not [string]::IsNullOrWhiteSpace($PSUserAgent)) {$UserAgent = $PSUserAgent}
        }
    }
    process {
        try {
            $Headers = @{
                'accept' = 'application/vnd.github+json'
            }
            if ($UserAgent) {
                $Headers.Add('User-Agent', $UserAgent)
            }
            if ($Token) { $Headers.Add('Authorization', 'Token {0}' -f $Token) }
            else {
                Write-Warning -Message '"Token" is not set. Only 60 requests per hour when unauthenticated.'
            }

            $response = Invoke-RestMethod -Uri $Uri -Headers $Headers -Method Get -ErrorAction Stop -ErrorVariable RestError

            # Check if response contains any data
            if ($response.Count -gt 0) { return $response } else { return $null }
        }
        catch {
            if ($RestError.Exception.Response.StatusCode -eq 'Forbidden' -or $RestError.Exception.Response.StatusCode -eq 'TooManyRequests') {
                $Headers = $RestError.Exception.Response.Headers
                $RateLimitRemaining = [int]$Headers['x-ratelimit-remaining']
                $RetryAfter = $Headers['Retry-After']

                if ($RateLimitRemaining -eq 0 -and $Headers['x-ratelimit-reset']) {
                    $ResetTime = [datetime]::FromUnixTimeSeconds($Headers['x-ratelimit-reset']).ToLocalTime()
                    Write-Warning ('Rate limit exceeded. Retry after {0}.' -f $ResetTime)
                    Start-Sleep -Seconds ([datetime]::FromUnixTimeSeconds($Headers['x-ratelimit-reset']).ToLocalTime() - [datetime]::Now).TotalSeconds
                }
                elseif ($RetryAfter) {
                    Write-Warning ('Secondary rate limit exceeded. Retry after {0} seconds.' -f $RetryAfter)
                    Start-Sleep -Seconds $RetryAfter
                }
                else {
                    Write-Warning 'Rate limit exceeded. Waiting for 60 seconds before retrying.'
                    Start-Sleep -Seconds 60
                }

                # Optional: Implement retry logic here, possibly with exponential backoff
                return $null
            }
            else {
                [pscustomobject]@{
                    Type = $_.Exception.GetType().FullName
                    Exception = $_.Exception.Message
                    Reason = $_.CategoryInfo.Reason
                    Target = $_.CategoryInfo.TargetName
                    Script = $_.InvocationInfo.ScriptName
                    Message = $_.InvocationInfo.PositionMessage
                }
                Write-Error -Exception $_
            }
        }
    }
}
