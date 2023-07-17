---
external help file: WozTools-help.xml
Module Name: WozTools
online version:
schema: 2.0.0
---

# Get-GitHubUserRepos

## SYNOPSIS
Download GitHub User Gists & Repositories

## SYNTAX

```
Get-GitHubUserRepos [-UserName] <String[]> [[-Path] <String>] [[-Exclude] <String[]>]
 [[-ThrottleLimit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Uses git.exe to clone the gists and repositories of a github user.
Can Exclude repositories with names that match the string/strings defined with -Exclude
Requires Module - PowerShellForGitHub
Requires git.exe

I included the source file for PForEach because it is no longer visible in the powershellgallery and github
Vasily Larionov - https://www.powershellgallery.com/profiles/vlariono | https://github.com/vlariono
PForEach - https://www.powershellgallery.com/packages/PForEach

## EXAMPLES

### EXAMPLE 1
```
Get-GitHubUserRepos -UserName WozNet -Path 'V:\git\users' -Exclude 'docs'
```

### EXAMPLE 2
```
'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepos -Path 'V:\git\users' -Exclude 'azure,'office365'
```

## PARAMETERS

### -UserName
Param1 help - GitHub Usernames

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Param2 help - Directory to save User Gists and Repositories

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: V:\git\users
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
Param3 help - Exclude Repositories with Names matching these strings

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Docs
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleLimit
Param4 help - ThrottleLimit for Invoke-ForEachParallel

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
