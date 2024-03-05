function Invoke-Download {
    <#
.SYNOPSIS
Downloads a file from a specified URL.

.DESCRIPTION
The Invoke-Download function downloads a file from the internet using a specified URL.
It supports various parameters to control the download process, such as setting a custom user agent,
specifying the destination folder, handling file overwrites, and showing download progress.

.PARAMETER URL
The URL of the file to download.

.PARAMETER Destination
The local path where the file will be downloaded. If not specified, the current directory will be used.

.PARAMETER FileName
The name of the file to save the download as. If not specified, the name is derived from the URL or content disposition.

.PARAMETER UserAgent
An array of user agent strings to use for the download request. Defaults to common browser user agents.

.PARAMETER TempPath
The temporary path where the file will be initially downloaded.

.PARAMETER IgnoreDate
If specified, the last modified date of the file won't be set.

.PARAMETER BlockFile
If specified, the downloaded file will be marked as coming from the internet (Windows only).

.PARAMETER NoClobber
If specified, existing files with the same name won't be overwritten.

.PARAMETER NoProgress
If specified, the download progress won't be displayed.

.PARAMETER PassThru
If specified, the downloaded file object will be output to the pipeline.

.EXAMPLE
Invoke-Download -URL 'http://example.com/file.zip' -Destination 'C:\Downloads'

# Downloads 'file.zip' from 'http://example.com' to the 'C:\Downloads' folder.

.EXAMPLE
'http://example.com/file.zip' | Invoke-Download -NoProgress

# Downloads 'file.zip' from 'http://example.com' to the current directory without showing progress.

.INPUTS
String
You can pipe a URL to Invoke-Download.

.OUTPUTS
System.IO.FileInfo
If -PassThru is specified, the function outputs the downloaded file object.

.NOTES
Source: https://github.com/DanGough/PsDownload/blob/main/PsDownload/Public/Invoke-Download.ps1
#>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [Alias('URI')]
        [ValidateNotNullOrEmpty()]
        [string]$URL,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination = $PWD.ProviderPath,

        [Parameter(Position = 2)]
        [string]$FileName,

        [string[]]$UserAgent = @('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', 'Googlebot/2.1 (+http://www.google.com/bot.html)'),

        [string]$TempPath = [System.IO.Path]::GetTempPath(),

        [switch]$IgnoreDate,
        [switch]$BlockFile,
        [switch]$NoClobber,
        [switch]$NoProgress,
        [switch]$PassThru
    )

    begin {
        # Required on Windows Powershell only
        if ($PSEdition -eq 'Desktop') {
            Add-Type -AssemblyName System.Net.Http
            Add-Type -AssemblyName System.Web
        }

        # Enable TLS 1.2 in addition to whatever is pre-configured
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

        # Create one single client object for the pipeline
        $HttpClient = [System.Net.Http.HttpClient]::new()
    }

    process {
        Write-Verbose ("Requesting headers from URL '{0}'" -f $URL)

        foreach ($UserAgentString in $UserAgent) {
            $null = $HttpClient.DefaultRequestHeaders.Remove('User-Agent')
            if ($UserAgentString) {
                Write-Verbose ("Using UserAgent '{0}'" -f $UserAgentString)
                $HttpClient.DefaultRequestHeaders.Add('User-Agent', $UserAgentString)
            }

            # This sends a GET request but only retrieves the headers
            $ResponseHeader = $HttpClient.GetAsync($URL, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result

            # Exit the foreach if success
            if ($ResponseHeader.IsSuccessStatusCode) {
                break
            }
        }

        if ($ResponseHeader.IsSuccessStatusCode) {
            Write-Verbose 'Successfully retrieved headers'

            if ($ResponseHeader.RequestMessage.RequestUri.AbsoluteUri -ne $URL) {
                Write-Verbose ("URL '{0}' redirects to '{1}'" -f $URL, $ResponseHeader.RequestMessage.RequestUri.AbsoluteUri)
            }

            try {
                $FileSize = $null
                $FileSize = [int]$ResponseHeader.Content.Headers.GetValues('Content-Length')[0]
                $FileSizeReadable = switch ($FileSize) {
                    { $_ -gt 1TB } { '{0:n2} TB' -f ($_ / 1TB); break }
                    { $_ -gt 1GB } { '{0:n2} GB' -f ($_ / 1GB); break }
                    { $_ -gt 1MB } { '{0:n2} MB' -f ($_ / 1MB); break }
                    { $_ -gt 1KB } { '{0:n2} KB' -f ($_ / 1KB); break }
                    default { '{0} B' -f $_ }
                }
                Write-Verbose ('File size: {0} bytes ({1})' -f $FileSize, $FileSizeReadable)
            }
            catch {
                Write-Verbose 'Unable to determine file size'
            }

            # Try to get the last modified date from the "Last-Modified" header, use error handling in case string is in invalid format
            try {
                $LastModified = $null
                $LastModified = [DateTime]::ParseExact($ResponseHeader.Content.Headers.GetValues('Last-Modified')[0], 'r', [System.Globalization.CultureInfo]::InvariantCulture)
                Write-Verbose ('Last modified: {0}' -f $LastModified.ToString())
            }
            catch {
                Write-Verbose 'Last-Modified header not found'
            }

            if ($FileName) {
                $FileName = $FileName.Trim()
                Write-Verbose ("Will use supplied filename '{0}'" -f $FileName)
            }
            else {
                # Get the file name from the "Content-Disposition" header if available
                try {
                    $ContentDispositionHeader = $null
                    $ContentDispositionHeader = $ResponseHeader.Content.Headers.GetValues('Content-Disposition')[0]
                    Write-Verbose ('Content-Disposition header found: {0}' -f $ContentDispositionHeader)
                }
                catch {
                    Write-Verbose 'Content-Disposition header not found'
                }
                if ($ContentDispositionHeader) {
                    $ContentDispositionRegEx = @'
^.*filename\*?\s*=\s*"?(?:UTF-8|iso-8859-1)?(?:'[^']*?')?([^";]+)
'@
                    if ($ContentDispositionHeader -match $ContentDispositionRegEx) {
                        # GetFileName ensures we are not getting a full path with slashes. UrlDecode will convert characters like %20 back to spaces.
                        $FileName = [System.IO.Path]::GetFileName([System.Web.HttpUtility]::UrlDecode($Matches[1]))
                        # If any further invalid filename characters are found, convert them to spaces.
                        [System.IO.Path]::GetinvalidFileNameChars() | ForEach-Object { $FileName = $FileName.Replace($_, ' ') }
                        $FileName = $FileName.Trim()
                        Write-Verbose ("Extracted filename '{0}' from Content-Disposition header" -f $FileName)
                    }
                    else {
                        Write-Verbose 'Failed to extract filename from Content-Disposition header'
                    }
                }

                if ([string]::IsNullOrEmpty($FileName)) {
                    # If failed to parse Content-Disposition header or if it's not available, extract the file name from the absolute URL to capture any redirections.
                    # GetFileName ensures we are not getting a full path with slashes. UrlDecode will convert characters like %20 back to spaces. The URL is split with ? to ensure we can strip off any API parameters.
                    $FileName = [System.IO.Path]::GetFileName([System.Web.HttpUtility]::UrlDecode($ResponseHeader.RequestMessage.RequestUri.AbsoluteUri.Split('?')[0]))
                    [System.IO.Path]::GetinvalidFileNameChars() | ForEach-Object { $FileName = $FileName.Replace($_, ' ') }
                    $FileName = $FileName.Trim()
                    Write-Verbose ("Extracted filename '{0}' from absolute URL '{1}'" -f $FileName, $ResponseHeader.RequestMessage.RequestUri.AbsoluteUri)
                }
            }
        }
        else {
            Write-Verbose 'Failed to retrieve headers'
        }

        if ([string]::IsNullOrEmpty($FileName)) {
            # If still no filename set, extract the file name from the original URL.
            # GetFileName ensures we are not getting a full path with slashes. UrlDecode will convert characters like %20 back to spaces. The URL is split with ? to ensure we can strip off any API parameters.
            $FileName = [System.IO.Path]::GetFileName([System.Web.HttpUtility]::UrlDecode($URL.Split('?')[0]))
            [System.IO.Path]::GetInvalidFileNameChars() | ForEach-Object { $FileName = $FileName.Replace($_, ' ') }
            $FileName = $FileName.Trim()
            Write-Verbose ("Extracted filename '{0}' from original URL '{1}'" -f $FileName, $URL)
        }

        $DestinationFilePath = Join-Path $Destination $FileName

        # Exit if -NoClobber specified and file exists.
        if ($NoClobber -and (Test-Path -LiteralPath $DestinationFilePath -PathType Leaf)) {
            Write-Error 'NoClobber switch specified and file already exists'
            return
        }

        # Open the HTTP stream
        $ResponseStream = $HttpClient.GetStreamAsync($URL).Result

        if ($ResponseStream.CanRead) {

            # Check TempPath exists and create it if not
            if (-not (Test-Path -LiteralPath $TempPath -PathType Container)) {
                Write-Verbose ("Temp folder '{0}' does not exist" -f $TempPath)
                try {
                    $null = New-Item -Path $Destination -ItemType Directory -Force
                    Write-Verbose ("Created temp folder '{0}'" -f $TempPath)
                }
                catch {
                    Write-Error ("Unable to create temp folder '{0}': {1}" -f $TempPath, $_)
                    return
                }
            }

            # Generate temp file name
            $TempFileName = '{0}.tmp' -f [guid]::NewGuid().ToString('N')
            $TempFilePath = Join-Path $TempPath $TempFileName

            # Check Destiation exists and create it if not
            if (-not (Test-Path -LiteralPath $Destination -PathType Container)) {
                Write-Verbose ("Output folder '{0}' does not exist" -f $Destination)
                try {
                    $null = New-Item -Path $Destination -ItemType Directory -Force
                    Write-Verbose ("Created output folder '{0}'" -f $Destination)
                }
                catch {
                    Write-Error ("Unable to create output folder '{0}': {1}" -f $Destination, $_)
                    return
                }
            }

            # Open file stream
            try {
                $FileStream = [System.IO.File]::Create($TempFilePath)
            }
            catch {
                Write-Error ("Unable to create file '{0}': {1}" -f $TempFilePath, $_)
                return
            }

            if ($FileStream.CanWrite) {
                Write-Verbose ("Downloading to temp file '{0}'..." -f $TempFilePath)

                $Buffer = [byte[]]::new(64KB)
                $BytesDownloaded = 0
                $ProgressIntervalMs = 250
                $ProgressTimer = [datetime]::Now.AddMilliseconds(-$ProgressIntervalMs)

                while ($true) {
                    try {
                        # Read stream into buffer
                        $ReadBytes = $ResponseStream.Read($Buffer, 0, $Buffer.Length)

                        # Track bytes downloaded and display progress bar if enabled and file size is known
                        $BytesDownloaded += $ReadBytes
                        if (!$NoProgress -and ([datetime]::Now -gt $ProgressTimer.AddMilliseconds($ProgressIntervalMs))) {
                            if ($FileSize) {
                                $PercentComplete = [Math]::Floor($BytesDownloaded / $FileSize * 100)
                                Write-Progress -Activity ('Downloading {0}' -f $FileName) -Status ('{0} of {1} bytes ({2}%)' -f $BytesDownloaded, $FileSize, $PercentComplete) -PercentComplete $PercentComplete
                            }
                            else {
                                Write-Progress -Activity ('Downloading {0}' -f $FileName) -Status ('{0} of ? bytes' -f $BytesDownloaded) -PercentComplete 0
                            }
                            $ProgressTimer = [datetime]::Now
                        }

                        # If end of stream
                        if ($ReadBytes -eq 0) {
                            Write-Progress -Activity ('Downloading {0}' -f $FileName) -Completed
                            $FileStream.Close()
                            $FileStream.Dispose()
                            try {
                                Write-Verbose ("Moving temp file to destination '{0}'" -f $DestinationFilePath)
                                $DownloadedFile = Move-Item -LiteralPath $TempFilePath -Destination $DestinationFilePath -Force -PassThru
                            }
                            catch {
                                Write-Error ("Error moving file from '{0}' to '{1}': {2}" -f $TempFilePath, $DestinationFilePath, $_)
                                return
                            }
                            if ($IsWindows) {
                                if ($BlockFile) {
                                    Write-Verbose 'Marking file as downloaded from the internet'
                                    Set-Content -LiteralPath $DownloadedFile -Stream 'Zone.Identifier' -Value "[ZoneTransfer]`nZoneId=3"
                                }
                                else {
                                    Unblock-File -LiteralPath $DownloadedFile
                                }
                            }
                            if ($LastModified -and -not $IgnoreDate) {
                                Write-Verbose 'Setting Last Modified date'
                                $DownloadedFile.LastWriteTime = $LastModified
                            }
                            Write-Verbose 'Download complete!'
                            if ($PassThru) {
                                $DownloadedFile
                            }
                            break
                        }
                        $FileStream.Write($Buffer, 0, $ReadBytes)
                    }
                    catch {
                        Write-Error ('Error downloading file: {0}' -f $_)
                        Write-Progress -Activity ('Downloading {0}' -f $FileName) -Completed
                        $FileStream.Close()
                        $FileStream.Dispose()
                        break
                    }
                }
            }
        }
        else {
            Write-Error 'Failed to start download'
        }

        # Reset this to avoid reusing the same name when fed multiple URLs via the pipeline
        $FileName = $null
    }

    end {
        $HttpClient.Dispose()
    }
}
