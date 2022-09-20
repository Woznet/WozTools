#
# Module manifest for module 'WozTools'
#
# Generated by: Woz
#
# Generated on: 8/23/2022
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'WozTools.psm1'

# Version number of this module.
ModuleVersion = '2.0.0'

# Supported PSEditions
CompatiblePSEditions = 'Core', 'Desktop'

# ID used to uniquely identify this module
GUID = '5a1ff380-c976-4278-88ce-b95084745199'

# Author of this module
Author = 'Woz'

# Company or vendor of this module
CompanyName = 'Woz'

# Copyright statement for this module
Copyright = '(c) 2022 Woz. All rights reserved.'

# Description of the functionality provided by this module
Description = 'FYI: These are functions for personal use and may not work without minor alterations'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Add-EnvPath', 'Add-ISEText', 'Add-PSModulePath', 'Clone-GitRepo', 
               'Convertto-TitleCase', 'Get-ACLInfo', 'Get-CommandParameters', 
               'Get-ComObject', 'Get-CurrentUser', 'Get-EnumerateFiles', 'Get-EnvPath', 
               'Get-FunctionCode', 'Get-GitHubUserRepos', 'Get-ItemFromClipboard', 
               'Get-RedirectedUrl', 'Get-RelativePath', 'Get-StringFromSecureString', 
               'Invoke-Beep', 'Invoke-InDirectory', 'Invoke-psEdit', 'Invoke-WSLPath', 
               'Join-Url', 'New-ANSIString', 'New-DirandEnter', 'New-Shortcut', 
               'Open-NotepadPlusPlus', 'Open-Script', 'Out-ISETab', 'Push-GitChanges', 
               'Remove-EnvPath', 'Save-ISEFile', 'Search-WinCatalog', 
               'Select-GitHubLanguage', 'Set-AutoLogin', 'Set-ConsoleSize', 
               'Set-ConsoleWindow', 'Set-MaxPartitionSize', 'Start-ConsoleCommand', 
               'Start-PSLogging', 'Sync-Profile', 'Test-IfAdmin', 'Test-Url'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'Beep', 'cgit', 'Convert-SecureString', 'CUser', 'dlgit', 'dl-msu', 'FixCon', 
               'GitLang', 'InISE', 'Max-PartitionSize', 'mdc', 'Open', 'psEdit', 'scc', 
               'wslpath'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'LICENSE', 'README.md', 'WozTools.psd1', 'WozTools.psm1', 
               'Public\Add-EnvPath.ps1', 'Public\Add-ISEText.ps1', 
               'Public\Add-PSModulePath.ps1', 'Public\Clone-GitRepo.ps1', 
               'Public\Convertto-TitleCase.ps1', 'Public\Get-ACLInfo.ps1', 
               'Public\Get-CommandParameters.ps1', 'Public\Get-ComObject.ps1', 
               'Public\Get-CurrentUser.ps1', 'Public\Get-EnumerateFiles.ps1', 
               'Public\Get-EnvPath.ps1', 'Public\Get-FunctionCode.ps1', 
               'Public\Get-GitHubUserRepos.ps1', 'Public\Get-ItemFromClipboard.ps1', 
               'Public\Get-RedirectedUrl.ps1', 'Public\Get-RelativePath.ps1', 
               'Public\Get-StringFromSecureString.ps1', 'Public\Invoke-Beep.ps1', 
               'Public\Invoke-InDirectory.ps1', 'Public\Invoke-psEdit.ps1', 
               'Public\Invoke-WSLPath.ps1', 'Public\Join-Url.ps1', 
               'Public\New-ANSIString.ps1', 'Public\New-DirandEnter.ps1', 
               'Public\New-Shortcut.ps1', 'Public\Open-NotepadPlusPlus.ps1', 
               'Public\Open-Script.ps1', 'Public\Out-ISETab.ps1', 
               'Public\Push-GitChanges.ps1', 'Public\Remove-EnvPath.ps1', 
               'Public\Save-ISEFile.ps1', 'Public\Search-WinCatalog.ps1', 
               'Public\Select-GitHubLanguage.ps1', 'Public\Set-AutoLogin.ps1', 
               'Public\Set-ConsoleSize.ps1', 'Public\Set-ConsoleWindow.ps1', 
               'Public\Set-MaxPartitionSize.ps1', 
               'Public\Start-ConsoleCommand.ps1', 'Public\Start-PSLogging.ps1', 
               'Public\Sync-Profile.ps1', 'Public\Test-IfAdmin.ps1', 
               'Public\Test-Url.ps1', 'Lib\PForEach\PForEach.dll', 
               'Lib\AlphaFS\Net452\AlphaFS.dll', 'Lib\AlphaFS\Net452\AlphaFS.xml'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/Woznet/WozTools/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/Woznet/WozTools'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

