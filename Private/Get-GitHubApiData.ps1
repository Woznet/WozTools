function Get-GitHubApiData {
  param(
    [Parameter(Mandatory, Position = 0)]
    [String]$URI,
    [string]$UserAgent = ([Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where{$_.Name -eq 'UserAgent'}.GetValue($null,$null)),
    [string]$Token
  )
  process {
    try {
      $Headers = @{
        'User-Agent' = $UserAgent
      }
      if ($Token) {$Headers.Add('Authorization','Token {0}' -f $Token)}
      # if ($Token) {$Headers.Add('Authorization','Bearer {0}' -f $Token)}
      else {
        Write-Warning -Message ('It is highly recommended "Token" is set.{0}Only 60 requests per hour when unauthenticated.' -f "`n")
      }
      $Data = Invoke-RestMethod -Uri $URI -Headers $Headers -ErrorAction Stop
      if ($Data.Count -gt 0) { $Data } else { $null }
    }
    catch [System.Net.WebException] {
      Write-Error $_
    }
  }
}

