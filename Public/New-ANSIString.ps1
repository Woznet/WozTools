function New-ANSIString {
  <#
      .Synopsis
      Generate ANSI escape code string for outputing text with color

      .DESCRIPTION
      Create ANSI color escape code using a RGB color value

      .EXAMPLE
      # Create variable with desired color
      $ANSI1 = New-ANSIString
      # Create variable to reset ANSI effects
      $Reset = New-ANSIString -Reset
      # String getting colored
      $Text = 'This is a test.  More testing... and testing'

      '{0}{1}{2}' -f $ANSI1,$Text,$Reset

      .EXAMPLE
      # Create variable with desired foreground color
      $ANSIFG1 = New-ANSIString -Red 55 -Green 120 -Blue 190 -Foreground
      # Create variable with desired background color
      $ANSIBG1 = New-ANSIString -Green 100 -Background
      # Create variable to reset ANSI effects
      $Reset = New-ANSIString -Reset
      # String getting colored
      $Text = 'This is a test.  More testing... and testing'
      $Text2 = 'More and more and more!'

      '{0}{1}{2}{3}{4}' -f $ANSIFG1,$Text,$ANSIBG1,$Text2,$Reset

      .OUTPUTS
      [string]

      .NOTES
      FYI: Remeber to reset the text style after every stylized text, otherwise the ANSI effects will continue to be applied to all that get output later.
  #>
  [CmdletBinding(
      DefaultParameterSetName='Foreground'
  )]
  [Alias('Get-ANSI')]
  [OutputType([String])]
  Param(
    # Red value
    [Parameter(
        ParameterSetName = 'Foreground',
        Position = 0
    )]
    [Parameter(
        ParameterSetName = 'Background',
        Position = 0
    )]
    [ValidateRange(0,255)]
    [int]$Red = (Get-Random -Minimum 0 -Maximum 255),
    # Green value
    [Parameter(
        ParameterSetName = 'Foreground',
        Position = 1
    )]
    [Parameter(
        ParameterSetName = 'Background',
        Position = 1
    )]
    [ValidateRange(0,255)]
    [int]$Green = (Get-Random -Minimum 0 -Maximum 255),
    # Blue value
    [Parameter(
        ParameterSetName = 'Foreground',
        Position = 2
    )]
    [Parameter(
        ParameterSetName = 'Background',
        Position = 2
    )]
    [ValidateRange(0,255)]
    [int]$Blue = (Get-Random -Minimum 0 -Maximum 255),
    # Apply RGB value to foreground
    [Parameter(ParameterSetName='Foreground')]
    [switch]$Foreground,
    # Apply RGB value to background
    [Parameter(ParameterSetName='Background')]
    [switch]$Background,
    # Reset ANSI effects
    [Parameter(ParameterSetName='Reset')]
    [switch]$Reset
  )
  Process {
    switch ($PSCmdlet.ParameterSetName) {
      'Foreground' {
        return ('{0}[38;2;{1};{2};{3}m' -f ([char]27), $Red, $Green, $Blue)
      }
      'Background' {
        return ('{0}[48;2;{1};{2};{3}m' -f ([char]27), $Red, $Green, $Blue)
      }
      'Reset' {
        return ('{0}[0m' -f ([char]27))
      }
      default {
        throw 'something went wrong....'
      }
    }
  }
}
