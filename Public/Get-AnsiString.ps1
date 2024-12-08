function Get-AnsiString {
    <#
.SYNOPSIS
    Builds an Ansi escape sequence string for setting the foreground or background color.

.DESCRIPTION
    The Get-AnsiString function generates an Ansi escape sequence string that can be used to set the foreground or background color in a console application. It supports specifying the color using RGB values or predefined color names.

.PARAMETER Red
    Specifies the red component of the RGB color. Must be an integer between 0 and 255. If not provided, a random value between 0 and 255 will be used.

.PARAMETER Green
    Specifies the green component of the RGB color. Must be an integer between 0 and 255. If not provided, a random value between 0 and 255 will be used.

.PARAMETER Blue
    Specifies the blue component of the RGB color. Must be an integer between 0 and 255. If not provided, a random value between 0 and 255 will be used.

.PARAMETER Color
    Specifies the color using a predefined color name. The available color names can be tab-completed. If not provided, a random RGB color will be used.

.PARAMETER ColorTarget
    Specifies whether the color should be applied to the foreground or background. Valid values are 'Foreground' and 'Background'. The default value is 'Foreground'.

.PARAMETER Reset
    Specifies whether to reset the color to the default. If this switch is present, all other parameters will be ignored.

.OUTPUTS
    System.String
    The Ansi escape sequence string that sets the specified color.

.EXAMPLE
    $Ansi = Get-AnsiString -Red 255 -Green 0 -Blue 0 -ColorTarget 'Foreground'
    $Reset = Get-AnsiString -Reset
    $Text = 'Add your text here...'
    '{0}{1}{2}' -f $Ansi, $Text, $Reset
    Saves the ANSI escape sequence for the color and reset Ansi strings to their own variables.
    To apply the color to text simply put the $Ansi variable before the text followed by the reset Ansi color to default.

.EXAMPLE
    $AnsiFG1 = Get-AnsiString -Red 55 -Green 120 -Blue 190 -ColorTarget 'Foreground'
    $AnsiBG1 = Get-AnsiString -Green 100 -ColorTarget 'Background'
    $Reset = Get-AnsiString -Reset
    $Text = 'This is a test.  More testing... and testing'
    $Text2 = 'More and more and more!'
    '{0}{1}{2}{3}{4}' -f $AnsiFG1, $Text, $AnsiBG1, $Text2, $Reset
    This example sets both the foreground and background colors for different parts of a text.

.EXAMPLE
    PS C:\> Get-AnsiString -Reset
    Returns the Ansi escape sequence string for resetting the color to the default.
#>
    [CmdletBinding(DefaultParameterSetName = 'RGB')]
    [Alias('Get-Ansi')]
    [OutputType([String])]
    param(
        [Parameter(ParameterSetName = 'RGB', Position = 0)]
        [ValidateRange(0, 255)]
        [int]$Red = (Get-Random -Minimum 0 -Maximum 255),

        [Parameter(ParameterSetName = 'RGB', Position = 1)]
        [ValidateRange(0, 255)]
        [int]$Green = (Get-Random -Minimum 0 -Maximum 255),

        [Parameter(ParameterSetName = 'RGB', Position = 2)]
        [ValidateRange(0, 255)]
        [int]$Blue = (Get-Random -Minimum 0 -Maximum 255),

        [Parameter(ParameterSetName = 'Color', Position = 0)]
        [ArgumentCompleter({
                param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
                try {
                    # Load System.Drawing or System.Drawing.Primitives assembly to access colors in System.Drawing.Color
                    if ($PSEdition -eq 'Desktop') {$null = Add-Type -AssemblyName System.Drawing -ErrorAction Stop}
                    else {$null = Add-Type -AssemblyName System.Drawing.Primitives -ErrorAction Stop}
                    $ColorType = [System.Drawing.Color]
                    $Colors = $ColorType.GetProperties([System.Reflection.BindingFlags]::Static -bor [System.Reflection.BindingFlags]::Public).Name
                    $Colors.Where({ $_ -like "$WordToComplete*" }).ForEach({[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)})
                }
                catch {
                    Write-Warning 'Could not load color properties from System.Drawing.Color'
                }
            })]
        [string]$Color,

        [ValidateSet('Foreground', 'Background')]
        [string]$ColorTarget = 'Foreground',

        [Parameter(ParameterSetName = 'Reset', Position = 0)]
        [switch]$Reset
    )
    Process {
        $ColorCodes = @{Foreground = 38; Background = 48}
        switch ($PSCmdlet.ParameterSetName) {
            'RGB' {
                $RGB = ($Red, $Green, $Blue) -join ';'
                $AnsiString = ('{0}[{2};2;{1}m' -f ([char]27), $RGB, $ColorCodes[$ColorTarget])
            }
            'Color' {
                $ColorObj = [System.Drawing.Color]::($Color)
                $RGB = ($ColorObj.R.ToString(), $ColorObj.G.ToString(), $ColorObj.B.ToString()) -join ';'
                $AnsiString = ('{0}[{2};2;{1}m' -f ([char]27), $RGB, $ColorCodes[$ColorTarget])
            }
            'Reset' {
                $AnsiString = ('{0}[0m' -f ([char]27))
            }
        }
        return $AnsiString
    }
}
