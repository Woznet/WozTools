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
  [CmdletBinding()]
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
    if (-not (Get-Command -Name git.exe)){ throw 'git.exe is missing' }
    if (-not (Get-Module -ListAvailable -Name PowerShellForGitHub)) { throw 'Install Module - PowerShellForGitHub' }
    if (-not (Get-Module -ListAvailable -Name PForEach)){ throw 'Install Module - PForEach' }
    Import-Module -Name PowerShellForGitHub,PForEach -PassThru:$false
    $StopWatch = [System.Diagnostics.Stopwatch]::New()
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
    $StopWatch.Start()
  }
  Process {
    # Manage Existing Contet
    foreach ($GitUser in $UserName) {
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
      if (Test-Path -Path $UserPath -PathType Container) {
        Get-GitHubRepository -OwnerName $GitUser | Sort-Object -Property updated_at -Descending |  ForEach-Object -Process {
          if ( $LPath = Join-Path -Path $UserPath -ChildPath $_.Name -Resolve -ErrorAction SilentlyContinue | Get-Item -ErrorAction SilentlyContinue ) {
            [PSCustomObject]@{
              'Name' = $_.Name
              'Git Updated' = $_.updated_at.ToShortDateString()
              'Local Updated' = $LPath.LastWriteTime.ToShortDateString()
              'GetItem' = $LPath
            }
          }
        } | Out-GridView -PassThru | Select-Object -ExpandProperty GetItem | ForEach-Object {
          Write-Output -InputObject ('Deleting: {0}' -f $_.FullName)
          Remove-Item -Path $_ -Recurse -Force
        }
      }
    }
    
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
        $UserGist.git_pull_url | Invoke-ForEachParallel -Process {
          Start-Process -WorkingDirectory $gistdir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
        } -ThrottleLimit $ThrottleLimit
      }
      # Get Repo
      $UserRepo = Get-GitHubRepository -OwnerName $GitUser
      "{0}'s Repositories" -f $GitUser ; $UserRepo | Format-Wide -Column 4
      $UserRepo.clone_url | Invoke-ForEachParallel -Process {
        Start-Process -WorkingDirectory $UserPath -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
      } -ThrottleLimit $ThrottleLimit
    }
  }
  End {
    $StopWatch.Stop()
    'Time - {0:m\:ss}' -f $StopWatch.Elapsed
  }
}
