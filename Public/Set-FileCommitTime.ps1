function Set-FileCommitTime {
    <#
.SYNOPSIS
Sets the last commit time as the last write time for files in a Git repository.

.DESCRIPTION
The `Set-FileCommitTime` function updates the last write time of files in a Git repository to match their last commit time. This can be useful for build systems, backup solutions, or any scenario where file timestamps need to reflect their version control history. The function supports processing paths from the pipeline and can operate in a verbose mode for additional output details. It also includes a stopwatch feature to measure the duration of the operation.

.PARAMETER Path
Specifies the path to the Git repository. This can be a full path or a relative path. If not specified, it defaults to the current working directory. The function verifies the existence of a .git directory at the specified path.

.PARAMETER PassThru
Returns an object with the path and updated commit time for each file processed. This parameter is useful for piping output to further processing commands.

.PARAMETER Stopwatch
Includes a stopwatch timer to measure the duration of the operation. When specified, the function outputs the total time taken to complete the process.

.EXAMPLE
Set-FileCommitTime -Path C:\Path\To\Repo

# Updates the last write time of all files in the specified Git repository to match their last commit time.

.EXAMPLE
Get-ChildItem -Path C:\Repos\ -Directory | Set-FileCommitTime -PassThru

# Finds all directories under C:\Repos and updates the file timestamps in each Git repository found. Outputs the details of the processed files.

.NOTES
- Requires Git to be installed and accessible in the system's PATH.
- The function is optimized for PowerShell 7.0 and above with parallel processing capabilities for improved performance. On versions below 7.0, the function will revert to sequential processing and issue a warning.

#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [ValidateScript({
                if (-not (Test-Path (Join-Path $_ '.git' -Resolve) -PathType Container)) {
                    throw ('Cannot find .git directory - {0}' -f $_)
                }
                return $true
            })]
        [Parameter(ValueFromPipeline)]
        [Alias('FullName')]
        # Specifies the path to the Git repository. This can be a full path or a relative path. If not specified, it defaults to the current working directory. The function verifies the existence of a .git directory at the specified path.
        [string]$Path = $PWD.ProviderPath,
        # Returns an object with the path and updated commit time for each file processed. This parameter is useful for piping output to further processing commands.
        [switch]$PassThru,
        # Includes a stopwatch timer to measure the duration of the operation. When specified, the function outputs the total time taken to complete the process.
        [switch]$Stopwatch
    )
    begin {
        try { $null = Get-Command -Name git -ErrorAction Stop }
        catch { throw 'Cannot find git.  Check to make sure it is installed.' }

        if ($Stopwatch) { $Timer = [System.Diagnostics.Stopwatch]::StartNew() }

        if ($PSVersionTable.PSVersion -ge '7.0') {
            Write-Verbose 'ForEach-Object Using: Parallel'
            $ParaName = 'Parallel'
        }
        else {
            Write-Verbose 'ForEach-Object Using: Process'
            Write-Warning ('"ForEach-Object -Parallel" is not supported in version {0}. Use 7.0+ for better performance.' -f $PSVersionTable.PSVersion.ToString())
            $ParaName = 'Process'
        }

        $GetCommitTime = @{
            $ParaName = {
                $CommitTime = git log -1 --format="%ai" -- $_
                [pscustomobject]@{
                    Path       = $_
                    CommitTime = $CommitTime
                }
            }
        }

        $ParseTime = @{
            $ParaName = {
                $pbj = $_
                $pbj.CommitTime = ([datetime]::ParseExact($pbj.CommitTime, 'yyyy-MM-dd HH:mm:ss K', $null))
                $pbj
            }
        }

        $SetFileTime = @{
            $ParaName = {
                $obj = $_
                try {
                    [System.IO.file]::SetLastWriteTime($obj.Path, $obj.CommitTime)
                }
                catch {
                    Write-Warning ('Failed: {0}' -f $obj.Path)
                    Write-Error -ErrorRecord $_
                }
                finally {
                    if ($PassThru) { $obj }
                }
            }
        }
    }
    process {
        Push-Location -Path $Path
        git ls-tree -r HEAD --name-only | ForEach-Object @GetCommitTime | ForEach-Object @ParseTime | ForEach-Object @SetFileTime
    }
    end {
        if ($Stopwatch) {
            $Timer.Stop()
            $Timer.Elapsed.TotalSeconds
        }
        Pop-Location
    }
}
