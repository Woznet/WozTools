function Beep{
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
      Beep -Freq 700 -Duration 300
  #>
  param(
    [int]$Freq = 1100,
    [int]$Duration = 500
  )
  [System.Console]::Beep($Freq,$Duration)
}