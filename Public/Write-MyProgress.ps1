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
      Last Update : 2023-01-14
      Version     : 2.0.0

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

      .LINK

      Source
      https://github.com/Netboot-France/Write-MyProgress
  #>
  Param(
    [CmdletBinding()]
    [Parameter(Mandatory)]
    [Array]$Object,
    [Parameter(Mandatory)]
    [DateTime]$StartTime,
    [Parameter(Mandatory)]
    [Int]$Count,
    [Int]$Id = $null,
    [Int]$ParentId = -1
  )
  $SecondsElapsed = ((Get-Date) - $StartTime).TotalSeconds
  $SecondsRemaining = ($SecondsElapsed / ($Count / $Object.Count)) - $SecondsElapsed
  $PercentComplete = ($Count/($Object.Count)) * 100

  $Argument = @{}
  $Argument.Add('Activity', ('Processing {0} of {1}' -f $Count, $Object.Count))
  $Argument.Add('PercentComplete', $PercentComplete)
  $Argument.Add('CurrentOperation', ('{0:N2}% Complete' -f $PercentComplete))
  $Argument.Add('SecondsRemaining', $SecondsRemaining)

  if($Id -ne $null) { $Argument.Add('Id', $Id) }
  if($ParentId -ne $null) { $Argument.Add('ParentId', $ParentId) }

  Write-Progress @Argument
}
