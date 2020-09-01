function Get-GitUser {
  [Alias('dlgit')]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [String[]]$User,
    [ValidateScript( { Test-Path -Path $_ -PathType Container })]
    [Parameter(Mandatory)]
    [String]$Path,
    [int]$Throttle = 15
  )
  Begin {
    if (!(Import-Module PForEach -PassThru)) {
      throw 'Install Module - PForEach'
    }
    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    $htmltemplate = @'
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
  }
  Process {
    $Userp1 = $User
    $Userp2 = $User
    foreach ($GitUser in $Userp1 ) {
      $UserPath = Join-Path -Path $Path -ChildPath $GitUser
      if (Test-Path -Path $UserPath -PathType Container) {
        $gitrepo = Get-GitHubRepository -OwnerName $GitUser | Sort-Object -Property updated_at | Select-Object -Property name, updated_at
        <#
        $gitrepo | ForEach-Object -Begin { $a = @() } -Process {
          $q = if ( Test-Path -Path (Join-Path -Path $UserPath -ChildPath $_.name)) {
            (Get-ChildItem -Path $UserPath -Filter $_.name -Directory | Select-Object -ExpandProperty LastWriteTime).ToShortDateString()
          }
          else {
            Write-Output -InputObject 'N/A'
          }
          $a += [pscustomobject]@{
            Name            = $_.name
            'Git Updated'   = $_.updated_at.ToShortDateString()
            'Local Updated' = $q
          }
          $q = $null
        }
#>
        $a = $gitrepo | ForEach-Object -Process {
          $q = if ( Test-Path -Path (Join-Path -Path $UserPath -ChildPath $_.name)) {
            (Get-ChildItem -Path $UserPath -Filter $_.name -Directory | Select-Object -ExpandProperty LastWriteTime).ToShortDateString()
          }
          else {
            Write-Output -InputObject 'N/A'
          }
          [pscustomobject]@{
            Name            = $_.name
            'Git Updated'   = $_.updated_at.ToShortDateString()
            'Local Updated' = $q
          }
          $q = $null
        }
        $a | Out-GridView -PassThru | Select-Object -ExpandProperty name | ForEach-Object {
          $p1 = Join-Path -Path $UserPath -ChildPath $_ -Resolve -ErrorAction SilentlyContinue
          if ($p1) {
            Write-Output -InputObject ('Deleting: {0}' -f $p1)
            Remove-Item -Path $p1 -Recurse -Force
          }
          $p1 = $null
        }
      }
      else {
        Write-Output -InputObject ('{0} - has not been cloned yet' -f $GitUser)
      }
    }
    Write-Output -InputObject 'Next Step - Cloning Repos'
    foreach ($gitu in $Userp2) {
      Write-Progress -Id 2 -Activity ('Downloading Repository From: {0}' -f $gitu) -Status (('{0} of {1}...' -f $k, $User.count)) -PercentComplete (($k / $User.count) * 100)
      Write-Output -InputObject (("`n{1} Downloading Files from - {0}" -f $gitu, $(Get-Date -Format '%h:mm tt')))
      ### Get Gist Files
      <#
      $gist = Get-Gist -User $gitu
      if ($gist) {
        $loc = ('{0}\{1}\_gist' -f $Path, $gitu)
        $null =	if (!(Test-Path -Path $loc )) { New-Item -ItemType Directory -Path $loc }
        $gist | Sort-Object -Property updated_at | Get-Gist -File * -Destination $loc -Force
        # Create html Containing User Gist Files
        $htmltemplate.Replace("'-----'", ("'{0}'" -f $gitu)) | Out-File -Force -FilePath ('{0}\ShowAllGists-{1}.html' -f $loc, $gitu)
      }
      #>
      $loc = ('{0}\{1}\_gist' -f $Path, $gitu)
      Get-GitHubGist -UserName $gitu | Sort-Object -Property updated_at | Get-GitHubGist -Path $loc -Force
      New-Item -Path $loc -Name ('GitHubGist-{0}.html' -f $gitu) -ItemType File -Value $($htmltemplate.Replace('-----', ($gitu))) -ErrorAction Ignore
      ### Get GitRepos
      $repoloc = ('{0}\{1}' -f $Path, $gitu)
      $null =	if (!(Test-Path -Path $repoloc)) { New-Item -ItemType Directory -Path $repoloc }
      $g1 = Get-GitHubRepository -OwnerName $gitu
      Write-Output -InputObject ("{0}'s Repositories:" -f $gitu)
      Write-Output -InputObject $g1 | Format-Wide -AutoSize -Property name
      $g1.clone_url | Invoke-ForEachParallel -Process {
        Start-Process -WorkingDirectory $repoloc -FilePath "$env:ProgramFiles\Git\bin\git.exe" -ArgumentList ('clone --recursive {0}' -f $_) -WindowStyle Hidden -Wait
      } -ThrottleLimit $Throttle
      $k++
      $g1 = $null
    }
    $StopWatch.Stop()
  }
  end {
    Write-Output -InputObject ('Time - {0:m\:ss}' -f $StopWatch.Elapsed)
  }
}