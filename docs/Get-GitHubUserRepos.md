Get-GitHubUserRepos
-------------------
### Synopsis
Download GitHub User Gists & Repositories

---
### Description

Uses git.exe to clone the gists and repositories of a github user.
Can Exclude repositories with names that match the string/strings defined with -Exclude
Requires Module - PowerShellForGitHub
Requires git.exe

I included the source file for PForEach because it is no longer visible in the powershellgallery and github
Vasily Larionov - https://www.powershellgallery.com/profiles/vlariono | https://github.com/vlariono
PForEach - https://www.powershellgallery.com/packages/PForEach

---
### Examples
#### EXAMPLE 1
```PowerShell
Get-GitHubUserRepos -UserName WozNet -Path 'V:\git\users' -Exclude 'docs'
```

#### EXAMPLE 2
```PowerShell
'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepos -Path 'V:\git\users' -Exclude 'azure,'office365'
```

---
### Parameters
#### **UserName**

Param1 help - GitHub Usernames






|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[String[]]`|true    |1       |true (ByValue)|



---
#### **Path**

Param2 help - Directory to save User Gists and Repositories






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |



---
#### **Exclude**

Param3 help - Exclude Repositories with Names matching these strings






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |3       |false        |



---
#### **ThrottleLimit**

Param4 help - ThrottleLimit for Invoke-ForEachParallel






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |4       |false        |



---
### Syntax
```PowerShell
Get-GitHubUserRepos [-UserName] <String[]> [[-Path] <String>] [[-Exclude] <String[]>] [[-ThrottleLimit] <Int32>] [<CommonParameters>]
```
---
