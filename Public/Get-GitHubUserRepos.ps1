function Get-GitHubUserRepos
{
  <#
      .Synopsis
      Download GitHub User Gists & Repositories
      .DESCRIPTION
      Requires pwsh version 7+
      Requires Module - PowerShellForGitHub
      Requires git.exe
      .EXAMPLE
      Get-GitHubUserRepos -UserName WozNet -Path 'V:\git\users'
      .EXAMPLE
      'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepos -Path 'V:\git\users'
      .NOTES
      Requires Module - PowerShellForGitHub
      Requires pwsh version 7+
  #>
  [CmdletBinding()]
  [Alias('dlgit')]
  Param
  (
    # Param1 help - GitHub Username
    [Parameter(Mandatory,
        ValueFromPipeline
    )]
    [ValidateNotNullOrEmpty()]
    [Alias('User')]
    [String[]]$UserName,

    # Param2 help - Directory to save Repositories
    [Parameter(Mandatory)]
    [ValidateScript({
          Test-Path -Path $_ -PathType Container
    })]
    [String]$Path
  )
  Begin
  {
    if ($PSVersionTable.PSVersion -le '7.0') {
      if (Get-Command -Name pwsh.exe) {
        $cmd = $MyInvocation.Line
        pwsh -NoProfile -Command ('& {0}' -f $cmd)
        return
      }
      else {
        throw 'Use PowerShell Core 7+'
      }
    }
    if ($PSVersionTable.PSVersion -le '7.0') { throw 'Use PowerShell Core 7+' }
    if (-not (Get-Command -Name git.exe)){ throw 'git.exe is missing' }
    if (-not (Get-Module -ListAvailable -Name PowerShellForGitHub)) {throw 'PowerShellForGitHub - is not installed'}
	Import-Module -Name PowerShellForGitHub -Force
    $StopWatch = [System.Diagnostics.Stopwatch]::New()
    $html = @'
<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'></script>
<div id="placeholder"></div>
<script>
var username = '-----'
$.getJSON('https://api.github.com/users/' + username + '/gists', function (data) {
    for (var i in data) {
        var oldDocumentWrite = document.write
        document.write = function (scr_content) {
            for (var i in data) {
                if ( $.trim( $("#" + data[i].id ).text() ).length == 0 ) {
                    $("#" + data[i].id ).append(scr_content);
                    return;
                }
            }
        }
        var scr = document.createElement('script');
        scr.src = 'https://gist.github.com/' + username + '/' + data[i].id + '.js';
        $("#placeholder").append("<div><h2>" + data[i].description + "</h2></div>");
        $("#placeholder").append(scr.outerHTML);
        $("#placeholder").append('<div id="' + data[i].id + '"></div>');
    }
    document.write = oldDocumentWrite;
});
</script>
'@
    $StopWatch.Start()
  }

  Process
  {
    foreach ($GUser in $UserName)
    {
      $user = $GUser
      $userdir = Join-Path -Path $Path -ChildPath $user
      if (-not (Test-Path -Path $userdir))
      {
        New-Item -Path $userdir -ItemType Directory
      }
      
      $UserGist = Get-GitHubGist -UserName $user
      if($UserGist)
      {
        $gistdir = Join-Path -Path $userdir -ChildPath '_gist'
        if (-not (Test-Path -Path $userdir))
        {
          New-Item -Path $gistdir -ItemType Directory
        }
        New-Item -Path $userdir -Name '_gist.html' -ItemType File -Value ($html.Replace('-----',$user)) -Force
        $UserGist.git_pull_url | ForEach-Object {
          #$gistdir = Join-Path -Path $userdir -ChildPath '_gist'
          Start-Process -WorkingDirectory $gistdir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
        }
      }
      
      $UserRepo = Get-GitHubRepository -OwnerName $user
      '{0}{1}s Repositories' -f $user,("'")
      $UserRepo | Format-Wide -Column 4
      $UserRepo.clone_url | ForEach-Object {
        $userdir = Join-Path -Path $Path -ChildPath $user
        Start-Process -WorkingDirectory $userdir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f ($PSItem)) -WindowStyle Hidden -Wait
      }
    }
  }

  End
  {
    $StopWatch.Stop()
    'Time - {0:m\:ss}' -f $StopWatch.Elapsed
  }
}
