function Convert-WSLPath {
    <#
.SYNOPSIS
Converts file paths between Windows and Windows Subsystem for Linux (WSL) formats.

.DESCRIPTION
The Convert-WSLPath function converts file paths from Windows format to WSL format and vice versa.
It leverages the wslpath command available in WSL to perform the conversion. The function can process multiple paths at once and can accept paths through the pipeline.
Note that this function requires WSL to be installed and accessible on the system.

.PARAMETER Path
Specifies the path(s) to convert. This parameter accepts an array of strings and can also accept input from the pipeline.

.PARAMETER ToWindows
Converts the specified path(s) from WSL format to Windows format.

.PARAMETER ToWSL
Converts the specified path(s) from Windows format to WSL format.
This is the default behavior if no parameter set is specified.

.EXAMPLE
Convert-WSLPath -Path '/mnt/c/Users/example' -ToWindows
C:\Users\example

Converts a WSL path to its Windows equivalent.

.EXAMPLE
'c:\Users\example' | Convert-WSLPath -ToWSL
/mnt/c/Users/example

Takes a Windows path from the pipeline and converts it to WSL format.

.NOTES
- Paths should be provided in the correct format for the desired conversion direction (WSL to Windows or vice versa). Mixing path formats is not supported and may result in errors.
- This function requires the Windows Subsystem for Linux (WSL) to be installed and accessible on the system.

.LINK
https://docs.microsoft.com/en-us/windows/wsl/

#>
    [CmdletBinding(DefaultParameterSetName = 'WSL')]
    [Alias('wslpath')]
    [OutputType()]
    Param(
        # Specifies the path(s) to convert
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [ValidateScript({
                if (-not ($_ | Test-Path -IsValid) ) {
                    throw 'Path is not valid'
                }
                return $true
            })]
        [string[]]$Path,
        # Converts the specified path(s) from WSL format to Windows format
        [Parameter(ParameterSetName = 'Win')]
        [switch]$ToWindows,
        # Converts the specified path(s) from Windows format to WSL format - Default
        [Parameter(ParameterSetName = 'WSL')]
        [switch]$ToWSL
    )
    Begin {
        if (-not (Get-Command -Name wsl.exe -ErrorAction Ignore)) {
            throw 'Cannot locate WSL'
        }
        $ConvertTo = switch ($PSCmdlet.ParameterSetName) {
            'WSL' { '-u' ; break }
            'Win' { '-w' ; break }
        }
    }
    Process {
        foreach ($Item in $Path) {
            $ArgString = 'wslpath', '-a', $ConvertTo, ($Item.Replace('\', '\\'))
            (& wsl.exe --exec $ArgString) -replace ([char][int]61532)
        }
    }
}
