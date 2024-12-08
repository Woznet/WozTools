function Set-GitFileCommitTime {
    <#
    .SYNOPSIS
    Sets the last commit time as the last write time for files in a Git repository.

    .DESCRIPTION
    Updates the last write time of files in a Git repository to match their last commit time.

    .PARAMETER Path
    Specifies the path to the Git repository. Defaults to the current working directory.

    .PARAMETER PassThru
    Returns an object with the path and updated commit time for each file processed.

    .EXAMPLE
    Set-GitFileCommitTime -Path C:\Path\To\Repo

    Updates file timestamps in the specified Git repository.

    .EXAMPLE
    Get-ChildItem -Path C:\Repos\ -Directory | Set-GitFileCommitTime -PassThru

    Processes multiple repositories and outputs updated file details.

    .NOTES
    - Requires Git to be installed and accessible in the system's PATH.
    - PowerShell 7.0+ is recommended for parallel processing.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
                if (-not (Test-Path (Join-Path $_ '.git'))) {
                    throw "Invalid path: $_. Missing '.git' directory."
                }
                return $true
            })]
        [string]$Path = $PWD.ProviderPath,
        [int]$ThrottleLimit = 12,
        [switch]$PassThru
    )
    begin {
        # Ensure Git is installed
        try { $null = Get-Command git -ErrorAction Stop}
        catch { throw "Git is not installed or not in the system's PATH." }

        # Check PowerShell version
        $ParallelSupported = $PSVersionTable.PSVersion -ge [Version]'7.0'
        $ParaParam = 'Parallel'
        if (-not ($ParallelSupported)) {
            Write-Warning 'Parallel processing is not available. Using sequential processing.'
            $ParaParam = 'Process'
        }
    }
    process {
        Push-Location -Path $Path
        try {
            # Get all files in the repository
            $Files = git ls-tree -r HEAD --name-only
            if ($null -eq $Files) {
                Write-Warning "No files found in repository: $Path"
                return
            }
            $FEParameter = @{
                $ParaParam = {
                    $File = $_

                    # Get commit time
                    $CommitTime = git log -1 --format="%ai" -- $File
                    $CommitDate = [datetime]::ParseExact($CommitTime, 'yyyy-MM-dd HH:mm:ss K', $null)

                    # Set file last write time
                    [System.IO.File]::SetLastWriteTime($File, $CommitDate)

                    # Return result if PassThru
                    if ($Using:PassThru) {
                        [pscustomobject]@{
                            Path = $File
                            CommitTime = $CommitDate
                        }
                    }
                }
            }
            if ($ParallelSupported) { $FEParameter.ThrottleLimit = $ThrottleLimit }
            $FileObjects = $Files | ForEach-Object @FEParameter
            # Output results
            if ($PassThru) { $FileObjects }
        }
        finally {
            Pop-Location
        }
    }
}
