---
external help file: WozTools-help.xml
Module Name: WozTools
online version: https://github.com/Woznet/WozTools/blob/main/docs/Get-GitHubUserRepo.md
schema: 2.0.0
---

# Get-GitHubUserRepo

## SYNOPSIS
Download GitHub User Gists & Repositories using REST API

## SYNTAX

```
Get-GitHubUserRepo [-UserName] <String[]> [[-Path] <String>] [[-Exclude] <String[]>] [[-ThrottleLimit] <Int32>]
 [-FilterByLanguage] [[-Languages] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Uses git.exe to clone the gists and repositories of a github user.
Can Exclude repositories with names that match the string/strings defined with -Exclude

Requires git.exe

I included the source file for PForEach because it is no longer visible in the powershellgallery and github
Vasily Larionov - https://www.powershellgallery.com/profiles/vlariono | https://github.com/vlariono
PForEach - https://www.powershellgallery.com/packages/PForEach

## EXAMPLES

### EXAMPLE 1
```
Get-GitHubUserRepo -UserName WozNet -Path 'V:\git\users' -Exclude 'docs'
```

### EXAMPLE 2
```
'WozNet','PowerShell','Microsoft' | Get-GitHubUserRepo -Path 'V:\git\users' -Exclude 'azure,'office365'
```

## PARAMETERS

### -UserName
The name of the user whose repositories are to be downloaded

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Directory where the user's repositories are to be downloaded.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: D:\vlab\git\users
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
Exclude repositories whose names match the string/strings defined with -Exclude

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @('docs')
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleLimit
Specifies the number of script blocks to clone a specific repository that run in parallel. 
The default value is 5.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterByLanguage
When this switch is used it will filter repositories who language is not specified in the -Languages parameter.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Languages
The languages to filter repositories for when FilterByLanguage switch is used.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: @('PowerShell', 'C#')
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: System.Management.Automation.ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
