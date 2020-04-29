function Copy-GitRepo {
  <#
      .Synopsis
      Clone a Git Repository

      .DESCRIPTION
      Long description

      .EXAMPLE
      Clone docusaurus to 'D:\git\repos\docusaurus'
      Clone-Git -Repo https://github.com/facebook/docusaurus.git -Path D:\git\repos

      .EXAMPLE
      Clone repo saved to the clipboard to 'D:\git\repos\clipboardrepo'
      Clone-Git -Path D:\git\repos

      .EXAMPLE
      Clone clipboard repo to .\clipboardrepo
      cgit
  #>
  [CmdletBinding(DefaultParameterSetName='ClipBoard')]
  [Alias('cgit')]
  param(
    # Git Repository to Clone
    [Parameter(ParameterSetName='Repo',Mandatory,Position = 0,ValueFromPipeline)]
    [String[]]$Repo,
    # Use Clipboard Value to pass repo url
    [Parameter(ParameterSetName='ClipBoard',Position = 0)]
    [switch]$ClipBoard,
    # Location the repository folder will be saved to
    [Parameter(,Position = 1)]
    [ValidateScript({
          if(-Not ([IO.Directory]::Exists($(Resolve-Path -Path $_))) ) {
            throw [IO.DirectoryNotFoundException]::new("Unable to locate - $_")
          }
          return $true
    })]
    [IO.DirectoryInfo]$Path = $PWD.Path
  )
  Begin {
    if ([Environment]::GetEnvironmentVariable('GIT_REDIRECT_STDERR',[EnvironmentVariableTarget]::Machine) -ne '2>&1') {
      [Environment]::SetEnvironmentVariable('GIT_REDIRECT_STDERR','2>&1',[EnvironmentVariableTarget]::Machine)
      Start-Sleep -Seconds 3
      Update-SessionEnvironment
    }
    if (!(Get-Command -Name git.exe)) {
      throw 'Install git.exe'
    }
    # Import-Module -Force -Name Microsoft.PowerShell.Management
    if ($PSCmdlet.ParameterSetName -eq 'ClipBoard') {
      # if (-not($((Microsoft.PowerShell.Management\Get-Clipboard -Format Text).Split('.')[-1]) -eq 'git')) {
      if (-not($((Microsoft.PowerShell.Management\Get-Clipboard).Split('.')[-1]) -eq 'git')) {
        throw 'The Clipboard does not appear to contain a git repo url'
      }
    }
    Write-Verbose -Message ("Setting `$Dir to {0}" -f $PWD.Path) -Verbose:$VerbosePreference
    $Dir = $PWD.Path
    $Loc = Resolve-Path -Path $Path
    Write-Verbose -Message ('Set-Location: {0}' -f $Loc) -Verbose:$VerbosePreference
    Set-Location -Path $Loc
  }
  Process {
    $RepoLoc = switch ($PSCmdlet.ParameterSetName) {
      # 'ClipBoard' { Get-Clipboard -Format Text ; break }
      'ClipBoard' { Get-Clipboard ; break }
      'Repo' { $Repo ; break }
      default { throw "Error setting `$RepoLoc" }
    }
    foreach ($RepoUrl in $RepoLoc) {
      Write-Verbose -Message ('Cloning: {0}{1}{2}' -f $RepoUrl,"`n",$(Join-Path -Path $Loc -ChildPath $(Split-Path -Path $RepoUrl -Leaf).Split('.')[0])) -Verbose
      git clone --recursive $RepoUrl
    }
  }
  End {
    Write-Verbose -Message ('Returning to : {0}' -f $Dir) -Verbose:$VerbosePreference
    Set-Location -Path $Dir
  }
}