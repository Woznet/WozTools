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
      StartTime of the foreach processing

      .PARAMETER Object
      Object use in your foreach processing

      .PARAMETER Count
      Foreach Count variable

      .PARAMETER Cleanup
      Cleanup Write-Progress display in console

      .EXAMPLE
      $GetProcess = Get-Process

      $Count = 0
      $StartTime = Get-Date
      foreach($Process in $GetProcess) {
      $Count++
      Write-MyProgress -StartTime $StartTime -Object $GetProcess -Count $Count

      Write-Host "-> $($Process.ProcessName)"
      Start-Sleep -Seconds 1
      }

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
    [Int]$Count,
    [Int]$Id = $null,
    [Int]$ParentId = -1,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Cleanup'
    )]
    [switch]$Cleanup
  )

  switch ($PSCmdlet.ParameterSetName) {
    'Normal' {
      $SecondsElapsed = ([datetime]::Now - $StartTime).TotalSeconds
      $PercentComplete = ($Count / ($Object.Count)) * 100

      $Argument = @{}
      $Argument.Add('Activity', ('Processing {0} of {1}' -f $Count, $Object.Count))
      $Argument.Add('PercentComplete', $PercentComplete)
      $Argument.Add('CurrentOperation', ('{0:N2}% Complete' -f $PercentComplete))
      $Argument.Add('SecondsRemaining', ($SecondsElapsed / ($Count / $Object.Count)) - $SecondsElapsed)

      if ($Id -ne $null) { $Argument.Add('Id', $Id) }
      if ($ParentId -ne $null) { $Argument.Add('ParentId', $ParentId) }

      break
    }
    'Cleanup' {
      $Argument = @{}
      $Argument.Add('Completed', $true)
      $Argument.Add('Activity', 'Write-MyProgress Cleanup')

      break
    }
  }

  Write-Progress @Argument

}
