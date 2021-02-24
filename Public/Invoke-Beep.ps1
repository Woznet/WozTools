function Invoke-Beep {
  <#
      .SYNOPSIS
      Invoke Console Beep

      .PARAMETER Freq
      Frequency of the beep, ranging from 37 to 32767 hertz

      .PARAMETER Duration
      Duration of the beep measured in milliseconds

      .EXAMPLE
      Invoke-Beep -Freq 700 -Duration 300
  #>
  [CmdletBinding()]
  [Alias('Beep')]
  param(
    [ValidateRange(37,32767)]
    [int]$Freqency = 800,
    [int]$Duration = 200
  )
  [System.Console]::Beep($Freqency,$Duration)
}
