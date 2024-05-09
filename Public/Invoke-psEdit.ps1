Function Invoke-psEdit {
    <#
.SYNOPSIS
Opens files in the PowerShell Integrated Scripting Environment (ISE) editor.

.DESCRIPTION
The Invoke-psEdit function is designed to open specified files directly in the PowerShell ISE editor. It is especially useful for quickly editing scripts or text files within the ISE environment.

.PARAMETER Path
Specifies the path(s) to the file(s) to be opened in PowerShell ISE. The function accepts multiple file paths and can also accept input from the pipeline.

.EXAMPLE
Invoke-psEdit -Path 'C:\Scripts\MyScript.ps1'
This example opens the file 'MyScript.ps1' located at 'C:\Scripts\' in PowerShell ISE.

.EXAMPLE
'C:\Scripts\Script1.ps1', 'C:\Scripts\Script2.ps1' | Invoke-psEdit
This example demonstrates the use of pipeline input to open multiple files in PowerShell ISE.

.INPUTS
System.String[]
You can pipe a string array of file paths to Invoke-psEdit.

.OUTPUTS
None
This function does not produce any output. It opens files in the PowerShell ISE.

.NOTES
This function only works within the PowerShell Integrated Scripting Environment (ISE). It will throw an error if executed in a different PowerShell host.

.LINK
https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/the-windows-powershell-ise?view=powershell-7.1
#>
    [CmdletBinding()]
    [Alias('psEdit')]
    param(
        [Parameter(
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            Mandatory
        )]
        [Alias('FullName')]
        [ValidateScript({
                if (-not (Test-Path -Path $_)) {
                    throw "Something went wrong.`nCheck Path - $_"
                }
                return $true
            })]
        [string[]]$Path
    )
    Begin {
        if (-not ($psISE)) {
            throw 'Invoke-psEdit is only available in PowerShell ISE.'
        }
        Write-Verbose -Message ('Starting - {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        foreach ($FileName in ($ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path))) {
            Write-Verbose -Message ('Opening - {0}' -f $FileName)
            $null = $psISE.CurrentPowerShellTab.Files.Add($FileName.ProviderPath)
        }
    }
    End {
        Write-Verbose -Message ('Ending - {0}' -f $MyInvocation.MyCommand)
    }
}
