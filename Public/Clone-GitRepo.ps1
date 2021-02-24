function Clone-GitRepo {
  <#
      .Synopsis
      Clone a Git Repository

      .EXAMPLE
      Clone-Git -Repo https://github.com/Woznet/WozTools.git -Path D:\git\repos
  #>
  [CmdletBinding(DefaultParameterSetName='ClipBoard')]
  [Alias('cgit')]
  param(
    # Git Repository to Clone
    [Parameter(ParameterSetName='Repo',Mandatory,ValueFromPipeline)]
    [String[]]$Repo,
    [Parameter(ParameterSetName='ClipBoard')]
    [switch]$ClipBoard,
    # Location the repository folder will be saved to
    [ValidateScript({
          if(-Not ($_ | Test-Path -PathType Container)) {
            throw ('Unable to locate - {0}' -f $_)
          }
          return $true
    })]
    [String]$Path = 'V:\git\repos'
  )
  Begin {
    if (-not ([Environment]::GetEnvironmentVariable('GIT_REDIRECT_STDERR',[EnvironmentVariableTarget]::Machine) -ne '2>&1')) {
      [Environment]::SetEnvironmentVariable('GIT_REDIRECT_STDERR','2>&1',[EnvironmentVariableTarget]::Machine)
      Start-Sleep -Seconds 3
      Update-SessionEnvironment
    }
    if (!(Get-Command -Name git.exe)) {
      throw 'Install git.exe'
    }
  }
  Process {
    $RepoLoc = switch ($PSCmdlet.ParameterSetName) {
      'ClipBoard' { Get-Clipboard ; break }
      'Repo' { $Repo ; break }
    }
    Invoke-InDirectory -Path $Path -ScriptBlock {
      foreach ($RepoUrl in $RepoLoc) {
        Write-Verbose -Message ('Cloning: {0}{1}{2}' -f $RepoUrl,"`n",$(Join-Path -Path $Path -ChildPath $(Split-Path -Path $RepoUrl -Leaf).Split('.')[0])) -Verbose
        git clone --recurse-submodules $RepoUrl
      }
    }
  }
}
