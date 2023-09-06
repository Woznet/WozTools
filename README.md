# WozTools

## Overview

WozTools is a PowerShell module designed to provide a collection of utility functions and scripts that can help automate and simplify various tasks on your Windows system.

## Features

### Environment Management
- `Add-EnvPath.ps1`: Adds a path to the environment variable.
- `Get-EnvPath.ps1`: Retrieves the current environment path.

### Font Management
- `Add-Font.ps1`: Adds a new font to the system.

### PowerShell Module Management
- `Add-PSModulePath.ps1`: Adds a new path to the PowerShell module path.

### File Operations
- `Convert-FileLength.ps1`: Converts file length to different units.
- `Enable-FileSizeFormat.ps1`: Enables file size formatting.
- `Get-EnumerateFiles.ps1`: Enumerates files in a directory.

### Text Manipulation
- `Convertto-TitleCase.ps1`: Converts text to title case.
- `Format-CatchError.ps1`: Formats caught errors for better readability.

### User and System Information
- `Get-CommandParameterInfo.ps1`: Retrieves information about command parameters.
- `Get-CurrentUser.ps1`: Retrieves information about the current user.
- `Get-HostEntry.ps1`: Retrieves host entries.

### GitHub Utilities
- `Get-GitHubUserRepo.ps1`: Retrieves GitHub repositories for a specified user.

### Clipboard Utilities
- `Get-ItemFromClipboard.ps1`: Retrieves items from the clipboard.

### Windows Updates
- `Get-PSWinUpdates.ps1`: Retrieves Windows updates using PowerShell.

## Installation

To install WozTools, you can use the following PowerShell command:

```powershell
Install-Module -Name WozTools
```

## Usage

To use a function, simply import the module and call the function:

```powershell
Import-Module WozTools
Get-CurrentUser
```

## Contributing

If you would like to contribute to WozTools, please feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.
