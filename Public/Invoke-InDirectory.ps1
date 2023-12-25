function Invoke-InDirectory {
    <#
.SYNOPSIS
Executes a script block within the context of specified directories.  If a file is specified the script block is run in the directory of that file.

.DESCRIPTION
The Invoke-InDirectory function is designed to execute a provided script block in one or more specified directories.
This functionality is particularly useful for commands that are dependent on the current directory context, such as file system operations, git commands, or running scripts that use relative paths.

.PARAMETER Path
Specifies one or more paths in which the script block will be executed. When a file is specified the parent directory is used.
The function changes to each directory and executes the script block. This parameter accepts pipeline input and can be specified by property name.
A validation script ensures that each path provided exists.

.PARAMETER ScriptBlock
Defines the script block that will be executed in the context of each specified directory.
The script block should contain the commands that you want to run. This parameter is mandatory and cannot be empty.

.EXAMPLE
Invoke-InDirectory -Path 'C:\Projects\Project1' -ScriptBlock { Get-ChildItem }

# This example executes 'Get-ChildItem' in the 'C:\Projects\Project1' directory.

.EXAMPLE
Get-ChildItem -Path 'C:\Projects\' -Directory | Invoke-InDirectory -ScriptBlock { git status }

# This example fetches all directories under 'C:\Projects\' and runs 'git status' in each of them.

.EXAMPLE
'C:\Projects\Project1', 'C:\Projects\Project2' | Invoke-InDirectory -ScriptBlock { git pull }

# This example demonstrates using the function with pipeline input to execute 'git pull' in both 'C:\Projects\Project1' and 'C:\Projects\Project2'.

.INPUTS
System.String, System.IO.DirectoryInfo
You can pipe string paths, file objects, or directory objects to Invoke-InDirectory.

.OUTPUTS
Depends on the script block's output. The function outputs whatever the script block returns for each directory.

.NOTES
Remember to ensure that the script block commands are appropriate for the directory context and that they handle any relative path dependencies correctly.

.LINK
https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject
#>
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateScript({
                if (-not (Test-Path -Path $_)) {
                    throw 'Path does not exist'
                }
                return $true
            })]
        [Alias('FullName')]
        # Specifies one or more paths in which the script block will be executed.
        [String[]]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        # Defines the script block that will be executed in the context of each specified directory.
        [scriptblock]$ScriptBlock
    )
    process {
        foreach ($Loc in $Path) {
            if (Test-Path -Path $Loc -PathType Leaf) { $Loc = Split-Path -Path $Loc -Parent }
            try {
                Push-Location -Path $Loc
                . $ScriptBlock
            }
            finally {
                Pop-Location
            }
        }
    }
}
