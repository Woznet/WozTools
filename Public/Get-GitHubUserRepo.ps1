function Get-GitHubUserRepo {
    <#
        .Synopsis
        Download GitHub User Gists & Repositories using REST API

        .DESCRIPTION
        Uses git.exe to clone the gists and repositories of a github user.
        Can Exclude repositories with names that match the string/strings defined with -Exclude

        Requires git.exe

        I included the source file for PForEach because it is no longer visible in the powershellgallery and github
        Vasily Larionov - https://www.powershellgallery.com/profiles/vlariono | https://github.com/vlariono
        PForEach - https://www.powershellgallery.com/packages/PForEach

        .PARAMETER UserName
        The name of the user whose repositories are to be downloaded

        .PARAMETER Path
        Directory where the user's repositories are to be downloaded.

        .PARAMETER Exclude
        Exclude repositories whose names match the string/strings defined with -Exclude

        .PARAMETER ThrottleLimit
        Specifies the number of script blocks to clone a specific repository that run in parallel.  The default value is 5.

        .PARAMETER FilterByLanguage
        When this switch is used it will filter repositories who language is not specified in the -Languages parameter.

        .PARAMETER Languages
        The languages to filter repositories for when FilterByLanguage switch is used.

        .EXAMPLE
        Get-GitHubUserRepo -UserName WozNet -Path 'V:\git\users' -Exclude 'docs'

        .EXAMPLE
        'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepo -Path 'V:\git\users' -Exclude 'azure,'office365'
    #>
    [CmdletBinding()]
    [Alias('dlgit')]
    Param(
        # Param1 help - GitHub Usernames
        [Parameter(
            Mandatory,
            HelpMessage = 'Github UserName',
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]$UserName,

        # Param2 help - Directory to save User Gists and Repositories
        [ValidateScript({
                Test-Path -Path $_ -PathType Container
            })]
        [String]$Path = 'D:\vlab\git\users',

        # Param3 help - Exclude Repositories with Names matching these strings
        [String[]]$Exclude = @('docs'),

        # Param4 help - ThrottleLimit for Invoke-ForEachParallel
        [int]$ThrottleLimit = 5,
        [switch]$FilterByLanguage,
        [string[]]$Languages = @('PowerShell', 'C#')
    )
    Begin {
        if (-not [System.IO.Path]::IsPathRooted($Path)) {
            Write-Warning 'Odd errors when -Path parameter is not a rooted path.'
            Write-Warning ('Attempting to get complete path using [System.IO.Path]::GetFullPath({0}).' -f $Path)
            $Path = [System.IO.Path]::GetFullPath($Path)
        }

        Push-Location -Path $PWD.ProviderPath -StackName StartingPath
        Push-Location -Path $Path

        try {
            if (-not (Get-Command -Name git.exe)) { throw 'git.exe is missing' }
            if (-not (Get-Command -Name Invoke-ForEachParallel -ErrorAction Ignore)) {
                Import-Module -Name ([System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent), 'Lib\PForEach\PForEach.dll')) -PassThru:$false -ErrorAction Stop
            }
        }
        catch {
            Write-CustomError -ErrorRecord $_
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

        # Download
        foreach ($GitUser in $UserName) {
            $UserPath = [System.IO.Path]::Combine($Path, $GitUser)
            $UserPathList.Add($UserPath)

            if (-not (Test-Path -Path $UserPath)) { $null = New-Item -Path $UserPath -ItemType Directory }
            Push-Location -Path $UserPath -StackName UserPath

            # Update GitHub repo using in each existing repo - git pull --all
            Get-ChildItem -Directory -Path $UserPath -Exclude '_gist' | Invoke-InDirectory -ScriptBlock {
                if (Test-Path -Path .git) { $null = git pull --all *>&1 }
            }

            # Get Gist
            $UserGist = Get-GitHubApiGist -UserName $GitUser
            if ($UserGist) {
                $GistDir = [System.IO.Path]::Combine($UserPath, '_gist')
                $TempGistDir = [System.IO.Path]::Combine($UserPath, '_tempgist')
                if (-not (Test-Path -Path $GistDir)) { $null = New-Item -Path $GistDir -ItemType Directory }
                if (-not (Test-Path -Path $TempGistDir)) { $null = New-Item -Path $TempGistDir -ItemType Directory }

                Get-ChildItem -Path $GistDir | Remove-Item -Recurse -Force
                Set-Content -Value ($HTML.Replace('---', $GitUser)) -Path ([System.IO.Path]::Combine($UserPath, '_gist.html')) -Force
                Write-Output ('{2}{0} Gists - {1}' -f $GitUser, $UserGist.Count, ("`n"))

                Push-Location -Path $TempGistDir
                ### Start Downloading Gist to temp dir
                $Count = 0
                $StartTime = Get-Date
                $UserGist | ForEach-Object -Process {
                    $Count++
                    Write-MyProgress -StartTime $StartTime -Object $UserGist -Count $Count
                    $UGist = $PSItem
                    Start-Process -WorkingDirectory $TempGistDir -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $UGist.git_pull_url) -WindowStyle Hidden -Wait
                    $UGistDir = Join-Path -Path $TempGistDir -ChildPath $UGist.id
          (Join-Path -Path $UGistDir -ChildPath . -Resolve), (Join-Path -Path $UGistDir -ChildPath * -Resolve) | Get-Item | ForEach-Object {
                        Write-Verbose ('Changing LastWriteTime to Gist updated_at value - {0}' -f $_.Name)
                        $_.LastWriteTime = $UGist.updated_at
                    }
                    $UGist, $UGistDir = $null
                    Start-Sleep -Milliseconds 50
                } -End { Write-MyProgress -Cleanup }

                ### Delete .git folders from cloned gist
                Get-ChildItem -Path $TempGistDir | ForEach-Object { Join-Path -Path $_ -ChildPath '.git' -Resolve } | Remove-Item -Recurse -Force

                ### Start Moving Gist from temp dir to $GistDir
                Get-ChildItem -Path $TempGistDir | ForEach-Object {
                    $TGDir = $_
                    $TGFiles = $TGDir | Get-ChildItem -Force:$false
                    if ($TGFiles.Count -eq 1) {
                        try {
                            $TGFiles | Move-Item -Destination $GistDir -PassThru:$false -ErrorAction Stop
                        }
                        catch [System.IO.IOException] {
                            'Shit happened! Attempting to rename and try moving again - {0}' -f $TGFiles.Name | Write-Warning
                            $TGFRenamed = $TGFiles | Rename-Item -NewName { $_.Name.Replace($_.BaseName, ('{0}-{1}' -f $_.BaseName, $_.Directory.Name.Substring(0, 6))) } -PassThru
                            $TGFRenamed | Move-Item -Destination $GistDir -PassThru:$false -ErrorAction Stop
                        }
                        $MCheck = $TGDir | Get-ChildItem -Force:$false
                        if ($MCheck.Count -eq 0) { Remove-Item -Path $TGDir -Recurse -Force }
                        else { Write-Warning ('{0} is not empty.{1}Files left - {2}' -f $TGDir.Name, "`n", $MCheck.Count) }
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
                Pop-Location -StackName UserPath
                ### Cleaning up Temp Gist Dir
                Remove-Item -Path $TempGistDir -Recurse -Force
            }

            # Get Repo
            $FilteredUserRepo = $UserRepo = Get-GitHubApiRepository -UserName $GitUser

            if ($Exclude) {
                $FilteredUserRepo = $FilteredUserRepo.Where({ $_.name -notmatch ($Exclude -join '|') })
            }
            if ($FilterByLanguage) {
                $FilteredUserRepo = $FilteredUserRepo.Where({ ($_ | Get-GitHubApiRepositoryLanguage).psobject.Properties.Name -match ($Languages -join '|') })
            }

            Write-Output ('{0}{1} Repositories - {2} (excluded - {3})' -f "`n", $GitUser, $FilteredUserRepo.Count, ($UserRepo.Count - $FilteredUserRepo.Count))
            $FilteredUserRepo.name | Select-Object -Property @{e = { if ($_.Length -gt 27) { $_.Substring(0, 24) + '...' } else { $_ } } } | Format-Wide -AutoSize
            $FilteredUserRepo | Invoke-ForEachParallel -ThrottleLimit $ThrottleLimit -Process {
                Start-Process -WorkingDirectory $UserPath -FilePath git.exe -ArgumentList ('clone --recursive {0}' -f $PSItem.clone_url) -WindowStyle Hidden -Wait

                Start-Sleep -Milliseconds 150

                $RepoUpdatedDate = $PSItem.updated_at
                $RepoDir = Get-Item -Path (Join-Path -Path $UserPath -ChildPath $PSItem.name -Resolve)
                $RepoFiles = $RepoDir | Get-ChildItem -Recurse -Force:$false -ErrorAction SilentlyContinue
                $RepoDir.LastWriteTime = $RepoUpdatedDate
                $RepoFiles.ForEach({ $_.LastWriteTime = $RepoUpdatedDate })
            }
        }
    }
    End {
        $StopWatch.Stop()
        'Time - {0:m\:ss}{1}' -f $StopWatch.Elapsed, ("`n")
        'Updated User Directories:'
        $UserPathList

        Pop-Location -StackName StartingPath
    }
}
