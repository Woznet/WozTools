function Get-FaviconOrLogo {
    <#
.SYNOPSIS
Retrieves favicon or logo URLs from a website and optionally downloads them.

.DESCRIPTION
This function fetches favicon or logo URLs from a given website by parsing its HTML content.
It uses AngleSharp for HTML parsing and HttpClient for downloading the website's HTML content and favicons.
The detected favicon or logo URLs are either returned or downloaded and saved to a specified directory.

.PARAMETER Url
The URL of the website to scan for favicons or logos. Must be a valid URI.

.PARAMETER DownloadIcons
If specified, downloads the identified favicon or logo files.

.PARAMETER SaveDir
The base directory where a subdirectory "{Host}_favicons" is created to save downloaded icons. Defaults to the $env:TEMP directory.

.EXAMPLE
Get-FaviconOrLogo -Url 'https://example.com'

Retrieves the favicon or logo URLs from 'https://example.com'.

.EXAMPLE
Get-FaviconOrLogo -Url 'https://example.com' -DownloadIcons -SaveDir 'C:\Icons'

Downloads favicons or logos from 'https://example.com' and saves them to 'C:\Icons\example.com_favicons'.

.OUTPUTS
- A list of favicon or logo URLs if "-DownloadIcons" is not specified.
- If "-DownloadIcons" is specified, outputs a list of with "IconUrl" and "IconPath", showing the URL and local file path of downloaded icons.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [uri]$Url,
        [switch]$DownloadIcons,
        [ValidateScript({
                if (-not (Test-Path -Path $_ -PathType Container)) {
                    throw ('Specified directory could not be found: {0}' -f $_)
                }
                return $true
            })]
        [string]$SaveDir = $env:TEMP
    )
    try {
        $null = Add-Type -Path (Join-Path $PSScriptRoot '..\Lib\AngleSharp\AngleSharp.dll' -Resolve) -ErrorAction Stop

        # Initialize the HTTP client from .NET to download HTML content
        $HttpClient = [System.Net.Http.HttpClient]::new()
        $Response = $HttpClient.GetStringAsync($Url).Result

        # Parse HTML using AngleSharp
        $HtmlParser = [AngleSharp.Html.Parser.HtmlParser]::new()
        $Document = $HtmlParser.ParseDocument($Response)

        # Initialize an array to hold favicon or logo URLs
        $Icons = [System.Collections.Generic.HashSet[string]]::new()
        $LinkTags = $Document.QuerySelectorAll('link')
        foreach ($Link in $LinkTags) {
            $RelAttribute = $Link.GetAttribute('rel')
            if ($RelAttribute -match 'icon|shortcut icon|apple-touch-icon|mask-icon') {
                $Href = $Link.GetAttribute('href')
                if ($Href) {
                    if ($Href -notmatch '^https?://') {
                        $Href = '{0}/{1}' -f $Url.OriginalString.TrimEnd('/'), $Href.TrimStart('/')
                    }
                    $null = $Icons.Add($Href)
                }
            }
        }

        if ($Icons.Count -gt 0) {
            if ($DownloadIcons) {
                $OutDir = [System.IO.Path]::Combine(($SaveDir | Convert-Path), ('{0}_favicons' -f $Url.Host))
                if (-not (Test-Path -Path $OutDir)) {
                    $null = New-Item -Path $OutDir -ItemType Directory -Force -ErrorAction Stop
                }
                $SavedIcons = [System.Collections.Generic.List[pscustomobject]]::new()
                foreach ($Icon in $Icons) {
                    try {
                        $SavePath = [System.IO.Path]::Combine($OutDir, [System.IO.Path]::GetFileName($Icon))
                        Write-Verbose ('Downloading: {0}' -f $Icon)
                        $Response = $HttpClient.GetByteArrayAsync($Icon).GetAwaiter().GetResult()
                        [System.IO.File]::WriteAllBytes($SavePath, $Response)
                        Write-Verbose "Saved: $SavePath"
                        $SavedObj = [pscustomobject]@{
                            IconUrl = $Icon
                            IconPath = $SavePath
                        }
                        $SavedIcons.Add($SavedObj)
                        Remove-Variable SavedObj -Force -ErrorAction Ignore
                    }
                    catch {
                        Write-Warning ('Failed to download {0}. Error: {1}' -f $Icon, $_.Exception.Message)
                    }
                }
                Write-Verbose ('All downloads completed. Files saved to: {0}' -f $OutDir)
                $SavedIcons
            }
            else {
                $Icons
            }
        }
        else {
            Write-Warning 'No favicon or logo found on this URL.'
        }
    }
    catch {
        $e = [System.Management.Automation.ErrorRecord]$_
        [pscustomobject]@{
            Type = $e.Exception.GetType().FullName
            Exception = $e.Exception.Message
            Reason = $e.CategoryInfo.Reason
            Target = $e.CategoryInfo.TargetName
            Script = $e.InvocationInfo.ScriptName
            Message = $e.InvocationInfo.PositionMessage
        } | Out-String | Write-Error
        throw $_
    }
    finally {
        $HttpClient.Dispose()
    }
}
