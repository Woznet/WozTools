function Write-MyProgress {
  <#
      .SYNOPSIS
      Displays a progress bar within a Windows PowerShell command window.

      .DESCRIPTION
      The Write-Progress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.

      .NOTES
      File Name   : Write-MyProgress.ps1
      Author      : Woz
      Date        : 2017-05-10
      Last Update : 2023-06-12
      Version     : 2.1.0

      .PARAMETER id
      Specifies an ID that distinguishes each progress bar from the others.

      .PARAMETER ParentId
      Specifies the parent activity of the current activity.

      .PARAMETER StartTime
      StartTime of the process

      .PARAMETER Object
      Objects used in your foreach processing

      .PARAMETER CounterValue
      Current position within the loop

      .PARAMETER Completed
      Cleanup any uncleared Progress bars

      .EXAMPLE
      $GetProcess = Get-Process

      $CounterValue = 0
      $StartTime = Get-Date
      foreach($Process in $GetProcess) {
      $CounterValue++
      Write-MyProgress -StartTime $StartTime -Object $GetProcess -CounterValue $CounterValue

      Write-Host "-> $($Process.ProcessName)"
      Start-Sleep -Seconds 1
      }
      Write-MyProgress -Completed

      .NOTES
      https://github.com/Netboot-France/Write-MyProgress
  #>
  Param(
    [CmdletBinding(DefaultParameterSetName = 'Normal')]
    [Parameter(
        Mandatory,
        ParameterSetName = 'Normal'
    )]
    [Array]$Object,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Normal'
    )]
    [DateTime]$StartTime,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Normal'
    )]
    [Int]$CounterValue,
    [Int]$Id = $null,
    [Int]$ParentId = -1,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Completed'
    )]
    [switch]$Completed
  )

  switch ($PSCmdlet.ParameterSetName) {
    'Normal' {
      $SecondsElapsed = ([datetime]::Now - $StartTime).TotalSeconds
      $PercentComplete = ($CounterValue / ($Object.Count)) * 100

      $Argument = @{}
      $Argument.Add('Activity', ('Processing {0} of {1}' -f $CounterValue, $Object.Count))
      $Argument.Add('PercentComplete', $PercentComplete)
      $Argument.Add('CurrentOperation', ('{0:N2}% Complete' -f $PercentComplete))
      $Argument.Add('SecondsRemaining', ($SecondsElapsed / ($CounterValue / $Object.Count)) - $SecondsElapsed)

      if ($Id -ne $null) { $Argument.Add('Id', $Id) }
      if ($ParentId -ne $null) { $Argument.Add('ParentId', $ParentId) }

      break
    }
    'Completed' {
      $Argument = @{}
      $Argument.Add('Completed', $true)
      $Argument.Add('Activity', 'Write-MyProgress Completed')

      break
    }
  }

  Write-Progress @Argument

}
