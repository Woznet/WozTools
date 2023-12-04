function Get-EnvPath {
    <#
.SYNOPSIS
Retrieves the directories listed in the PATH environment variable.

.DESCRIPTION
The Get-EnvPath function lists all directories specified in the PATH environment variable for a specified scope: either the current user or the machine.

.PARAMETER VariableTarget
Specifies the scope of the environment variable. Acceptable values are 'Machine' and 'User'. The default is 'Machine'.

.EXAMPLE
Get-EnvPath
Lists all directories in the PATH environment variable for the machine.

.EXAMPLE
Get-EnvPath -VariableTarget User
Lists all directories in the PATH environment variable for the current user.

.OUTPUTS
System.String[]
Each line of output represents a directory in the PATH environment variable.

#>
    [CmdletBinding()]
    param(
        [Parameter()]
        [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
    )
    $SortedPath = [System.Environment]::GetEnvironmentVariable('PATH', $VariableTarget).
    Split(';').
    TrimEnd('\') | Sort-Object

    $SortedPath
}