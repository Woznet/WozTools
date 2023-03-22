filter Write-ToASCIColor {
  <#
      .SYNOPSIS
      Writes the specified objects to the console with RGB Color Values

      .DESCRIPTION
      Writes object to the console using ANSI escape codes to change the color of the output using RGB values
      Default value for the RGB parameters is - Get-Random -Minimum 0 -Maximum 255
    
    
      `Write-Output` applies RGB color effect, enumerates through collection objects, apply ANSI reset code at end.

      .PARAMETER Red
      Int Value between 0 and 255

      .PARAMETER Green
      Int Value between 0 and 255

      .PARAMETER Blue
      Int Value between 0 and 255

      .PARAMETER InputObject
      Specifies the objects to send down the pipeline. Enter a variable that contains the objects, or type a command or expression that gets the objects.

      .INPUTS PSObject
      You can pipe objects to this cmdlet.
      Description of objects that can be piped to the script.

      .OUTPUTS PSObject
      This function returns the objects that are submitted as input with text color set using the specified RGB values.

      .EXAMPLE
      Get-ChildItem | Out-String | Write-ToASCIColor

      .EXAMPLE
      Write-ToASCIColor -Red 25 -Green 235 -Blue 123 'Test Bot 5000!'

      .LINK
      

      .NOTES
      Detail on what the script does, if this is needed.
  #>
  [CmdletBinding()]
  param(
    [Parameter()]
    [ValidateRange(0,255)]
    [int]$Red = $(Get-Random -Minimum 0 -Maximum 255),
    [Parameter()]
    [ValidateRange(0,255)]
    [int]$Green = $(Get-Random -Minimum 0 -Maximum 255),
    [Parameter()]
    [ValidateRange(0,255)]
    [int]$Blue = $(Get-Random -Minimum 0 -Maximum 255),
    [Parameter(ValueFromPipeline, Position = 0)]
    [PSObject]$InputObject
  )
  $esc = ([char]27)
  $Maybe = "$esc[38;2;$Red;$Green;${Blue}m",
  $InputObject,
  "$esc[0m" -join ''
  return $Maybe
}