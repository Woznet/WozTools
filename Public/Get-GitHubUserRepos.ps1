function Get-GitHubUserRepos {
  <#
      .Synopsis
      Download GitHub User Gists & Repositories

      .DESCRIPTION
      Uses git.exe to clone the gists and repositories of a github user.
      Can Exclude repositories with names that match the string/strings defined with -Exclude
      Requires Module - PowerShellForGitHub
      Requires git.exe

      I included the source file for PForEach because it is no longer visible in the powershellgallery and github
      Vasily Larionov - https://www.powershellgallery.com/profiles/vlariono | https://github.com/vlariono
      PForEach - https://www.powershellgallery.com/packages/PForEach

      .EXAMPLE
      Get-GitHubUserRepos -UserName WozNet -Path 'V:\git\users' -Exclude 'docs'

      .EXAMPLE
      'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepos -Path 'V:\git\users' -Exclude 'azure,'office365'
  #>
  [CmdletBinding()]
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

    # Param2 help - Directory to save User Gists and Repositories
    [ValidateScript({
          Test-Path -Path $_ -PathType Container
    })]
    [String]$Path = 'V:\git\users',

    # Param3 help - Exclude Repositories with Names matching these strings
    [String[]]$Exclude = 'docs',

    # Param4 help - ThrottleLimit for Invoke-ForEachParallel
    [int]$ThrottleLimit = 5
  )
  Begin {

    #####region Load Progress helper function

    function Write-MyProgress {
      <#
          .SYNOPSIS
          Displays a progress bar within a Windows PowerShell command window.

          .DESCRIPTION
          The Write-Progress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.

          .NOTES
          File Name   : Write-MyProgress.ps1
          Author      : Woz
          Date        : 2017-05-10
          Last Update : 2023-06-12
          Version     : 2.1.0

          .PARAMETER id
          Specifies an ID that distinguishes each progress bar from the others.

          .PARAMETER ParentId
          Specifies the parent activity of the current activity.

          .PARAMETER StartTime
          StartTime of the foreach processing

          .PARAMETER Object
          Object use in your foreach processing

          .PARAMETER Count
          Foreach Count variable

          .PARAMETER Cleanup
          Cleanup Write-Progress display in console

          .EXAMPLE
          $GetProcess = Get-Process

          $Count = 0
          $StartTime = Get-Date
          foreach($Process in $GetProcess) {
          $Count++
          Write-MyProgress -StartTime $StartTime -Object $GetProcess -Count $Count

          Write-Host "-> $($Process.ProcessName)"
          Start-Sleep -Seconds 1
          }

          .LINK

          Source
          https://github.com/Netboot-France/Write-MyProgress
      #>
      Param(
        [CmdletBinding(DefaultParameterSetName = 'Normal')]
        [Parameter(
            Mandatory,
            ParameterSetName = 'Normal'
        )]
        [Array]$Object,
        [Parameter(
            Mandatory,
            ParameterSetName = 'Normal'
        )]
        [DateTime]$StartTime,
        [Parameter(
            Mandatory,
            ParameterSetName = 'Normal'
        )]
        [Int]$Count,
        [Int]$Id = $null,
        [Int]$ParentId = -1,
        [Parameter(
            Mandatory,
            ParameterSetName = 'Cleanup'
        )]
        [switch]$Cleanup
      )

      switch ($PSCmdlet.ParameterSetName) {
        'Normal' {
          $SecondsElapsed = ([datetime]::Now - $StartTime).TotalSeconds
          $PercentComplete = ($Count / ($Object.Count)) * 100

          $Argument = @{}
          $Argument.Add('Activity', ('Processing {0} of {1}' -f $Count, $Object.Count))
          $Argument.Add('PercentComplete', $PercentComplete)
          $Argument.Add('CurrentOperation', ('{0:N2}% Complete' -f $PercentComplete))
          $Argument.Add('SecondsRemaining', ($SecondsElapsed / ($Count / $Object.Count)) - $SecondsElapsed)

          if ($Id -ne $null) { $Argument.Add('Id', $Id) }
          if ($ParentId -ne $null) { $Argument.Add('ParentId', $ParentId) }
      
          break
        }
        'Cleanup' {
          $Argument = @{}
          $Argument.Add('Completed', $true)
          $Argument.Add('Activity', 'Write-MyProgress Cleanup')
      
          break
        }
      }

      Write-Progress @Argument
  
    }

    #####endregion 


    try{
      if (-not (Get-Command -Name git.exe)) { throw 'git.exe is missing' }
      if (-not (Get-Module -ListAvailable -Name PowerShellForGitHub)) { throw 'Install Module - PowerShellForGitHub' }
      Import-Module -Name PowerShellForGitHub -PassThru:$false
      if (-not (Get-Command -Name Invoke-ForEachParallel -ErrorAction SilentlyContinue)) {
        # Import-Module -Name (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'Lib\PForEach\PForEach.dll' -Resolve) -PassThru:$false -ErrorAction Stop
        Import-Module -Name ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'Lib\PForEach\PForEach.dll')) -PassThru:$false -ErrorAction Stop
      }
      if (-not (Get-GitHubConfiguration -Name DisableTelemetry)) { Set-GitHubConfiguration -DisableTelemetry }
      if (-not (Test-GitHubAuthenticationConfigured)) { $Host.UI.WriteErrorLine('PowerShellForGitHub is not Authenticated') }
    }
    catch {
      [System.Management.Automation.ErrorRecord]$e = $_
      [PSCustomObject]@{
        Type      = $e.Exception.GetType().FullName
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
      throw $_
    }
    $HTML = @'
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
    $UserPathList = [System.Collections.Generic.List[string]]@()
    $StopWatch = [System.Diagnostics.Stopwatch]::New()
    $StopWatch.Start()
  }
  Process {

    $DelDir = [System.Collections.Generic.List[string]]@()
    foreach ($GitUser in $UserName) {
      $UserPath = [System.IO.Path]::Combine($Path,$GitUser)
      if (Test-Path -Path $UserPath -PathType Container) {
        Get-GitHubRepository -OwnerName $GitUser | Sort-Object -Property updated_at -Descending | ForEach-Object -Process {
          if ( $LPath = Join-Path -Path $UserPath -ChildPath $_.Name -Resolve -ErrorAction SilentlyContinue | Get-Item ) {
            [PSCustomObject]@{
              Name = $_.Name
              Git_Updated = $_.updated_at
              Local_Updated = $LPath.LastWriteTime
              GetItem = $LPath
            }
          }
        } | Where-Object {$_.Git_Updated -ge $_.Local_Updated} | Select-Object -ExpandProperty GetItem | ForEach-Object {
          $DelDir.Add($PSItem)
        }
      }
    }
    if ($DelDir) {
      Remove-Item -Path $DelDir -Recurse -Force
      if (Resolve-Path -Path $DelDir -ErrorAction Ignore) { Remove-Item -Path $DelDir -Recurse -Force }
    }
    Remove-Variable -Name DelDir -ErrorAction Ignore

    # Download
    foreach ($GitUser in $UserName) {
      $UserPath = [System.IO.Path]::Combine($Path,$GitUser)
      $UserPathList.Add($UserPath)

      if (-not (Test-Path -Path $UserPath)) { New-Item -Path $UserPath -ItemType Directory }

      # Get Gist
      $UserGist = Get-GitHubGist -UserName $GitUser
      if ($UserGist) {
        $GistDir = [System.IO.Path]::Combine($UserPath,'_gist')
        $TempGistDir = [System.IO.Path]::Combine($UserPath,'_tempgist')
        if (-not (Test-Path -Path $GistDir)) { New-Item -Path $GistDir -ItemType Directory }
        if (-not (Test-Path -Path $TempGistDir)) { New-Item -Path $TempGistDir -ItemType Directory }

        Get-ChildItem -Path $GistDir | Remove-Item -Recurse -Force
        Set-Content -Value ($HTML.Replace('---',$GitUser)) -Path ([System.IO.Path]::Combine($UserPath,'_gist.html')) -Force
        Write-Output ('{2}{0} Gists - {1}' -f $GitUser,$UserGist.Count,("`n"))

        ### Start Downloading Gist to temp dir
        $Count = 0
        $StartTime = Get-Date
        $UserGist | ForEach-Object -Process {
          $Count++
          Write-MyProgress -StartTime $StartTime -Object $UserGist -Count $Count
          $UGist = $PSItem
          Start-Process -WorkingDirectory $TempGistDir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $UGist.git_pull_url) -WindowStyle Hidden -Wait
          $UGist = $null
          Start-Sleep -Milliseconds 100
        }
        Write-MyProgress -Cleanup

        ### Start Moving Gist from temp dir to $GistDir
        Get-ChildItem $TempGistDir | ForEach-Object {
          $TGDir = $_
          Join-Path -Path $TGDir -ChildPath '.git' -Resolve | Remove-Item -Recurse -Force
          $TGFiles = $TGDir | Get-ChildItem -Force:$false
          $TGFileCount = $TGFiles.Count
          if ($TGFileCount -eq 1) {
            try {
              $TGFiles | Move-Item -Destination $GistDir -PassThru:$false -ErrorAction Stop
            }
            catch [System.IO.IOException] {
              'Shit happened! Attempting to rename and try moving again - {0}' -f $TGFiles.Name | Write-Warning
              $TGFiles | Rename-Item -NewName {$_.Name.Replace($_.BaseName,('{0}-{1}' -f $_.BaseName,$_.Directory.Name.Substring(0,6)))} -PassThru | Move-Item -Destination $GistDir -PassThru:$false -ErrorAction Stop
            }
            $MCheck = $TGDir | Get-ChildItem -Force:$false
            if ($MCheck.Count -eq 0) { Remove-Item -Path $TGDir -Recurse -Force }
          }
          else {
            try {
              $TGDir | Move-Item -Destination $GistDir -PassThru:$false -ErrorAction Stop
            }
            catch [System.IO.IOException] {
              Write-Error $_
            }
          }
        }
        ### Cleaning up Temp Gist Dir
        Remove-Item -Path $TempGistDir -Recurse -Force
      }

      # Get Repo
      $UserRepo = Get-GitHubRepository -OwnerName $GitUser
      $FilteredUserRepo = switch ($Exclude.Count) {
        {$_ -ge 1} { $UserRepo | Where-Object {$_.name -notmatch ($Exclude -join '|')} ; break }
        default { $UserRepo ; break }
      }
      Write-Output ('{0}{1} Repositories - {2} (excluded - {3})' -f "`n",$GitUser,$FilteredUserRepo.Count,($UserRepo.Count - $FilteredUserRepo.Count))
      $FilteredUserRepo.name| Select-Object -Property @{e={if ($_.Length -gt 27) {$_.Substring(0,24) + '...'} else{$_}}} | Format-Wide -AutoSize
      $FilteredUserRepo | Invoke-ForEachParallel -ThrottleLimit $ThrottleLimit -Process {
        Start-Process -WorkingDirectory $UserPath -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem.clone_url) -WindowStyle Hidden -Wait

        Start-Sleep -Milliseconds 150

        $RepoDir = Get-Item -Path (Join-Path -Path $UserPath -ChildPath $PSItem.name -Resolve)
        $RepoDir.LastWriteTime = $PSItem.updated_at
      }
    }
  }
  End {
    $StopWatch.Stop()
    'Time - {0:m\:ss}{1}' -f $StopWatch.Elapsed,("`n")
    'Updated User Directories:'
    $UserPathList
  }
}

