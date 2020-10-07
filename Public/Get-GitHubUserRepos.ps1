function Get-GitHubUserRepos
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
  Param (
    # Param1 help - GitHub Usernames
    [Parameter(Mandatory,
        ValueFromPipeline
    )]
    [ValidateNotNullOrEmpty()]
    [Alias('User')]
    [String[]]$UserName,

    # Param2 help - Directory to save Repositories
    [ValidateScript({
          Test-Path -Path $_ -PathType Container
    })]
    [String]$Path = 'V:\git\users',
    
    # Param3 help - ThrottleLimit for Invoke-ForEachParallel
    [int]$ThrottleLimit = 15
  )
  Begin
  {
    if (-not (Get-Command -Name git.exe)){ throw 'git.exe is missing' }
    if (-not (Get-Module -ListAvailable -Name PowerShellForGitHub)) {throw 'Install Module - PowerShellForGitHub'}
    if (-not (Get-Module -ListAvailable -Name PForEach)){ throw 'Install Module - PForEach' }
    Import-Module -Global -Name PowerShellForGitHub,PForEach
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
    foreach ($GitUser in $UserName)
	{
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
      if (Test-Path -Path $UserPath -PathType Container)
	  {
        Get-GitHubRepository -OwnerName $GitUser | Sort-Object -Property updated_at -Descending |  ForEach-Object -Begin {$a = @()} -Process {
          $a += [pscustomobject]@{
            'Name' = $_.Name
            'Git Updated' = $_.updated_at.ToShortDateString()
            'Local Updated' = if ( Test-Path -Path (Join-Path -Path $UserPath -ChildPath $_.Name)) {
              (Get-ChildItem -Path $UserPath -Filter $_.Name -Directory | Select-Object -ExpandProperty LastWriteTime).ToShortDateString()
            }
            else { Write-Output -InputObject 'N/A' }
          }
        }
        $a | Out-GridView -PassThru | Select-Object -ExpandProperty Name | ForEach-Object {
          $p1 = Join-Path -Path $UserPath -ChildPath $_ -Resolve -ErrorAction SilentlyContinue
          if ($p1)
		  {
            Write-Output -InputObject ('Deleting: {0}' -f $p1)
            Remove-Item -Path $p1 -Recurse -Force
          }
          $p1 = $null
        }
      }
      else
	  {
        Write-Output -InputObject ('{0} - has not been cloned yet' -f $GitUser)
      }
    }

    foreach ($GitUser in $UserName)
    {
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
      if (-not (Test-Path -Path $UserPath))
      {
        New-Item -Path $UserPath -ItemType Directory
      }
      
      $UserGist = Get-GitHubGist -UserName $GitUser
      if($UserGist)
      {
        $gistdir = Join-Path -Path $UserPath -ChildPath '_gist'
        if (-not (Test-Path -Path $gistdir))
        {
          New-Item -Path $gistdir -ItemType Directory
        }
        New-Item -Path $UserPath -Name '_gist.html' -ItemType File -Value ($html.Replace('-----',$GitUser)) -Force
        $UserGist.git_pull_url | Invoke-ForEachParallel -Process {
          Start-Process -WorkingDirectory $gistdir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
        } -ThrottleLimit $ThrottleLimit
      }
      
      $UserRepo = Get-GitHubRepository -OwnerName $GitUser
      '{0}{1}s Repositories' -f $GitUser,("'")
      $UserRepo | Format-Wide -Column 4
      $UserRepo.clone_url | Invoke-ForEachParallel -Process {
        Start-Process -WorkingDirectory $UserPath -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem) -WindowStyle Hidden -Wait
      } -ThrottleLimit $ThrottleLimit
    }
  }

  End
  {
    $StopWatch.Stop()
    'Time - {0:m\:ss}' -f $StopWatch.Elapsed
  }
}
