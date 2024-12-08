function Invoke-GitClone {
    [CmdletBinding()]
    [Alias('cgit')]
    param(
        # Git Repository to Clone
        [Parameter(Mandatory, ValueFromPipeline)]
        [String[]]$Repo,
        # Location the repository folder will be saved to
        [ValidateScript({
                if (-Not ($_ | Test-Path -PathType Container)) {
                    throw ('Unable to locate - {0}' -f $_)
                }
                return $true
            })]
        [String]$Path = $PWD.ProviderPath
    )
    Begin {
        if (-not ([Environment]::GetEnvironmentVariable('GIT_REDIRECT_STDERR') -eq '2>&1')) {
            [Environment]::SetEnvironmentVariable('GIT_REDIRECT_STDERR', '2>&1', [System.EnvironmentVariableTarget]::Process)
            Start-Sleep -Seconds 1
            Update-SessionEnvironment
        }
        if (-not (Get-Command -Name git.exe)) { throw 'Install git.exe' }
        $ClonedList = [System.Collections.Generic.List[string]]::new()
    }
    Process {
        Invoke-InDirectory -Path $Path -ScriptBlock {
            foreach ($RepoUrl in $Repo) {
                try {
                    git clone --recurse-submodules $RepoUrl
                    if ($LASTEXITCODE -ne 0) { throw 'git clone process had an error. LASTEXITCODE was not 0!' }
                    $ClonedList.Add([System.IO.Path]::Combine($Path, ((Split-Path -Path $RepoUrl -Leaf).Split('.')[0])))
                }
                catch {
                    [System.Management.Automation.ErrorRecord]$e = $_
                    [PSCustomObject]@{
                        Type = $e.Exception.GetType().FullName
                        Exception = $e.Exception.Message
                        Reason = $e.CategoryInfo.Reason
                        Target = $e.CategoryInfo.TargetName
                        Script = $e.InvocationInfo.ScriptName
                        Message = $e.InvocationInfo.PositionMessage
                    } | Out-String | Write-Error
                    Write-Error -ErrorRecord $_
                }
            }
        }
    }
    end {
        $ClonedList
    }
}
