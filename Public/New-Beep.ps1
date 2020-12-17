function New-Beep {
  <#
      .SYNOPSIS
      Create Beep with System.Console dotnet class

      .PARAMETER Freq
      Frequency of the beep

      .PARAMETER Duration
      Duration of the beep

      .INPUTS
      interger

      .EXAMPLE
      New-Beep -Freq 700 -Duration 300
  #>
  [Alias('Beep')]
  param(
    [int]$Freq = 800,
    [int]$Duration = 200
  )
  [System.Console]::Beep($Freq,$Duration)
}
