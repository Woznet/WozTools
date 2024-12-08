function Write-MyProgress {
    <#
        .SYNOPSIS
        Displays a progress bar within a Windows PowerShell command window.

        .DESCRIPTION
        The Write-MyProgress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.

        .PARAMETER Object
        The collection of objects being processed in the loop.

        .PARAMETER Status
        A status message to display in the progress bar.

        .PARAMETER StartTime
        The start time of the process.

        .PARAMETER CounterValue
        The current position within the loop.

        .PARAMETER Id
        Specifies an ID that distinguishes each progress bar from the others.

        .PARAMETER ParentId
        Specifies the parent activity of the current activity.

        .PARAMETER Completed
        A switch parameter to clean up any uncleared progress bars.


        .EXAMPLE
        $GetProcess = Get-Process

        $CounterValue = 0
        $StartTime = Get-Date
        foreach($Process in $GetProcess) {
            $CounterValue++
            Write-MyProgress -StartTime $StartTime -Object $GetProcess -CounterValue $CounterValue

            Write-Host ('-> {0}' -f $Process.ProcessName)
            Start-Sleep -Seconds 1
        }
        Write-MyProgress -Completed

        .NOTES
        File Name   : Write-MyProgress.ps1
        Author      : Woz
        Date        : 2017-05-10
        Last Update : 2024-06-08
        Version     : 2.5.0
        Source      : https://github.com/Netboot-France/Write-MyProgress
    #>
    [CmdletBinding(DefaultParameterSetName = 'Normal')]
    param(
        [Parameter(Mandatory,ParameterSetName = 'Normal')]
        [ValidateNotNullOrEmpty()]
        [Array]$Object,

        [String]$Status,

        [Parameter(Mandatory,ParameterSetName = 'Normal')]
        [ValidateNotNull()]
        [DateTime]$StartTime,

        [Parameter(Mandatory,ParameterSetName = 'Normal')]
        [ValidateRange(0, [int]::MaxValue)]
        [Int]$CounterValue,

        [Int]$Id,

        [Int]$ParentId,

        [Parameter(Mandatory,ParameterSetName = 'Completed')]
        [switch]$Completed
    )
    try {
        switch ($PSCmdlet.ParameterSetName) {
            'Normal' {
                $SecondsElapsed = ([datetime]::Now - $StartTime).TotalSeconds
                $PercentComplete = ($CounterValue / ($Object.Count)) * 100

                $Argument = @{
                    Activity = "Object $CounterValue of $($Object.Count)"
                    PercentComplete = $PercentComplete
                    CurrentOperation = '{0:N2}% Complete' -f $PercentComplete
                    SecondsRemaining = ($SecondsElapsed / ($CounterValue / $Object.Count)) - $SecondsElapsed
                }

                if ($Id) { $Argument.Add('Id', $Id) }
                if ($ParentId) { $Argument.Add('ParentId', $ParentId) }
                if ($Status) { $Argument.Add('Status', $Status) } else {$Argument.Add('Status', 'Processing {0} of {1}' -f $CounterValue, $Object.Count)}

                Write-Progress @Argument
            }
            'Completed' {
                Write-Progress -Activity 'Write-MyProgress Completed' -Completed:$true
            }
        }
    }
    catch {
        $e = [System.Management.Automation.ErrorRecord]$_
        [pscustomobject]@{
            Type = $e.Exception.GetType().FullName
            Exception = $e.Exception.Message
            Reason = $e.CategoryInfo.Reason
            Target = $e.CategoryInfo.TargetName
            Script = $e.InvocationInfo.ScriptName
            Message = $e.InvocationInfo.PositionMessage
        } | Out-String | Write-Error
        Write-Error -ErrorRecord $_
    }
}
