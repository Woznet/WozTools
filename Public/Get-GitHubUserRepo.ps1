function Get-GitHubUserRepo {
  <#
      .Synopsis
      Download GitHub User Gists & Repositories

      .DESCRIPTION
      Requires Module - PowerShellForGitHub
      Requires git.exe
      PForEach - https://www.powershellgallery.com/packages/PForEach/ ; https://github.com/vlariono/PForEach

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
        HelpMessage='Github UserName',
        ValueFromPipeline
    )]
    [ValidateNotNullOrEmpty()]
    [String[]]$UserName,

    # Param2 help - Directory to save Repositories
    [ValidateScript({
          Test-Path -Path $_ -PathType Container
    })]
    [String]$Path = 'V:\git\users',

    # Param3 help - Exclude Repository with Names matching these strings
    [String[]]$Exclude,

    # Param4 help - ThrottleLimit for Invoke-ForEachParallel
    [int]$ThrottleLimit = 5
  )
  Begin {
    if (-not (Get-Command -Name git.exe)) { throw 'git.exe is missing' }
    if (-not (Get-Module -ListAvailable -Name PowerShellForGitHub)) { throw 'Install Module - PowerShellForGitHub' }
    Import-Module -Name PowerShellForGitHub -PassThru:$false
    Import-Module -Name (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'Lib\PForEach\PForEach.dll' -Resolve) -PassThru:$false
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
    $DelDir = [System.Collections.ArrayList]@()
    foreach ($GitUser in $UserName) {
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
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
          $null = $DelDir.Add($PSItem)
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
      $null = $UserPathList.Add($UserPath)

      if (-not (Test-Path -Path $UserPath)) {
        New-Item -Path $UserPath -ItemType Directory
      }
      # Get Gist
      $UserGist = Get-GitHubGist -UserName $GitUser
      if($UserGist) {
        $GistDir = Join-Path -Path $UserPath -ChildPath '_gist'
        if (-not (Test-Path -Path $GistDir)) {
          New-Item -Path $GistDir -ItemType Directory
        }
        Get-ChildItem -Path $GistDir | Remove-Item -Recurse -Force
        Set-Content -Value ($html.Replace('---',$GitUser)) -Path ([System.IO.Path]::Combine($UserPath,'_gist.html')) -Force
        Write-Output ('{0} Gists - {1}' -f $GitUser,$UserGist.Count)
        $UserGist | Invoke-ForEachParallel -ThrottleLimit $ThrottleLimit -Process {
          $UGist = $PSItem
          Start-Process -WorkingDirectory $GistDir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $UGist.git_pull_url) -WindowStyle Hidden -Wait

          $GistDLDir = Join-Path -Path $GistDir -ChildPath $UGist.Id -Resolve

          # Number of Files in Gist
          switch (($UGist.files|gm -MemberType NoteProperty | measure -Property Name).Count) {
            1 {
              # Move Gist File to Central Gist Folder
              'one'
              Join-Path -Path $GistDLDir -ChildPath ($UGist.files|gm -MemberType NoteProperty).Name -Resolve | Move-Item -Destination $GistDir
              Remove-Item -Path $GistDLDir -Recurse -ErrorAction SilentlyContinue -Force
              break
            }
            {$_ -gt 1} {
              # Gist Files Get Their Own Directory
              # Rename Dir Name from ID to name of the first file
              Rename-Item -Path $GistDLDir -NewName ($UGist.files|gm -MemberType NoteProperty)[0].Name

              break
            }
            default {'anything else' ; break }
          }


        }

        <#
            $GistDirectories = Get-ChildItem -Path $GistDir
            $GistFiles = $GistDirectories | Get-ChildItem | Where-Object {$_.PsIsContainer -eq $false}
            $Groupings = $GistFiles | Get-Item | Group-Object -Property Name
            foreach( $Gitem in $Groupings) {
            if ($Gitem.Count -ge 2) {
            $Gitem| Where-Object {$_.Count -gt 1} | ForEach-Object {
            # $gnum = $PSItem.Group
            $PSItem.Group | Rename-Item -NewName {$_.Name.Replace($_.BaseName,('{0}-{1}' -f $_.BaseName,$_.Directory.Name))} -PassThru | Move-Item -Destination $GistDir
            # Get-Item -Path $gnum | Rename-Item -NewName {$_.Name.Replace($_.BaseName,('{0}-{1}' -f $_.BaseName,$_.Directory.Name))} -PassThru | Move-Item -Destination $GistDir
            }
            }
            else{
            $Gitem.Group | Move-Item -Destination $GistDir
            }
            }
            $GistDirectories | Get-Item | Remove-Item -Recurse -Force
        #>

      }

      # Get Repo
      $UserRepo = Get-GitHubRepository -OwnerName $GitUser
      Write-Output ('{0}{1} - Repositories' -f "`n",$GitUser) ; $UserRepo | Format-Wide -Column 4
      $UserRepo | Invoke-ForEachParallel -ThrottleLimit $ThrottleLimit -Process {
        Start-Process -WorkingDirectory $UserPath -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem.clone_url) -WindowStyle Hidden -Wait

        # Set Repo Dir time to $PSItem.updated_at ($UserRepo)
        $RepoDir = Get-Item -Path (Join-Path -Path $UserPath -ChildPath $UserRepo.name -Resolve)
        $RepoDir.LastWriteTime = $PSItem.updated_at
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
