function Invoke-GitClone {
  <#
      .Synopsis
      Clone a Git Repository

      .EXAMPLE
      Invoke-GitClone -Repo https://github.com/Woznet/WozTools.git -Path D:\git\repos
  #>
  [CmdletBinding()]
  [Alias('Clone-GitRepo')]
  [Alias('cgit')]
  param(
    # Git Repository to Clone
    [Parameter(Mandatory,ValueFromPipeline)]
    [String[]]$Repo,
    # Location the repository folder will be saved to
    [ValidateScript({
          if(-Not ($_ | Test-Path -PathType Container)) {
            throw ('Unable to locate - {0}' -f $_)
          }
          return $true
    })]
    [String]$Path
  )
  Begin {
    if (-not ([Environment]::GetEnvironmentVariable('GIT_REDIRECT_STDERR') -eq '2>&1')) {
      [Environment]::SetEnvironmentVariable('GIT_REDIRECT_STDERR','2>&1',[System.EnvironmentVariableTarget]::Process)
      Start-Sleep -Seconds 1
      Update-SessionEnvironment
    }
    if (-not (Get-Command -Name git.exe)) { throw 'Install git.exe' }
    $RepoDir = [System.Collections.ArrayList]@()
    $null = $RepoDir.Add('')
  }
  Process {
    Invoke-InDirectory -Path $Path -ScriptBlock {
      foreach ($RepoUrl in $Repo) {
        $null = $RepoDir.Add([System.IO.Path]::Combine($Path, ((Split-Path -Path $RepoUrl -Leaf).Split('.')[0])))
        git clone --recurse-submodules $RepoUrl
      }
    }
  }
  end {
    $RepoDir
  }
}
