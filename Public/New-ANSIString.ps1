function New-ANSIString {
    <#
        .SYNOPSIS
        Generate ANSI escape code string for outputting text with color.

        .DESCRIPTION
        Create ANSI color escape code using a RGB color value. This function can generate strings to set text color (foreground), background color, or to reset text style to default.

        .EXAMPLE
        $ANSI1 = New-ANSIString
        $Reset = New-ANSIString -Reset
        $Text = 'This is a test.  More testing... and testing'
        '{0}{1}{2}' -f $ANSI1, $Text, $Reset
        This example demonstrates setting a random text color for a string and then resetting it.

        .EXAMPLE
        $ANSIFG1 = New-ANSIString -Red 55 -Green 120 -Blue 190 -Foreground
        $ANSIBG1 = New-ANSIString -Green 100 -Background
        $Reset = New-ANSIString -Reset
        $Text = 'This is a test.  More testing... and testing'
        $Text2 = 'More and more and more!'
        '{0}{1}{2}{3}{4}' -f $ANSIFG1, $Text, $ANSIBG1, $Text2, $Reset
        This example sets both the foreground and background colors for different parts of a text.

        .EXAMPLE
        $RedText = New-ANSIString -Red 255 -Foreground
        $Reset = New-ANSIString -Reset
        $Text = 'This text is red'
        '{0}{1}{2}' -f $RedText, $Text, $Reset
        This example shows creating a red text string.

        .OUTPUTS
        [string]
        The function outputs a string containing the ANSI escape code.

        .NOTES
        Remember to reset the text style after every stylized text, otherwise the ANSI effects will continue to be applied to all that get output later.
    #>
    [CmdletBinding(
        DefaultParameterSetName='Foreground'
    )]
    [Alias('Get-ANSI')]
    [OutputType([String])]
    Param(
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

        [Parameter(ParameterSetName='Foreground')]
        [switch]$Foreground,

        [Parameter(ParameterSetName='Background')]
        [switch]$Background,

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
                throw 'Invalid parameter set specified.'
            }
        }
    }
}
