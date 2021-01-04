function Get-GitHubUserRepo
{
  <#
      .Synopsis
      Download GitHub User Gists & Repositories

      .DESCRIPTION
      Requires Module - PowerShellForGitHub
      Requires Module - PForEach
      Requires git.exe

      .EXAMPLE
      Get-GitHubUserRepos -UserName WozNet -Path 'V:\git\users'

      .EXAMPLE
      'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepos -Path 'V:\git\users'
  #>
  [Alias('dlgit')]
  Param(
    # Param1 help - GitHub Usernames
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]$UserName,

    # Param2 help - Directory to save Repositories
    [ValidateScript({
          Test-Path -Path $_ -PathType Container
    })]
    [String]$Path = 'V:\git\users',

    # Param3 help - ThrottleLimit for Invoke-ForEachParallel
    [int]$ThrottleLimit = 5
  )
  Begin {
    if (-not (Get-Command -Name git.exe)) { throw 'git.exe is missing' }
    if (-not (Get-Module -ListAvailable -Name PowerShellForGitHub)) { throw 'Install Module - PowerShellForGitHub' }
    if (-not (Get-Module -ListAvailable -Name PForEach)) { throw 'Install Module - PForEach' }
    Import-Module -Name PowerShellForGitHub,PForEach -PassThru:$false
    if (-not (Get-GitHubConfiguration -Name DisableTelemetry)) { Set-GitHubConfiguration -DisableTelemetry }
    if (-not (Test-GitHubAuthenticationConfigured)) { $Host.UI.WriteErrorLine('PowerShellForGitHub is not Authenticated') }
    $html = @'
<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js'></script>
<div id="ph"></div>
<script>
var username = '---'
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
        $("#ph").append("<div><h2>" + data[i].description + "</h2></div>");
        $("#ph").append(scr.outerHTML);
        $("#ph").append('<div id="' + data[i].id + '"></div>');
    }
    document.write = oldDocumentWrite;
});
</script>
'@
    $UserPathList = [System.Collections.ArrayList]@()
    $StopWatch = [System.Diagnostics.Stopwatch]::New()
    $StopWatch.Start()
  }
  Process {
    # Manage Existing Contet
    $DelDir = @()
    foreach ($GitUser in $UserName) {
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
      $UserPathList.Add($UserPath)
      if (Test-Path -Path $UserPath -PathType Container) {
        Get-GitHubRepository -OwnerName $GitUser | Sort-Object -Property updated_at -Descending | ForEach-Object -Process {
          if ( $LPath = Join-Path -Path $UserPath -ChildPath $_.Name -Resolve -ErrorAction SilentlyContinue | Get-Item -ErrorAction SilentlyContinue ) {
            [PSCustomObject]@{
              Name = $_.Name
              Git_Updated = $_.updated_at
              Local_Updated = $LPath.LastWriteTime
              GetItem = $LPath
            }
          }
        } | Where-Object {$_.Git_Updated -ge $_.Local_Updated} | Select-Object -ExpandProperty GetItem | ForEach-Object {
          $DelDir += $PSItem
        }
      }
    }
    if($DelDir) {
      Remove-Item -Path $DelDir -Recurse -Force
      if(Resolve-Path -Path $DelDir -ErrorAction Ignore) { Remove-Item -Path $DelDir -Recurse -Force }
    }
    Remove-Variable -Name DelDir
    # Download
    foreach ($GitUser in $UserName) {
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
      if (-not (Test-Path -Path $UserPath)) {
        New-Item -Path $UserPath -ItemType Directory
      }
      # Get Gist
      $UserGist = Get-GitHubGist -UserName $GitUser
      if($UserGist) {
        $gistdir = Join-Path -Path $UserPath -ChildPath '_gist'
        if (-not (Test-Path -Path $gistdir)) {
          New-Item -Path $gistdir -ItemType Directory
        }
        Set-Content -Value ($html.Replace('---',$GitUser)) -Path ([System.IO.Path]::Combine($UserPath,'_gist.html')) -Force
        $UserGist.git_pull_url | Invoke-ForEachParallel -ThrottleLimit $ThrottleLimit -Process {
          Start-Process -WorkingDirectory $gistdir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
        }
      }
      # Get Repo
      $UserRepo = Get-GitHubRepository -OwnerName $GitUser
      "{0}'s Repositories" -f $GitUser ; $UserRepo | Format-Wide -Column 4
      $UserRepo.clone_url | Invoke-ForEachParallel -ThrottleLimit $ThrottleLimit -Process {
        Start-Process -WorkingDirectory $UserPath -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
      }
    }
  }
  End {
    $StopWatch.Stop()
    'Time - {0:m\:ss}{1}' -f $StopWatch.Elapsed,([System.Environment]::NewLine)
    'Saved to User Directories:'
    $UserPathList
  }
}
